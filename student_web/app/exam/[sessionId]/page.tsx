"use client";

import { useState, useCallback } from "react";
import { useParams, useSearchParams } from "next/navigation";
import { Suspense } from "react";

const questions = [
  { id: "q1", text: "Mitoz bölünmenin temel amacı nedir?", type: "mcq", options: ["Enerji üretimi", "Büyüme ve onarım", "Sindirim", "Boşaltım"] },
  { id: "q2", text: "DNA replikasyonu S fazasında gerçekleşir.", type: "tf" },
  { id: "q3", text: "Fotosentezin temel ürünü nedir?", type: "sa" },
  { id: "q4", text: "Hücre zarının yapısını açıklayan model hangisidir?", type: "mcq", options: ["Kilit-Anahtar", "Akıcı Mozaik Zar", "Çift Sarmal", "Endosimbiyoz"] },
  { id: "q5", text: "Ribozomlar protein sentezinden sorumludur.", type: "tf" },
];

function ExamContent() {
  const params = useParams<{ sessionId: string }>();
  const sp = useSearchParams();
  const mode = sp.get("mode") === "scroll" ? "scroll" : "sequential";

  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [done, setDone] = useState(false);

  const q = questions[idx];
  const hasAnswer = answers[q?.id] !== undefined;
  const isLast = idx >= questions.length - 1;

  const select = (qId: string, v: any) => setAnswers(a => ({ ...a, [qId]: v }));
  const advance = () => { if (isLast) { setDone(true); setTimeout(() => window.location.href = `/results/${params.sessionId}`, 1500); } else setIdx(i => i + 1); };

  if (done) return <main className="min-h-screen flex items-center justify-center bg-background"><div className="text-center space-y-4"><svg className="w-20 h-20 text-success mx-auto" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg><h1 className="text-2xl font-bold">Sınav Tamamlandı! 🎉</h1></div></main>;

  return (
    <main className="min-h-screen flex flex-col bg-background">
      <div className="sticky top-0 bg-surface border-b border-border px-4 py-3 flex justify-between items-center">
        <span className="font-semibold">Biologiya Final <span className="text-[10px] bg-info-light text-info px-1.5 py-0.5 rounded-full">{mode === "scroll" ? "Kaydırma" : "Sıralı"}</span></span>
        {mode === "sequential" && <span className="text-sm text-text-secondary">{idx + 1} / {questions.length}</span>}
        <span className="text-sm font-mono">20:00</span>
      </div>
      <div className="flex-1 overflow-y-auto p-4">
        <div className="max-w-[640px] mx-auto space-y-3">
          {(mode === "scroll" ? questions : [q]).filter(Boolean).map((q, i) => (
            <div key={q.id} className="bg-surface rounded-2xl p-5 border border-border">
              <div className="flex justify-between mb-3"><span className="text-xs text-text-secondary">Soru {mode === "scroll" ? i + 1 : idx + 1} / {questions.length}</span></div>
              <p className="text-lg mb-4">{q.text}</p>
              {q.type === "mcq" && q.options?.map((o, oi) => {
                const letter = String.fromCharCode(65 + oi);
                const sel = answers[q.id] === letter;
                return <button key={letter} className={`w-full min-h-[48px] px-4 py-3 rounded-xl border-[1.5px] mb-2 text-left flex items-center gap-3 ${sel ? "bg-primary text-on-primary border-primary" : "bg-surface border-border"}`} onClick={() => select(q.id, letter)}>
                  <span className={`w-7 h-7 rounded-full border-2 flex items-center justify-center text-xs font-bold ${sel ? "border-on-primary" : "border-text-disabled"}`}>{letter}</span>{o}
                </button>;
              })}
              {q.type === "tf" && <div className="grid grid-cols-2 gap-3">
                {(["✓ Doğru", "✗ Yanlış"] as const).map((l, vi) => { const v = vi === 0; const sel = answers[q.id] === v; return <button key={l} className={`h-[56px] rounded-xl border-[1.5px] font-semibold ${sel ? (v ? "bg-success text-on-primary" : "bg-error text-on-primary") : "bg-surface border-border"}`} onClick={() => select(q.id, v)}>{l}</button>; })}
              </div>}
              {q.type === "sa" && <textarea className="w-full min-h-[80px] px-4 py-3 border-[1.5px] border-border rounded-xl text-base" placeholder="Cevabınızı yazın..." value={answers[q.id] || ""} onChange={e => select(q.id, e.target.value)}/>}
            </div>
          ))}
        </div>
      </div>
      {mode === "sequential" && <div className="sticky bottom-0 bg-surface border-t border-border p-4"><button className={`w-full h-[56px] rounded-xl font-semibold text-lg ${hasAnswer ? "bg-primary text-on-primary" : "bg-text-disabled text-on-primary cursor-not-allowed"}`} disabled={!hasAnswer} onClick={advance}>{isLast ? "✓ Sınavı Tamamla" : "İlerle →"}</button></div>}
      {mode === "scroll" && <div className="sticky bottom-0 bg-surface border-t border-border p-4"><button className="w-full h-[56px] rounded-xl bg-success text-on-primary font-semibold text-lg" onClick={advance}>Sınavı Gönder</button></div>}
    </main>
  );
}

export default function ExamPage() {
  return <Suspense fallback={<div className="min-h-screen flex items-center justify-center">Yükleniyor...</div>}><ExamContent/></Suspense>;
}
