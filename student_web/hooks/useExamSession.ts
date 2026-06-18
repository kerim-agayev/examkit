"use client";

/**
 * useExamSession — Sınav oturum yönetim hook'u.
 * Firebase (Firestore + RTDB) ile Zustand store arasında köprü.
 * Offline cevap koruması: localStorage yedekleme.
 *
 * Kullanım:
 *   const { loading, error, exam, questions } = useExamSession(sessionId);
 */

import { useEffect, useState, useCallback, useRef } from "react";
import { useExamStore } from "@/stores/examStore";
import {
  getExamQuestions,
  saveAnswer as saveAnswerToFirestore,
  completeSession as completeSessionInFirestore,
  type Question,
} from "@/lib/firestore";
import {
  subscribeToExamStatus,
  joinWaitingRoom as joinRtdb,
  updateProgress,
  markCompleted,
  getRemainingMs,
} from "@/lib/realtime";
import type { AnswerValue } from "@/stores/examStore";

interface UseExamSessionOptions {
  sessionId: string;
  examId: string;
  studentName: string;
  mode: "scroll" | "sequential";
  globalTimerMinutes: number | null;
}

export function useExamSession(options: UseExamSessionOptions) {
  const { sessionId, examId, studentName, mode, globalTimerMinutes } = options;

  const store = useExamStore();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const initialized = useRef(false);

  // === Init: Fetch questions + subscribe ===
  useEffect(() => {
    if (initialized.current || !sessionId) return;
    initialized.current = true;

    async function init() {
      try {
        // 1. Fetch questions from Firestore
        let questions: Question[] = [];
        try {
          questions = await getExamQuestions(examId);
        } catch {
          // Fallback: Firestore yoksa mock ile devam et
          console.warn("[ExamKit] Firestore fetch failed — using mock questions");
          questions = getMockQuestions();
        }
        store.setQuestions(questions);

        // 2. Load answers from localStorage (page refresh recovery)
        try {
          const key = `exam_answers_${sessionId}`;
          const stored = JSON.parse(localStorage.getItem(key) || "{}");
          for (const [qId, entry] of Object.entries(stored) as [string, { value: AnswerValue }][]) {
            store.setAnswer(qId, entry.value);
          }
        } catch {
          // localStorage unavailable (private browsing vb.)
        }

        // 3. Join RTDB waiting room
        try {
          await joinRtdb(examId, sessionId, studentName);
        } catch {
          console.warn("[ExamKit] RTDB join failed — continuing offline");
        }

        setLoading(false);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Bilinmeyen hata");
        setLoading(false);
      }
    }

    init();
  }, [sessionId, examId, studentName, store]);

  // === RTDB Subscription: Exam Status ===
  useEffect(() => {
    if (!examId || loading) return;
    try {
      const unsub = subscribeToExamStatus(examId, (status) => {
        if (status === "active") {
          store.setStatus("active");
        }
      });
      return () => unsub();
    } catch {
      // RTDB unavailable
    }
  }, [examId, loading, store]);

  // === Global Timer ===
  useEffect(() => {
    if (!globalTimerMinutes || loading) return;
    const totalMs = globalTimerMinutes * 60 * 1000;
    store.setGlobalTimeLeft(totalMs);

    const interval = setInterval(() => {
      const remaining = (store as any).globalTimeLeft;
      if (remaining !== null && remaining > 0) {
        const next = Math.max(0, (remaining as number) - 1000);
        store.setGlobalTimeLeft(next);
        if (next === 0) {
          handleCompleteSession();
        }
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [globalTimerMinutes, loading]);

  // === Save Answer (Firestore + localStorage) ===
  const saveAnswer = useCallback(
    async (questionId: string, value: AnswerValue) => {
      // 1. Zustand (immediate)
      store.setAnswer(questionId, value);

      // 2. localStorage backup
      try {
        const key = `exam_answers_${sessionId}`;
        const stored = JSON.parse(localStorage.getItem(key) || "{}");
        stored[questionId] = { value, savedAt: Date.now() };
        localStorage.setItem(key, JSON.stringify(stored));
      } catch {
        // localStorage unavailable
      }

      // 3. Firestore (async, offline persistence handles retry)
      try {
        await saveAnswerToFirestore(sessionId, questionId, value);
        // 4. RTDB progress
        const answeredCount = Object.keys(store.answers).length + 1;
        await updateProgress(examId, sessionId, answeredCount);
      } catch {
        // Offline — Firestore persistence kuyruğa atar
      }
    },
    [sessionId, examId, store]
  );

  // === Complete Session ===
  const handleCompleteSession = useCallback(async () => {
    store.setStatus("completed");
    try {
      await completeSessionInFirestore(sessionId);
      await markCompleted(examId, sessionId);
    } catch {
      console.warn("[ExamKit] Complete session failed — will retry");
    }

    // localStorage temizle
    try {
      localStorage.removeItem(`exam_answers_${sessionId}`);
      localStorage.removeItem("examkit_session");
    } catch {
      // ignore
    }
  }, [sessionId, examId, store]);

  return {
    loading,
    error,
    questions: store.questions,
    answers: store.answers,
    status: store.status,
    saveAnswer,
    completeSession: handleCompleteSession,
  };
}

// === Mock fallback (Firestore yoksa) ===
function getMockQuestions(): Question[] {
  return [
    { id: "q1", text: "Mitoz bölünmenin temel amacı nedir?", type: "mcq", options: ["Enerji üretimi", "Büyüme ve onarım", "Sindirim", "Boşaltım"], points: 3, timerSeconds: null, orderIndex: 0 },
    { id: "q2", text: "DNA replikasyonu S fazasında gerçekleşir.", type: "true_false", points: 1, timerSeconds: null, orderIndex: 1 },
    { id: "q3", text: "Fotosentezin temel ürünü nedir?", type: "short_answer", points: 2, timerSeconds: 60, orderIndex: 2 },
    { id: "q4", text: "Hücre zarının yapısını açıklayan model hangisidir?", type: "mcq", options: ["Kilit-Anahtar", "Akıcı Mozaik Zar", "Çift Sarmal", "Endosimbiyoz"], points: 3, timerSeconds: null, orderIndex: 3 },
    { id: "q5", text: "Ribozomlar protein sentezinden sorumludur.", type: "true_false", points: 1, timerSeconds: null, orderIndex: 4 },
  ];
}
