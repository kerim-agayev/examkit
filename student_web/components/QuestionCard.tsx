"use client";

/**
 * QuestionCard — Tekrar kullanılabilir soru bileşeni.
 * MCQ, Doğru/Yanlış, Kısa Cevap — üç tip soruyu da render eder.
 * Scroll ve sequential modlarda aynı bileşen kullanılır.
 */

import { type AnswerValue } from "@/stores/examStore";

interface Question {
  id: string;
  text: string;
  type: "mcq" | "true_false" | "short_answer";
  options?: string[];
  points: number;
  timerSeconds: number | null;
  orderIndex: number;
}

interface QuestionCardProps {
  question: Question;
  questionNumber: number;
  totalQuestions: number;
  selectedValue?: AnswerValue;
  onSelect: (questionId: string, value: AnswerValue) => void;
  disabled?: boolean;
  showCorrect?: boolean; // Sonuç ekranında doğru cevabı göstermek için
  correctAnswer?: AnswerValue; // Doğru cevap (sonuç ekranı için)
}

export function QuestionCard({
  question,
  questionNumber,
  totalQuestions,
  selectedValue,
  onSelect,
  disabled = false,
  showCorrect = false,
  correctAnswer,
}: QuestionCardProps) {
  const isCorrect =
    showCorrect && correctAnswer !== undefined
      ? selectedValue === correctAnswer
      : null;

  return (
    <div
      className={`bg-surface rounded-2xl p-5 border ${
        showCorrect
          ? isCorrect
            ? "border-success bg-success-light/30"
            : "border-error bg-error-light/30"
          : "border-border"
      }`}
    >
      {/* Soru başlığı */}
      <div className="flex items-start justify-between mb-4">
        <p className="text-xs text-text-secondary font-medium">
          Soru {questionNumber} / {totalQuestions}
        </p>
        <span className="text-xs font-medium bg-primary-light text-primary-dark px-2 py-0.5 rounded-full">
          {question.points} puan
        </span>
      </div>

      {/* Soru metni */}
      <p className="text-lg text-text-primary mb-5">{question.text}</p>

      {/* MCQ Seçenekleri */}
      {question.type === "mcq" && question.options && (
        <div className="space-y-2">
          {question.options.map((option, i) => {
            const letter = String.fromCharCode(65 + i); // A, B, C, D
            const isSelected = selectedValue === letter;
            let bg = isSelected
              ? "bg-primary text-on-primary border-primary scale-[1.02]"
              : "bg-surface text-text-primary border-border hover:border-primary/50";

            if (showCorrect && correctAnswer === letter) {
              bg = "bg-success text-on-primary border-success";
            }
            if (showCorrect && isSelected && correctAnswer !== letter && selectedValue !== undefined) {
              bg = "bg-error text-on-primary border-error";
            }

            return (
              <button
                key={letter}
                className={`w-full min-h-[56px] px-4 py-3 rounded-xl border-[1.5px] flex items-center gap-3 transition-all duration-200 text-left ${bg}`}
                onClick={() => onSelect(question.id, letter)}
                disabled={disabled}
              >
                <span
                  className={`w-8 h-8 rounded-full border-2 flex items-center justify-center text-sm font-bold shrink-0 ${
                    isSelected
                      ? "border-on-primary"
                      : "border-text-disabled"
                  }`}
                >
                  {letter}
                </span>
                <span className="text-base">{option}</span>
              </button>
            );
          })}
        </div>
      )}

      {/* Doğru/Yanlış */}
      {question.type === "true_false" && (
        <div className="grid grid-cols-2 gap-3">
          {[
            { value: true, label: "✓ Doğru", selectedBg: "bg-success text-on-primary border-success", normalBg: "bg-surface text-text-primary border-border" },
            { value: false, label: "✗ Yanlış", selectedBg: "bg-error text-on-primary border-error", normalBg: "bg-surface text-text-primary border-border" },
          ].map(({ value, label, selectedBg, normalBg }) => {
            const isSelected = selectedValue === value;
            const bg = isSelected ? selectedBg : normalBg;
            return (
              <button
                key={String(value)}
                className={`w-full h-[64px] rounded-xl border-[1.5px] flex items-center justify-center gap-2 transition-all duration-200 font-semibold text-lg ${bg} ${
                  disabled ? "" : "hover:border-primary/50"
                } ${isSelected ? "scale-[1.03]" : ""}`}
                onClick={() => onSelect(question.id, value)}
                disabled={disabled}
              >
                {label}
              </button>
            );
          })}
        </div>
      )}

      {/* Kısa Cevap */}
      {question.type === "short_answer" && (
        <textarea
          className="w-full min-h-[80px] px-4 py-3 border-[1.5px] border-border rounded-xl text-base resize-none outline-none transition-colors focus:border-primary focus:ring-1 focus:ring-primary placeholder:text-text-disabled"
          placeholder="Cevabınızı buraya yazın..."
          value={(selectedValue as string) || ""}
          onChange={(e) => onSelect(question.id, e.target.value)}
          disabled={disabled}
          rows={3}
        />
      )}
    </div>
  );
}
