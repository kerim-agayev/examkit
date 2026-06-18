"use client";

/**
 * W2 — Ad Soyad Girişi (/join/[code])
 * Öğrenci ad-soyad girer, session oluşturulup bekleme odasına yönlendirilir.
 * Stitch referans: design/stitch_screens/i_sim_giri_i/code.html
 */

import { useState, useCallback, useEffect, type FormEvent } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { getExamByCode, type Exam } from "@/lib/firestore";

export default function JoinPage() {
  const params = useParams<{ code: string }>();
  const code = params.code?.toUpperCase() || "";

  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [loading, setLoading] = useState(false);
  const [examInfo, setExamInfo] = useState<Exam | null>(null);
  const [lookupFailed, setLookupFailed] = useState(false);

  // Firebase exam lookup on mount — graceful fallback
  useEffect(() => {
    async function lookup() {
      try {
        const exam = await getExamByCode(code);
        if (exam) setExamInfo(exam);
        else setLookupFailed(true);
      } catch {
        setLookupFailed(true); // Firestore yok → fallback UI
      }
    }
    lookup();
  }, [code]);

  const canSubmit = firstName.trim().length >= 2 && lastName.trim().length >= 2;

  const handleSubmit = useCallback(
    async (e: FormEvent) => {
      e.preventDefault();
      if (!canSubmit) return;
      setLoading(true);

      const sessionId = examInfo
        ? `fb_${examInfo.id}_${Date.now()}`
        : "mock_" + Date.now();
      localStorage.setItem("examkit_session", sessionId);
      localStorage.setItem("examkit_name", `${firstName} ${lastName}`);

      setTimeout(() => {
        setLoading(false);
        window.location.href = `/waiting/${sessionId}`;
      }, 800);
    },
    [canSubmit, firstName, lastName, examInfo]
  );

  return (
    <main className="min-h-screen flex flex-col bg-background">
      {/* Top nav */}
      <div className="p-4">
        <Link
          href="/"
          className="inline-flex items-center gap-1 text-text-secondary hover:text-text-primary transition-colors"
        >
          <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z" />
          </svg>
          <span className="font-medium text-base">Geri</span>
        </Link>
      </div>

      <div className="flex-1 flex items-center justify-center p-4">
        <div className="w-full max-w-[480px] space-y-6 animate-fade-in-up">
          {/* Exam info banner */}
          <div className="bg-primary-light rounded-xl p-4">
            <p className="text-base font-semibold text-primary-dark">
              📚 {examInfo ? examInfo.title : "Biologiya Final İmtahanı"}
            </p>
            <p className="text-sm text-text-secondary mt-1">
              {examInfo
                ? `${examInfo.teacherName} · ${examInfo.mode === "sequential" ? "Sıralı" : "Kaydırma"} · ${examInfo.questionCount} soru`
                : "Kamran müəllim · 9-A sinifi"}
            </p>
          </div>

          {/* Form card */}
          <div className="bg-surface rounded-[16px] p-6 border border-border">
            <h1 className="text-2xl font-bold text-text-primary mb-6">
              Adınızı girin
            </h1>

            <form onSubmit={handleSubmit} className="space-y-4">
              <input
                className="w-full h-[56px] px-4 text-base bg-surface border-[1.5px] border-border rounded-xl outline-none transition-colors focus:border-primary focus:ring-1 focus:ring-primary placeholder:text-text-disabled"
                placeholder="Adınız..."
                value={firstName}
                onChange={(e) => setFirstName(e.target.value)}
                disabled={loading}
                autoFocus
              />
              <input
                className="w-full h-[56px] px-4 text-base bg-surface border-[1.5px] border-border rounded-xl outline-none transition-colors focus:border-primary focus:ring-1 focus:ring-primary placeholder:text-text-disabled"
                placeholder="Soyadınız..."
                value={lastName}
                onChange={(e) => setLastName(e.target.value)}
                disabled={loading}
              />

              <button
                className={`w-full h-[56px] rounded-xl transition-all duration-200 flex items-center justify-center text-lg font-semibold ${
                  canSubmit && !loading
                    ? "bg-primary hover:bg-primary-dark text-on-primary shadow-sm hover:shadow-md"
                    : "bg-text-disabled text-on-primary cursor-not-allowed"
                }`}
                type="submit"
                disabled={!canSubmit || loading}
              >
                {loading ? (
                  <span className="inline-block w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                ) : (
                  "Sınava Katıl"
                )}
              </button>
            </form>

            <p className="text-xs text-text-secondary text-center mt-4">
              📋 Adınız öğretmeninizde görünecek
            </p>
          </div>

          {/* Code display */}
          <p className="text-center text-sm text-text-secondary">
            Sınav Kodu:{" "}
            <span className="font-mono font-bold text-primary tracking-widest">
              {code}
            </span>
          </p>
        </div>
      </div>
    </main>
  );
}
