"use client";

import { useState, useCallback, useEffect } from "react";
import { useParams, useSearchParams } from "next/navigation";
import { Suspense } from "react";
import { getDatabase, ref, get, update, serverTimestamp } from "firebase/database";

function rtdb() { return getDatabase(); }

function ExamContent() {
  const params = useParams<{ sessionId: string }>();
  const sp = useSearchParams();
  const sid = params.sessionId || "";
  const mode = sp.get("mode") || "scroll";

  const [questions, setQuestions] = useState<any[]>([]);
  const [examId, setExamId] = useState("");
  const [examTitle, setExamTitle] = useState("Sınav");
  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [done, setDone] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        // Session'dan examId'yi al
        const sessSnap = await get(ref(rtdb(), `sessions/${sid}`));
        if (!sessSnap.exists()) { setLoading(false); return; }
        const sess = sessSnap.val();
        const eid = sess.examId || "";
        setExamId(eid);
        setExamTitle(sess.examTitle || "Sınav");

        // Soruları RTDB'den al
        const qSnap = await get(ref(rtdb(), `questions/${eid}`));
        if (qSnap.exists()) {
          const qs = qSnap.val();
          const list = Object.entries(qs).map(([key, val]: [string, any]) => ({
            id: key, text: val.text, type: val.type, options: val.options || null,
          }));
          list.sort((a: any, b: any) => (a.orderIndex || 0) - (b.orderIndex || 0));
          setQuestions(list.length > 0 ? list : defaultQuestions);
        } else {
          setQuestions(defaultQuestions);
        }
      } catch { setQuestions(defaultQuestions); }
      setLoading(false);
    })();
  }, [sid]);

  const q = questions[idx];
  const hasAnswer = answers[q?.id] !== undefined;
  const isLast = idx >= questions.length - 1;

  const select = useCallback(async (qId: string, v: any) => {
    setAnswers(a => ({ ...a, [qId]: v }));
    try {
      await update(ref(rtdb(), `sessions/${sid}/answers`), {
        [qId]: { value: v, timestamp: serverTimestamp() },
      });
    } catch {}
  }, [sid]);

  const finish = useCallback(async () => {
    setDone(true);
    try {
      await update(ref(rtdb(), `sessions/${sid}`), {
        status: "completed",
        completedAt: serverTimestamp(),
      });
    } catch {}
    setTimeout(() => { window.location.href = `/results/${sid}`; }, 1500);
  }, [sid]);

  const advance = () => { if (isLast) finish(); else setIdx(i => i + 1); };

  if (loading) return <div className="min-h-screen flex items-center justify-center bg-background"><div className="text-center space-y-3"><div className="inline-block w-8 h-8 border-[3px] border-primary border-t-transparent rounded-full animate-spin"/><p className="text-text-secondary text-sm">Sınav yükleniyor...</p></div></div>;

  if (done) return <main className="min-h-screen flex items-center justify-center bg-background"><div className="text-center space-y-4"><svg className="w-20 h-20 text-success mx-auto" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg><h1 className="text-2xl font-bold">Sınav Tamamlandı! 🎉</h1></div></main>;

  return (
    <main className="min-h-screen flex flex-col bg-background">
      <div className="sticky top-0 bg-surface border-b border-border px-4 py-3 flex justify-between items-center">
        <span className="font-semibold text-sm">{examTitle}</span>
        {mode === "sequential" && <span className="text-sm text-text-secondary">{idx + 1} / {questions.length}</span>}
      </div>
      <div className="flex-1 overflow-y-auto p-4">
        <div className="max-w-[640px] mx-auto space-y-3">
          {(mode === "scroll" ? questions : [q]).filter(Boolean).map((q, i) => (
            <div key={q.id} className="bg-surface rounded-2xl p-5 border border-border">
              <div className="flex justify-between mb-3"><span className="text-xs text-text-secondary">Soru {mode === "scroll" ? i + 1 : idx + 1} / {questions.length}</span></div>
              <p className="text-lg mb-4">{q.text}</p>
              {q.type === "mcq" && q.options?.map((o: string, oi: number) => {
                const l = String.fromCharCode(65 + oi);
                const sel = answers[q.id] === l;
                return <button key={l} className={`w-full min-h-[48px] px-4 py-3 rounded-xl border-[1.5px] mb-2 text-left flex items-center gap-3 ${sel ? "bg-primary text-on-primary border-primary" : "bg-surface border-border"}`} onClick={() => select(q.id, l)}>
                  <span className={`w-7 h-7 rounded-full border-2 flex items-center justify-center text-xs font-bold ${sel ? "border-on-primary" : "border-text-disabled"}`}>{l}</span>{o}
                </button>;
              })}
              {q.type === "true_false" && <div className="grid grid-cols-2 gap-3">
                {(["✓ Doğru", "✗ Yanlış"] as const).map((l, vi) => { const v = vi === 0; const sel = answers[q.id] === v; return <button key={l} className={`h-[56px] rounded-xl border-[1.5px] font-semibold ${sel ? (v ? "bg-success text-on-primary" : "bg-error text-on-primary") : "bg-surface border-border"}`} onClick={() => select(q.id, v)}>{l}</button>; })}
              </div>}
              {q.type === "short_answer" && <textarea className="w-full min-h-[80px] px-4 py-3 border-[1.5px] border-border rounded-xl text-base" placeholder="Cevabınızı yazın..." value={answers[q.id] || ""} onChange={e => select(q.id, e.target.value)}/>}
            </div>
          ))}
        </div>
      </div>
      {mode === "sequential" && <div className="sticky bottom-0 bg-surface border-t border-border p-4"><button className={`w-full h-[56px] rounded-xl font-semibold text-lg ${hasAnswer ? "bg-primary text-on-primary" : "bg-text-disabled text-on-primary cursor-not-allowed"}`} disabled={!hasAnswer} onClick={advance}>{isLast ? "✓ Sınavı Tamamla" : "İlerle →"}</button></div>}
      {mode === "scroll" && <div className="sticky bottom-0 bg-surface border-t border-border p-4"><button className="w-full h-[56px] rounded-xl bg-success text-on-primary font-semibold text-lg" onClick={finish}>Sınavı Gönder</button></div>}
    </main>
  );
}

const defaultQuestions = [
  { id: "q1", text: "Mitoz bölünmenin temel amacı nedir?", type: "mcq", options: ["Enerji üretimi", "Büyüme ve onarım", "Sindirim", "Boşaltım"] },
];

export default function ExamPage() {
  return <Suspense fallback={<div className="min-h-screen flex items-center justify-center bg-background"><div className="inline-block w-8 h-8 border-[3px] border-primary border-t-transparent rounded-full animate-spin"/></div>}><ExamContent/></Suspense>;
}
