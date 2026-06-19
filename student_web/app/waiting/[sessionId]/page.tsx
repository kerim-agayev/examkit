"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { ref, get } from "firebase/database";
import { getRtdb } from "@/lib/firebase";

function db() { return getRtdb()!; }

export default function WaitingPage() {
  const params = useParams<{ sessionId: string }>();
  const sid = params.sessionId || "";
  const [name] = useState(() => typeof window !== "undefined" ? localStorage.getItem("examkit_name") || "..." : "...");
  const [examTitle, setExamTitle] = useState("...");
  const [count, setCount] = useState(0);
  const [fbConnected, setFbConnected] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    let unsubStatus: (() => void) | undefined;
    let unsubStudents: (() => void) | undefined;

    (async () => {
      try {
        // 1. Session'dan examId'yi al (localStorage'a güvenme)
        const sessSnap = await get(ref(db(), `sessions/${sid}`));
        if (!sessSnap.exists()) {
          setError("Oturum bulunamadı. Lütfen tekrar katılmayı deneyin.");
          return;
        }
        const sess = sessSnap.val();
        const examId: string = sess.examId || "";
        if (!examId) {
          setError("Sınav bilgisi bulunamadı.");
          return;
        }
        setExamTitle(sess.examTitle || "Sınav");
        // examId'yi localStorage'a da yaz (exam sayfası için)
        if (typeof window !== "undefined") {
          localStorage.setItem("examkit_examId", examId);
        }

        setFbConnected(true);

        // 2. Mode'u RTDB'den al
        const modeSnap = await get(ref(db(), `exams/${examId}/mode`));
        const mode = modeSnap.val() || "scroll";
        if (typeof window !== "undefined") {
          localStorage.setItem("examkit_mode", mode);
        }

        // 3. Dinleyicileri başlat
        const { subscribeToExamStatus, subscribeToStudents } = await import("@/lib/realtime");
        unsubStatus = subscribeToExamStatus(examId, (status) => {
          const m = localStorage.getItem("examkit_mode") || "scroll";
          if (status === "active") window.location.href = `/exam/${sid}?mode=${m}`;
          if (status === "ended") window.location.href = `/results/${sid}`;
        });

        unsubStudents = subscribeToStudents(examId, (students) => {
          const names = Object.values(students);
          setCount(names.length);
        });
      } catch (e) {
        setError("Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.");
      }
    })();

    return () => { unsubStatus?.(); unsubStudents?.(); };
  }, [sid]);

  if (error) {
    return (
      <main className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
        <div className="w-full max-w-[480px] text-center space-y-6">
          <p className="text-error font-semibold">{error}</p>
          <Link href="/" className="text-primary underline">← Ana sayfaya dön</Link>
        </div>
      </main>
    );
  }

  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
      <div className="w-full max-w-[480px] text-center space-y-8">
        <div className="flex justify-center">
          <div className="w-[120px] h-[120px] rounded-full bg-primary flex items-center justify-center" style={{animation: "pulse 1.5s infinite"}}>
            <svg className="w-12 h-12 text-on-primary" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
          </div>
        </div>
        <h1 className="text-2xl font-bold text-text-primary">Öğretmeni bekleyin...</h1>
        {examTitle !== "..." && <p className="text-lg font-semibold text-primary">{examTitle}</p>}
        <div className="inline-flex items-center gap-2 px-4 py-2 bg-success-light text-success rounded-full text-sm font-medium">
          <span className="inline-block w-2 h-2 rounded-full bg-success" style={{animation: "pulse 1.5s infinite"}}/>
          {fbConnected ? `Bekleme odasında: ${count} öğrenci` : "Bağlanıyor..."}
        </div>
        <p className="text-sm text-text-secondary">Öğretmen başlatınca otomatik açılacak</p>
        <p className="text-sm text-success font-medium">Katılan: {name} ✓</p>
        <Link href="/" className="text-sm text-text-secondary underline">← Vazgeç ve çık</Link>
      </div>
    </main>
  );
}
