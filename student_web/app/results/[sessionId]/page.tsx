"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { ref, get, onValue } from "firebase/database";
import { getRtdb } from "@/lib/firebase";

function db() { return getRtdb()!; }

export default function ResultsPage() {
  const [r, setR] = useState({ score: 0, total: 50, pct: 0, rank: 0 });
  const [board, setBoard] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [puanlamadi, setPuanlamadi] = useState(true);
  const [showSettings, setShowSettings] = useState({ showScore: true, showCorrect: true, showLeaderboard: true });
  const [questionResults, setQuestionResults] = useState<any[]>([]);

  useEffect(() => {
    const sid = typeof window !== "undefined" ? window.location.pathname.split("/").pop() || "" : "";

    // Realtime listener: puanlama bitince otomatik güncelle
    const unsub = onValue(ref(db(), `sessions/${sid}`), (snap) => {
      if (!snap.exists()) return;
      const sess = snap.val();
      if (!sess.scoreCalculatedAt) return;

      const examId = sess.examId || "";
      // Exam settings oku (showScore/showCorrect/showLeaderboard)
      if (examId) {
        get(ref(db(), `exams/${examId}/settings`)).then(snap => {
          if (snap.exists()) setShowSettings({showScore: snap.val().showScore !== false, showCorrect: snap.val().showCorrectAnswers !== false, showLeaderboard: snap.val().showLeaderboard !== false});
        });
      }
      setR({ score: sess.score ?? 0, total: sess.totalPoints ?? 50, pct: sess.percentage ?? 0, rank: sess.rank ?? 0 });
      setPuanlamadi(false);

      // Leaderboard'u da al
      if (examId) {
        get(ref(db(), `leaderboards/${examId}`)).then((lbSnap) => {
          if (!lbSnap.exists()) return;
          const lb = lbSnap.val();
          const list = Object.entries(lb).map(([_, val]: [string, any]) => ({
            rank: val.rank, name: val.studentName, score: val.score, me: val.studentName === (sess.studentName || ""),
          }));
          list.sort((a: any, b: any) => a.rank - b.rank);
          setBoard(list);
        });

        // Soru bazında doğru/yanlış karşılaştırması
        Promise.all([
          get(ref(db(), `questions/${examId}`)),
          get(ref(db(), `exam_answers/${examId}`)),
        ]).then(([qSnap, aSnap]) => {
          const questions = qSnap.exists() ? qSnap.val() : {};
          const correctAnswers = aSnap.exists() ? aSnap.val() : {};
          const studentAnswers = sess.answers || {};
          const results: any[] = [];
          Object.keys(questions).forEach((qid) => {
            const q = questions[qid] || {};
            const correct = correctAnswers[qid] || {};
            const student = studentAnswers[qid] || {};
            const studentVal = student?.value;
            let isCorrect = false;
            if (q.type === "mcq") {
              isCorrect = studentVal === correct.correctOptionId;
            } else if (q.type === "true_false") {
              isCorrect = studentVal === correct.correctAnswer;
            } else {
              // short_answer: case-insensitive trim karşılaştırma
              isCorrect = String(studentVal || "").trim().toLowerCase() === String(correct.correctAnswer || "").trim().toLowerCase();
            }
            results.push({ id: qid, text: q.text, type: q.type, options: q.options, studentAnswer: studentVal, correctAnswer: q.type === "mcq" ? correct.correctOptionId : correct.correctAnswer, isCorrect, points: q.points || 0 });
          });
          setQuestionResults(results);
        });
      }
    });

    // İlk yükleme kontrolü
    get(ref(db(), `sessions/${sid}`)).then((sessSnap) => {
      if (sessSnap.exists()) {
        const sess = sessSnap.val();
        if (sess.scoreCalculatedAt) {
          setR({ score: sess.score ?? 0, total: sess.totalPoints ?? 50, pct: sess.percentage ?? 0, rank: sess.rank ?? 0 });
          setPuanlamadi(false);
        }
      }
      setLoading(false);
    });

    return () => unsub();
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
        ) : !puanlamadi ? (
          <>
            <div className="bg-surface rounded-2xl p-7 border text-center space-y-3">
              <p className="text-sm text-text-secondary">Puanınız</p>
              <p className="text-4xl font-bold">{r.score} <span className="text-lg text-text-secondary font-normal">/ {r.total}</span></p>
              <p className="text-5xl font-bold text-success">{r.pct}%</p>
              {r.rank > 0 && <p className="text-base font-bold text-warning">🥇 Sınıfta {r.rank}. sıradasınız</p>}
            </div>
            {showSettings.showLeaderboard && board.length > 0 && (
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
            {showSettings.showCorrect && questionResults.length > 0 && (
              <div>
                <h2 className="text-base font-semibold mb-2">Soru Detayları</h2>
                <div className="space-y-3">
                  {questionResults.map((qr, i) => (
                    <div key={qr.id} className={`bg-surface rounded-xl p-4 border ${qr.isCorrect ? "border-success/30" : "border-error/30"}`}>
                      <div className="flex items-start gap-2 mb-2">
                        <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold shrink-0 mt-0.5 ${qr.isCorrect ? "bg-success text-on-primary" : "bg-error text-on-primary"}`}>
                          {qr.isCorrect ? "✓" : "✗"}
                        </span>
                        <div>
                          <p className="text-sm font-medium">{i + 1}. {qr.text}</p>
                          {qr.type === "mcq" && qr.options && (
                            <div className="mt-1 space-y-0.5">
                              {qr.options.map((o: string, oi: number) => (
                                <span key={oi} className={`block text-xs pl-1 ${o === qr.correctAnswer ? "text-success font-semibold" : o === qr.studentAnswer && !qr.isCorrect ? "text-error line-through" : "text-text-secondary"}`}>
                                  {String.fromCharCode(65 + oi)}) {o}
                                  {o === qr.correctAnswer && " ← Doğru cevap"}
                                  {o === qr.studentAnswer && !qr.isCorrect && " ← Senin cevabın"}
                                </span>
                              ))}
                            </div>
                          )}
                          {qr.type === "true_false" && (
                            <p className="text-xs mt-1">
                              <span className="text-text-secondary">Cevabın: </span>
                              <span className={qr.isCorrect ? "text-success font-semibold" : "text-error"}>{qr.studentAnswer ? "Doğru" : "Yanlış"}</span>
                              {!qr.isCorrect && <span className="text-text-secondary"> | Doğru: <span className="text-success">{qr.correctAnswer ? "Doğru" : "Yanlış"}</span></span>}
                            </p>
                          )}
                          {qr.type === "short_answer" && (
                            <p className="text-xs mt-1">
                              <span className="text-text-secondary">Cevabın: </span>
                              <span className={qr.isCorrect ? "text-success font-semibold" : "text-error"}>{qr.studentAnswer || "(boş)"}</span>
                              {!qr.isCorrect && <span className="text-text-secondary"> | Doğru: <span className="text-success">{qr.correctAnswer}</span></span>}
                            </p>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        ) : (
          <div className="text-center py-12 space-y-4">
            <div className="inline-block w-8 h-8 border-[3px] border-primary border-t-transparent rounded-full animate-spin"/>
            <p className="text-text-secondary">Öğretmen puanlama yapıyor, bekleyin...</p>
          </div>
        )}
        <div className="text-center pt-4"><Link href="/" className="text-primary underline">← Ana sayfaya dön</Link></div>
      </div>
    </main>
  );
}
