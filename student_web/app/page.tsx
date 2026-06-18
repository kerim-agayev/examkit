"use client";

import { useState, useCallback, type FormEvent } from "react";

export default function HomePage() {
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleCodeChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value.toUpperCase().replace(/[^A-HJ-NP-Z2-9]/g, "");
    if (val.length <= 6) setCode(val);
    if (error) setError("");
  }, [error]);

  const handleSubmit = useCallback(async (e: FormEvent) => {
    e.preventDefault();
    if (code.length < 4) { setError("Geçersiz kod, tekrar deneyin"); return; }
    setLoading(true); setError("");
    setTimeout(() => { setLoading(false); window.location.href = `/join/${code}`; }, 400);
  }, [code]);

  const isValid = code.length >= 4;

  return (
    <main className="min-h-screen flex items-center justify-center p-4 bg-background">
      <div className="w-full max-w-[480px] bg-surface rounded-[16px] p-8 border border-border">
        <div className="flex flex-col items-center mb-8">
          <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mb-4">
            <svg className="w-7 h-7 text-on-primary" viewBox="0 0 24 24" fill="currentColor"><rect x="5" y="4" width="14" height="3" rx="1.5"/><rect x="5" y="10.5" width="11" height="3" rx="1.5"/><rect x="5" y="17" width="14" height="3" rx="1.5"/></svg>
          </div>
          <h1 className="text-[28px] leading-[36px] font-bold text-center text-text-primary mb-2">Sınava Katıl</h1>
          <p className="text-base text-text-secondary text-center">Öğretmenin paylaştığı kodu gir</p>
        </div>
        <form onSubmit={handleSubmit} className="space-y-4" noValidate>
          <input
            autoComplete="off" autoFocus
            className={`w-full h-[56px] px-4 text-[22px] font-semibold text-center uppercase tracking-[0.2em] bg-surface border-[1.5px] rounded-xl outline-none transition-colors ${error ? "border-error" : "border-border focus:border-primary"}`}
            maxLength={6} placeholder="MAT7K2" type="text" value={code} onChange={handleCodeChange} disabled={loading}
          />
          {error && <p className="text-error text-sm text-center font-medium">{error}</p>}
          <button
            className={`w-full h-[56px] rounded-xl transition-all flex items-center justify-center gap-2 text-lg font-semibold ${isValid && !loading ? "bg-primary hover:bg-primary-dark text-on-primary" : "bg-text-disabled text-on-primary cursor-not-allowed"}`}
            type="submit" disabled={!isValid || loading}
          >
            {loading ? <span className="inline-block w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" /> : "Devam →"}
          </button>
        </form>
        <div className="mt-8 text-center"><p className="text-xs text-text-secondary">⚡ Uygulama indirmeye gerek yok</p></div>
      </div>
    </main>
  );
}
