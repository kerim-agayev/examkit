"use client";

import Link from "next/link";

export default function ResultsPage() {
  const r = { score: 48, total: 50, pct: 96, rank: 1, correct: 46, wrong: 3, empty: 1, durMin: 18, durSec: 32 };
  const board = [{ rank: 1, name: "Aynur Məmmədova", score: 48, me: true },{ rank: 2, name: "Kamran Hüseynov", score: 44, me: false },{ rank: 3, name: "Leyla Əsgərova", score: 41, me: false }];

  return (
    <main className="min-h-screen bg-background">
      <div className="sticky top-0 bg-surface border-b border-border px-4 py-3 flex justify-between items-center">
        <Link href="/" className="text-text-secondary"><svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></Link>
        <h1 className="text-lg font-semibold">Sonuçlar</h1><div className="w-12"/>
      </div>
      <div className="max-w-[640px] mx-auto p-4 space-y-4">
        <div className="bg-surface rounded-2xl p-7 border text-center space-y-3">
          <p className="text-sm text-text-secondary">Puanınız</p>
          <p className="text-4xl font-bold">{r.score} <span className="text-lg text-text-secondary font-normal">/ {r.total}</span></p>
          <div className="flex justify-center"><div className="w-[88px] h-[88px] relative"><svg className="w-full h-full -rotate-90" viewBox="0 0 88 88"><circle cx="44" cy="44" r="38" fill="none" stroke="#E2E8F0" strokeWidth="6"/><circle cx="44" cy="44" r="38" fill="none" stroke="#059669" strokeWidth="6" strokeDasharray={`${(r.pct/100)*239} 239`}/></svg><span className="absolute inset-0 flex items-center justify-center text-2xl font-bold text-success">{r.pct}%</span></div></div>
          <p className="text-base font-bold text-warning">🥇 Sınıfta {r.rank}. sıradasınız</p>
          <p className="text-sm text-text-secondary">{r.durMin} dk {r.durSec} sn</p>
        </div>
        <div className="bg-surface rounded-2xl border grid grid-cols-3 divide-x divide-border">
          <div className="py-4 text-center"><p className="text-lg font-bold text-success">{r.correct} ✓</p><p className="text-xs text-text-secondary">Doğru</p></div>
          <div className="py-4 text-center"><p className="text-lg font-bold text-error">{r.wrong} ✗</p><p className="text-xs text-text-secondary">Yanlış</p></div>
          <div className="py-4 text-center"><p className="text-lg font-bold text-text-disabled">{r.empty} –</p><p className="text-xs text-text-secondary">Boş</p></div>
        </div>
        <div><h2 className="text-base font-semibold mb-2">Sınıf Sıralaması</h2>
          <div className="bg-surface rounded-2xl border divide-y divide-border">
            {board.map(e => <div key={e.rank} className={`flex items-center gap-3 px-4 py-3 ${e.me ? "bg-primary-light/50" : ""}`}>
              <span className="w-7 text-center font-bold text-sm">{e.rank === 1 ? "🥇" : e.rank === 2 ? "🥈" : "🥉"}</span>
              <span className={`flex-1 text-sm ${e.me ? "font-bold text-primary-dark" : ""}`}>{e.name}</span>
              <span className="text-sm font-semibold">{e.score} puan</span>
            </div>)}
          </div>
        </div>
      </div>
    </main>
  );
}
