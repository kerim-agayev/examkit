"use client";

import { useState, useCallback, type FormEvent } from "react";
import { ref, get } from "firebase/database";
import { getRtdb } from "@/lib/firebase";

function db() { return getRtdb()!; }

export default function HomePage() {
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = useCallback(async (e: FormEvent) => {
    e.preventDefault();
    if (code.length < 4) { setError("Geçersiz kod, tekrar deneyin"); return; }
    setLoading(true); setError("");

    try {
      // RTDB'de code ile exam ara
      const snap = await get(ref(db(), "exams"));
      if (snap.exists()) {
        const exams = snap.val();
        for (const key of Object.keys(exams)) {
          if (exams[key].code === code && exams[key].status !== "draft") {
            window.location.href = `/join/${code}`;
            return;
          }
        }
      }
      setError("Geçersiz kod, tekrar deneyin");
    } catch {
      setError("Bağlantı hatası, tekrar deneyin");
    }
    setLoading(false);
  }, [code]);

  const hc = (e: React.ChangeEvent<HTMLInputElement>) => {
    const v = e.target.value.toUpperCase().replace(/[^A-HJ-NP-Z2-9]/g, "");
    if (v.length <= 6) setCode(v); if (error) setError("");
  };
  const ok = code.length >= 4;

  return (
    <main className="min-h-screen flex items-center justify-center p-4 bg-background">
      <div className="w-full max-w-[480px] bg-surface rounded-[16px] p-8 border border-border">
        <div className="flex flex-col items-center mb-8">
          <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mb-4">
            <svg className="w-7 h-7 text-on-primary" viewBox="0 0 24 24" fill="currentColor"><rect x="5" y="4" width="14" height="3" rx="1.5"/><rect x="5" y="10.5" width="11" height="3" rx="1.5"/><rect x="5" y="17" width="14" height="3" rx="1.5"/></svg>
          </div>
          <h1 className="text-[28px] font-bold text-text-primary mb-2">Sınava Katıl</h1>
          <p className="text-base text-text-secondary">Öğretmenin paylaştığı kodu gir</p>
        </div>
        <form onSubmit={handleSubmit} className="space-y-4" noValidate>
          <input autoComplete="off" autoFocus className={`w-full h-[56px] px-4 text-[22px] font-semibold text-center uppercase tracking-[0.2em] bg-surface border-[1.5px] rounded-xl outline-none ${error ? "border-error" : "border-border focus:border-primary"}`} maxLength={6} placeholder="MAT7K2" value={code} onChange={hc} disabled={loading} />
          {error && <p className="text-error text-sm text-center">{error}</p>}
          <button className={`w-full h-[56px] rounded-xl flex items-center justify-center gap-2 text-lg font-semibold ${ok && !loading ? "bg-primary text-on-primary" : "bg-text-disabled text-on-primary cursor-not-allowed"}`} type="submit" disabled={!ok || loading}>
            {loading ? <span className="inline-block w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" /> : "Devam →"}
          </button>
        </form>
        <div className="mt-8 text-center"><p className="text-xs text-text-secondary">⚡ Uygulama indirmeye gerek yok</p></div>
      </div>
    </main>
  );
}
