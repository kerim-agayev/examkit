"use client";

/**
 * W1 — Kod Giriş Sayfası (/)
 * Öğrenci sınav kodunu girip doğrular.
 * Stitch referans: design/stitch_screens/renci_giri/code.html
 */

import { useState, useCallback, type FormEvent } from "react";
import { ExamKitLogo } from "@/components/ExamKitLogo";

export default function HomePage() {
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleCodeChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const val = e.target.value.toUpperCase().replace(/[^A-HJ-NP-Z2-9]/g, "");
      if (val.length <= 6) setCode(val);
      if (error) setError("");
    },
    [error]
  );

  const handleSubmit = useCallback(
    async (e: FormEvent) => {
      e.preventDefault();
      if (code.length < 4) {
        setError("Geçersiz kod, tekrar deneyin");
        return;
      }
      setLoading(true);
      setError("");

      // TODO: Firestore getExamByCode(code) → validate & redirect
      // Şimdilik mock: 1 sn sonra join sayfasına yönlendir
      setTimeout(() => {
        setLoading(false);
        window.location.href = `/join/${code}`;
      }, 800);
    },
    [code]
  );

  const isValid = code.length >= 4;

  return (
    <main className="min-h-screen flex items-center justify-center p-4 bg-background">
      <div className="w-full max-w-[480px] bg-surface rounded-[16px] p-8 border border-border animate-fade-in-up">
        {/* Header / Logo */}
        <div className="flex flex-col items-center mb-8">
          <div className="flex items-center gap-2 mb-6">
            <ExamKitLogo size={32} />
          </div>
          <h1 className="text-[28px] leading-[36px] font-bold text-center text-text-primary mb-2">
            Sınava Katıl
          </h1>
          <p className="text-base text-text-secondary text-center">
            Öğretmenin paylaştığı kodu gir
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="relative">
            <input
              autoComplete="off"
              className={`w-full h-[56px] px-4 text-[22px] leading-[28px] font-semibold text-center uppercase tracking-[0.2em] bg-surface border-[1.5px] rounded-xl outline-none transition-colors placeholder:text-text-disabled placeholder:font-normal ${
                error
                  ? "border-error animate-shake"
                  : "border-border focus:border-primary focus:ring-1 focus:ring-primary"
              }`}
              id="exam-code"
              maxLength={6}
              placeholder="MAT7K2"
              type="text"
              value={code}
              onChange={handleCodeChange}
              disabled={loading}
            />
          </div>

          {error && (
            <p className="text-error text-sm text-center font-medium">
              {error}
            </p>
          )}

          <button
            className={`w-full h-[56px] rounded-xl transition-all duration-200 flex items-center justify-center gap-2 shadow-sm text-lg font-semibold ${
              isValid && !loading
                ? "bg-primary hover:bg-primary-dark active:bg-primary-dark text-on-primary hover:shadow-md"
                : "bg-text-disabled text-on-primary cursor-not-allowed"
            }`}
            type="submit"
            disabled={!isValid || loading}
          >
            {loading ? (
              <span className="inline-block w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <>
                Devam
                <svg
                  className="w-5 h-5"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z" />
                </svg>
              </>
            )}
          </button>
        </form>

        {/* Footer */}
        <div className="mt-8 text-center">
          <p className="text-xs text-text-secondary flex items-center justify-center gap-1.5">
            ⚡ Uygulama indirmeye gerek yok
          </p>
        </div>
      </div>
    </main>
  );
}
