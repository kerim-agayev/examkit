"use client";

import { useState, useCallback, useEffect, type FormEvent } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { getDatabase, ref, get, push, set, update, serverTimestamp, query, orderByChild, equalTo } from "firebase/database";

function rtdb() { return getDatabase(); }

export default function JoinPage() {
  const params = useParams<{ code: string }>();
  const code = params.code?.toUpperCase() || "";
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [loading, setLoading] = useState(false);
  const [exam, setExam] = useState<any>(null);
  const [examError, setExamError] = useState("");
  const canSubmit = firstName.trim().length >= 2 && lastName.trim().length >= 2;

  // RTDB'den exam code ile lookup
  useEffect(() => {
    if (!code) return;
    (async () => {
      try {
        const examsRef = ref(rtdb(), "exams");
        const snap = await get(examsRef);
        if (snap.exists()) {
          const exams = snap.val();
          for (const key of Object.keys(exams)) {
            if (exams[key].code === code && exams[key].status !== "draft") {
              setExam({ id: key, ...exams[key] });
              return;
            }
          }
        }
        setExamError("Sınav bulunamadı veya henüz yayınlanmadı");
      } catch (e) {
        setExamError("Bağlantı hatası: " + String(e));
      }
    })();
  }, [code]);

  const handleSubmit = useCallback(async (e: FormEvent) => {
    e.preventDefault(); if (!canSubmit || !exam) return;
    setLoading(true);
    const name = `${firstName} ${lastName}`;

    try {
      // RTDB'de session oluştur
      const sessionRef = push(ref(rtdb(), "sessions"));
      const sid = sessionRef.key!;
      const now = serverTimestamp();
      await set(sessionRef, {
        examId: exam.id,
        studentName: name,
        status: "active",
        answers: {},
        questionOrder: [],
        optionOrders: {},
        startedAt: now,
      });
      // Index: sessions_by_exam
      await update(ref(rtdb(), "/"), {
        [`sessions_by_exam/${exam.id}/${sid}`]: now,
      });
      // Bekleme odasına katıl
      await set(ref(rtdb(), `live_exams/${exam.id}/students/${sid}`), {
        name,
        joinedAt: now,
        progress: 0,
        status: "waiting",
      });

      localStorage.setItem("examkit_session", sid);
      localStorage.setItem("examkit_name", name);
      localStorage.setItem("examkit_examId", exam.id);
      window.location.href = `/waiting/${sid}`;
    } catch (e) {
      setExamError("Katılım hatası: " + String(e));
    } finally {
      setLoading(false);
    }
  }, [canSubmit, firstName, lastName, exam]);

  if (examError) return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
      <div className="text-center space-y-4">
        <p className="text-error text-lg">{examError}</p>
        <Link href="/" className="text-primary underline">← Ana sayfaya dön</Link>
      </div>
    </main>
  );

  return (
    <main className="min-h-screen flex flex-col bg-background">
      <nav className="p-4"><Link href="/" className="inline-flex items-center gap-1 text-text-secondary hover:text-text-primary"><svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg><span className="font-medium text-base">Geri</span></Link></nav>
      <div className="flex-1 flex items-center justify-center p-4">
        <div className="w-full max-w-[480px] space-y-6">
          {exam && (
            <div className="bg-primary-light rounded-xl p-4">
              <p className="text-base font-semibold text-primary-dark">📚 {exam.title}</p>
              <p className="text-sm text-text-secondary mt-1">{exam.groupName || "—"}</p>
            </div>
          )}
          <div className="bg-surface rounded-[16px] p-6 border border-border">
            <h1 className="text-2xl font-bold text-text-primary mb-6">Adınızı girin</h1>
            <form onSubmit={handleSubmit} className="space-y-4" noValidate>
              <input className="w-full h-[56px] px-4 text-base bg-surface border-[1.5px] border-border rounded-xl outline-none focus:border-primary" placeholder="Adınız..." value={firstName} onChange={e => setFirstName(e.target.value)} disabled={loading} autoFocus />
              <input className="w-full h-[56px] px-4 text-base bg-surface border-[1.5px] border-border rounded-xl outline-none focus:border-primary" placeholder="Soyadınız..." value={lastName} onChange={e => setLastName(e.target.value)} disabled={loading} />
              <button className={`w-full h-[56px] rounded-xl flex items-center justify-center text-lg font-semibold ${canSubmit && !loading ? "bg-primary hover:bg-primary-dark text-on-primary" : "bg-text-disabled text-on-primary cursor-not-allowed"}`} type="submit" disabled={!canSubmit || loading}>
                {loading ? <span className="inline-block w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" /> : "Sınava Katıl"}
              </button>
            </form>
            <p className="text-xs text-text-secondary text-center mt-4">📋 Adınız öğretmeninizde görünecek</p>
          </div>
          <p className="text-center text-sm text-text-secondary">Sınav Kodu: <span className="font-mono font-bold text-primary tracking-widest">{code}</span></p>
        </div>
      </div>
    </main>
  );
}
