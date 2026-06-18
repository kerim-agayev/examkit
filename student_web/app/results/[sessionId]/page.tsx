"use client";

/**
 * W7 — Sonuç Sayfası (/results/[sessionId])
 * Puan, sıralama, liderlik tablosu, soru inceleme.
 * Stitch referans: design/stitch_screens/renci_sonu_detay/code.html
 */

import { useParams } from "next/navigation";
import Link from "next/link";
import { QuestionCard } from "@/components/QuestionCard";
import type { AnswerValue } from "@/stores/examStore";

// Mock sonuç verisi — TODO: Firestore getSessionResult()
const mockResult = {
  score: 48,
  totalPoints: 50,
  percentage: 96,
  rank: 1,
  totalStudents: 8,
  durationMinutes: 18,
  durationSeconds: 32,
  correct: 46,
  wrong: 3,
  empty: 1,
  showLeaderboard: true,
  showCorrectAnswers: true,
  leaderboard: [
    { rank: 1, name: "Aynur Məmmədova", score: 48, isMe: true },
    { rank: 2, name: "Kamran Hüseynov", score: 44, isMe: false },
    { rank: 3, name: "Leyla Əsgərova", score: 41, isMe: false },
  ],
  questions: [
    { id: "q1", text: "Mitoz bölünmenin temel amacı nedir?", type: "mcq" as const, options: ["Enerji üretimi", "Büyüme ve onarım", "Sindirim", "Boşaltım"], points: 3, timerSeconds: null, orderIndex: 0, correctAnswer: "B" as AnswerValue, studentAnswer: "B" as AnswerValue },
    { id: "q2", text: "DNA replikasyonu S fazasında gerçekleşir.", type: "true_false" as const, points: 1, timerSeconds: null, orderIndex: 1, correctAnswer: true as AnswerValue, studentAnswer: true as AnswerValue },
    { id: "q3", text: "Fotosentezin temel ürünü nedir?", type: "short_answer" as const, points: 2, timerSeconds: null, orderIndex: 2, correctAnswer: "glukoz" as AnswerValue, studentAnswer: "" as AnswerValue },
  ],
};

export default function ResultsPage() {
  const params = useParams<{ sessionId: string }>();
  const sessionId = params.sessionId || "";

  const r = mockResult;

  return (
    <main className="min-h-screen bg-background">
      {/* Top bar */}
      <div className="sticky top-0 z-40 bg-surface border-b border-border px-4 py-3">
        <div className="max-w-[640px] mx-auto flex items-center justify-between">
          <Link
            href="/"
            className="inline-flex items-center gap-1 text-text-secondary hover:text-text-primary transition-colors text-sm"
          >
            <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" />
            </svg>
            Çıkış
          </Link>
          <h1 className="text-lg font-semibold text-text-primary">Sonuçlar</h1>
          <div className="w-12" /> {/* spacer */}
        </div>
      </div>

      <div className="max-w-[640px] mx-auto p-4 space-y-4 animate-fade-in-up">
        {/* === Score Hero Card === */}
        <div className="bg-surface rounded-2xl p-7 border border-border text-center space-y-4">
          <p className="text-sm text-text-secondary">Puanınız</p>
          <p className="text-[36px] font-bold text-text-primary leading-tight">
            {r.score} <span className="text-lg text-text-secondary font-normal">/ {r.totalPoints}</span>
          </p>

          {/* Circular progress */}
          <div className="flex justify-center">
            <div className="relative w-[88px] h-[88px]">
              <svg className="w-full h-full -rotate-90" viewBox="0 0 88 88">
                <circle cx="44" cy="44" r="38" fill="none" stroke="#E2E8F0" strokeWidth="6" />
                <circle
                  cx="44" cy="44" r="38"
                  fill="none"
                  stroke="#059669"
                  strokeWidth="6"
                  strokeLinecap="round"
                  strokeDasharray={`${(r.percentage / 100) * 239} 239`}
                />
              </svg>
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="text-[28px] font-bold text-success">{r.percentage}%</span>
              </div>
            </div>
          </div>

          {/* Rank */}
          {r.rank === 1 ? (
            <p className="text-base font-bold text-warning">🥇 Sınıfta 1. sıradasınız</p>
          ) : (
            <p className="text-base font-bold text-warning">🥇 Sınıfta {r.rank}. sıradasınız</p>
          )}

          {/* Duration */}
          <p className="text-sm text-text-secondary">
            {r.durationMinutes} dakika {r.durationSeconds} saniyede tamamladınız
          </p>
        </div>

        {/* === Summary Row === */}
        <div className="bg-surface rounded-2xl border border-border grid grid-cols-3 divide-x divide-border">
          <div className="py-4 text-center">
            <p className="text-lg font-bold text-success">{r.correct} ✓</p>
            <p className="text-xs text-text-secondary">Doğru</p>
          </div>
          <div className="py-4 text-center">
            <p className="text-lg font-bold text-error">{r.wrong} ✗</p>
            <p className="text-xs text-text-secondary">Yanlış</p>
          </div>
          <div className="py-4 text-center">
            <p className="text-lg font-bold text-text-disabled">{r.empty} –</p>
            <p className="text-xs text-text-secondary">Boş</p>
          </div>
        </div>

        {/* === Leaderboard === */}
        {r.showLeaderboard && (
          <div className="space-y-2">
            <h2 className="text-base font-semibold text-text-primary px-1">Sınıf Sıralaması</h2>
            <div className="bg-surface rounded-2xl border border-border divide-y divide-divider">
              {r.leaderboard.map((entry) => (
                <div
                  key={entry.rank}
                  className={`flex items-center gap-3 px-4 py-3 ${
                    entry.isMe ? "bg-primary-light/50" : ""
                  }`}
                >
                  <span className="w-7 text-center font-bold text-sm text-text-secondary">
                    {entry.rank === 1 ? "🥇" : entry.rank === 2 ? "🥈" : entry.rank === 3 ? "🥉" : entry.rank}
                  </span>
                  <span className={`flex-1 text-sm ${entry.isMe ? "font-bold text-primary-dark" : "text-text-primary"}`}>
                    {entry.name}
                  </span>
                  <span className="text-sm font-semibold text-text-primary">{entry.score} puan</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* === Question Review === */}
        {r.showCorrectAnswers && (
          <div className="space-y-2">
            <h2 className="text-base font-semibold text-text-primary px-1">Soru İnceleme</h2>
            <div className="space-y-2">
              {r.questions.map((q, i) => {
                const isCorrect = q.studentAnswer !== undefined && q.studentAnswer === q.correctAnswer;
                const isEmpty = q.studentAnswer === undefined || q.studentAnswer === "";
                return (
                  <QuestionCard
                    key={q.id}
                    question={q}
                    questionNumber={i + 1}
                    totalQuestions={r.questions.length}
                    selectedValue={q.studentAnswer}
                    onSelect={() => {}}
                    disabled={true}
                    showCorrect={true}
                    correctAnswer={q.correctAnswer}
                  />
                );
              })}
            </div>
          </div>
        )}

        {/* Bottom padding */}
        <div className="h-8" />
      </div>
    </main>
  );
}
