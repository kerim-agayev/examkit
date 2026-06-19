"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { getDatabase, ref, get } from "firebase/database";

function rtdb() { return getDatabase(); }

export default function ResultsPage() {
  const [r, setR] = useState({ score: 0, total: 50, pct: 0, rank: 0 });
  const [board, setBoard] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const sid = typeof window !== "undefined" ? window.location.pathname.split("/").pop() || "" : "";
    (async () => {
      try {
        const sessSnap = await get(ref(rtdb(), `sessions/${sid}`));
        if (!sessSnap.exists()) { setLoading(false); return; }
        const sess = sessSnap.val();
        const examId = sess.examId || "";

        if (sess.scoreCalculatedAt) {
          setR({ score: sess.score ?? 0, total: sess.totalPoints ?? 50, pct: sess.percentage ?? 0, rank: sess.rank ?? 0 });
          if (examId) {
            const lbSnap = await get(ref(rtdb(), `leaderboards/${examId}`));
            if (lbSnap.exists()) {
              const lb = lbSnap.val();
              const list = Object.entries(lb).map(([_, val]: [string, any]) => ({
                rank: val.rank, name: val.studentName, score: val.score, me: val.studentName === (sess.studentName || ""),
              }));
              list.sort((a: any, b: any) => a.rank - b.rank);
              setBoard(list);
            }
          }
        }
      } catch {}
      setLoading(false);
    })();
  }, []);

  return (
    <main className="min-h-screen bg-background">
      <div className="sticky top-0 bg-surface border-b border-border px-4 py-3 flex justify-between items-center">
        <Link href="/" className="text-text-secondary"><svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></Link>
        <h1 className="text-lg font-semibold">Sonuçlar</h1><div className="w-12"/>
      </div>
      <div className="max-w-[640px] mx-auto p-4 space-y-4">
        {loading ? (
          <div className="text-center py-12"><div className="inline-block w-8 h-8 border-[3px] border-primary border-t-transparent rounded-full animate-spin"/></div>
        ) : r.score > 0 ? (
          <>
            <div className="bg-surface rounded-2xl p-7 border text-center space-y-3">
              <p className="text-sm text-text-secondary">Puanınız</p>
              <p className="text-4xl font-bold">{r.score} <span className="text-lg text-text-secondary font-normal">/ {r.total}</span></p>
              <p className="text-5xl font-bold text-success">{r.pct}%</p>
              {r.rank > 0 && <p className="text-base font-bold text-warning">🥇 Sınıfta {r.rank}. sıradasınız</p>}
            </div>
            {board.length > 0 && (
              <div>
                <h2 className="text-base font-semibold mb-2">Sınıf Sıralaması</h2>
                <div className="bg-surface rounded-2xl border divide-y divide-border">
                  {board.map(e => (
                    <div key={e.rank} className={`flex items-center gap-3 px-4 py-3 ${e.me ? "bg-primary-light/50" : ""}`}>
                      <span className="w-7 text-center font-bold text-sm">{e.rank === 1 ? "🥇" : e.rank === 2 ? "🥈" : "🥉"}</span>
                      <span className={`flex-1 text-sm ${e.me ? "font-bold text-primary-dark" : ""}`}>{e.name}</span>
                      <span className="text-sm font-semibold">{e.score} puan</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        ) : (
          <div className="text-center py-12 space-y-4">
            <p className="text-text-secondary">Öğretmen henüz puanlamadı veya sonuç bulunamadı</p>
          </div>
        )}
        <div className="text-center pt-4"><Link href="/" className="text-primary underline">← Ana sayfaya dön</Link></div>
      </div>
    </main>
  );
}
