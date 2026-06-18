"use client";

/**
 * W4/W5 — Sınav Sayfası (/exam/[sessionId])
 * Firebase bağlantısı varsa useExamSession hook'u ile gerçek veri.
 * Yoksa mock veri ile graceful fallback.
 * Scroll modu: tüm sorular, sticky top bar + bottom submit.
 * Sequential modu: tek soru, İlerle butonu, onay akışı (ADR-005).
 */

import { useState, useCallback, useEffect } from "react";
import { useParams } from "next/navigation";
import { useExamStore } from "@/stores/examStore";
import { useExamSession } from "@/hooks/useExamSession";
import { TimerBar } from "@/components/TimerBar";
import { QuestionCard } from "@/components/QuestionCard";
import { ConfirmDialog } from "@/components/ConfirmDialog";
import type { AnswerValue } from "@/stores/examStore";

// Mock fallback (Firebase yoksa)
const MOCK_MODE: "scroll" | "sequential" = "sequential";
const MOCK_GLOBAL_MINUTES = 20;

function getMockQuestions() {
  return [
    { id: "q1", text: "Mitoz bölünmenin temel amacı nedir?", type: "mcq" as const, options: ["Enerji üretimi", "Büyüme ve onarım", "Sindirim", "Boşaltım"], points: 3, timerSeconds: null, orderIndex: 0 },
    { id: "q2", text: "DNA replikasyonu S fazasında gerçekleşir.", type: "true_false" as const, points: 1, timerSeconds: null, orderIndex: 1 },
    { id: "q3", text: "Fotosentezin temel ürünü nedir?", type: "short_answer" as const, points: 2, timerSeconds: 60, orderIndex: 2 },
    { id: "q4", text: "Hücre zarının yapısını açıklayan model hangisidir?", type: "mcq" as const, options: ["Kilit-Anahtar Modeli", "Akıcı Mozaik Zar Modeli", "Çift Sarmal Model", "Endosimbiyoz Modeli"], points: 3, timerSeconds: null, orderIndex: 3 },
    { id: "q5", text: "Ribozomlar protein sentezinden sorumludur.", type: "true_false" as const, points: 1, timerSeconds: null, orderIndex: 4 },
  ];
}

export default function ExamPage() {
  const params = useParams<{ sessionId: string }>();
  const sessionId = params.sessionId || "";

  // Firebase session hook (graceful: Firestore yoksa mock)
  const {
    loading,
    error,
    questions: fbQuestions,
    answers: fbAnswers,
    status: fbStatus,
    saveAnswer: fbSaveAnswer,
    completeSession: fbCompleteSession,
  } = useExamSession({
    sessionId,
    examId: "mock_exam_id",
    studentName: typeof window !== "undefined" ? localStorage.getItem("examkit_name") || "Öğrenci" : "Öğrenci",
    mode: MOCK_MODE,
    globalTimerMinutes: MOCK_GLOBAL_MINUTES,
  });

  // Zustand store
  const storedQuestions = useExamStore((s) => s.questions);

  // Firebase varsa onu, yoksa mock'u kullan
  const hasFirebase = fbQuestions.length > 0;
  const questions = hasFirebase ? fbQuestions : (storedQuestions.length > 0 ? storedQuestions : getMockQuestions());
  const answers = useExamStore((s) => s.answers);

  const {
    currentQuestionIndex,
    setAnswer,
    advanceToNext,
    status,
  } = useExamStore();

  const [examStatus, setExamStatus] = useState<"active" | "completed">("active");
  const [showConfirm, setShowConfirm] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [usedFallback, setUsedFallback] = useState(false);

  const mode = MOCK_MODE;
  const isLastQuestion = currentQuestionIndex >= questions.length - 1;
  const currentQuestion = questions[currentQuestionIndex];
  const hasAnswer = currentQuestion ? answers[currentQuestion.id] !== undefined : false;
  const answeredCount = Object.keys(answers).length;
  const unansweredCount = mode === "scroll" ? questions.length - answeredCount : 0;

  // On mount: if Firebase isn't configured, load mock silently
  useEffect(() => {
    if (!hasFirebase && storedQuestions.length === 0) {
      const mq = getMockQuestions();
      useExamStore.getState().setQuestions(mq);
      setUsedFallback(true);
    }
  }, [hasFirebase, storedQuestions.length]);

  // Global timer — Firebase hook handles it; fallback uses local
  const globalMs = MOCK_GLOBAL_MINUTES * 60 * 1000;

  const handleSelect = useCallback(
    (questionId: string, value: AnswerValue) => {
      setAnswer(questionId, value);
      // Firestore save (async, non-blocking)
      if (hasFirebase) {
        fbSaveAnswer(questionId, value);
      }
    },
    [setAnswer, hasFirebase, fbSaveAnswer]
  );

  const handleAdvance = useCallback(() => {
    if (isLastQuestion) {
      setShowConfirm(true);
    } else {
      // Lock-in animasyonu için kısa gecikme
      setTimeout(() => advanceToNext(), 150);
    }
  }, [isLastQuestion, advanceToNext]);

  const handleConfirmSubmit = useCallback(async () => {
    setShowConfirm(false);
    setSubmitted(true);
    setExamStatus("completed");

    if (hasFirebase) {
      await fbCompleteSession();
    }

    // localStorage temizle
    try {
      localStorage.removeItem("examkit_session");
      localStorage.removeItem("examkit_name");
    } catch {}

    setTimeout(() => {
      window.location.href = `/results/${sessionId}`;
    }, 2000);
  }, [sessionId, hasFirebase, fbCompleteSession]);

  // === Loading State ===
  if (loading) {
    return (
      <main className="min-h-screen flex items-center justify-center bg-background">
        <div className="text-center space-y-3">
          <div className="inline-block w-8 h-8 border-[3px] border-primary border-t-transparent rounded-full animate-spin" />
          <p className="text-text-secondary text-sm">Sınav yükleniyor...</p>
        </div>
      </main>
    );
  }

  // === Error State ===
  if (error) {
    return (
      <main className="min-h-screen flex items-center justify-center bg-background p-4">
        <div className="text-center space-y-3">
          <p className="text-error font-semibold">⚠️ Bir hata oluştu</p>
          <p className="text-text-secondary text-sm">{error}</p>
          <button
            className="px-6 h-10 bg-primary text-on-primary rounded-xl text-sm font-medium"
            onClick={() => window.location.reload()}
          >
            Tekrar Dene
          </button>
        </div>
      </main>
    );
  }

  // === W6: Completion Transition ===
  if (submitted) {
    return (
      <main className="min-h-screen flex items-center justify-center bg-background p-4">
        <div className="text-center space-y-5 animate-fade-in-up">
          <div className="flex justify-center">
            <svg className="w-20 h-20 text-success animate-draw-check" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
              <polyline points="22 4 12 14.01 9 11.01" />
            </svg>
          </div>
          <h1 className="text-[26px] font-bold text-text-primary">
            Sınav Tamamlandı! 🎉
          </h1>
          <p className="text-base text-text-secondary">Sonuçlar hesaplanıyor...</p>
          <div className="w-48 mx-auto h-1 bg-border rounded-full overflow-hidden">
            <div className="h-full w-1/2 bg-primary rounded-full animate-[pulse_1s_infinite]" />
          </div>
        </div>
      </main>
    );
  }

  // === Main Exam UI ===
  return (
    <main className="min-h-screen flex flex-col bg-background">
      {/* Sticky Top Bar */}
      <div className="sticky top-0 z-40 bg-surface border-b border-border px-4 py-3 shadow-sm">
        <div className="max-w-[640px] mx-auto flex items-center justify-between">
          <div className="flex-1 min-w-0 flex items-center gap-2">
            <p className="text-base font-semibold text-text-primary truncate">
              Biologiya Final
            </p>
            {usedFallback && (
              <span className="text-[10px] bg-warning-light text-warning px-1.5 py-0.5 rounded-full font-medium">
                DEMO
              </span>
            )}
          </div>
          <div className="flex items-center gap-3 shrink-0">
            {mode === "sequential" && (
              <span className="text-sm font-medium text-text-secondary">
                {currentQuestionIndex + 1} / {questions.length}
              </span>
            )}
            <TimerBar totalMs={globalMs} onExpired={handleConfirmSubmit} />
          </div>
        </div>
        {mode === "scroll" && (
          <div className="max-w-[640px] mx-auto mt-2">
            <div className="flex items-center justify-between text-xs text-text-secondary mb-1">
              <span>{answeredCount} / {questions.length} soru cevaplandı</span>
            </div>
            <div className="w-full h-1.5 bg-border rounded-full overflow-hidden">
              <div
                className="h-full bg-primary rounded-full transition-all duration-500"
                style={{ width: `${(answeredCount / questions.length) * 100}%` }}
              />
            </div>
          </div>
        )}
      </div>

      {/* Question Content */}
      <div className="flex-1 overflow-y-auto p-4">
        <div className="max-w-[640px] mx-auto space-y-3">
          {mode === "sequential" && currentQuestion && (
            <QuestionCard
              question={currentQuestion}
              questionNumber={currentQuestionIndex + 1}
              totalQuestions={questions.length}
              selectedValue={answers[currentQuestion.id]}
              onSelect={handleSelect}
            />
          )}
          {mode === "scroll" &&
            questions.map((q, i) => (
              <QuestionCard
                key={q.id}
                question={q}
                questionNumber={i + 1}
                totalQuestions={questions.length}
                selectedValue={answers[q.id]}
                onSelect={handleSelect}
              />
            ))}
        </div>
      </div>

      {/* Sticky Bottom */}
      <div className="sticky bottom-0 z-40 bg-surface border-t border-border p-4">
        <div className="max-w-[640px] mx-auto">
          {mode === "scroll" ? (
            <>
              {unansweredCount > 0 && (
                <p className="text-xs text-warning text-center mb-2 font-medium">
                  {unansweredCount} soru boş
                </p>
              )}
              <button
                className="w-full h-[56px] rounded-xl bg-success hover:bg-success/90 text-on-primary font-semibold text-lg shadow-sm transition-colors"
                onClick={() => setShowConfirm(true)}
              >
                Sınavı Gönder
              </button>
            </>
          ) : (
            <button
              className={`w-full h-[56px] rounded-xl font-semibold text-lg transition-all duration-200 ${
                hasAnswer
                  ? "bg-primary hover:bg-primary-dark text-on-primary shadow-sm active:scale-[0.98]"
                  : "bg-text-disabled text-on-primary cursor-not-allowed"
              }`}
              disabled={!hasAnswer}
              onClick={handleAdvance}
            >
              {isLastQuestion ? "Sınavı Tamamla ✓" : "İlerle →"}
            </button>
          )}
        </div>
      </div>

      <ConfirmDialog
        open={showConfirm}
        title="Sınavı tamamlamak istediğinize emin misiniz?"
        message="Cevaplarınız gönderilecek ve geri alınamaz."
        onCancel={() => setShowConfirm(false)}
        onConfirm={handleConfirmSubmit}
      />
    </main>
  );
}
