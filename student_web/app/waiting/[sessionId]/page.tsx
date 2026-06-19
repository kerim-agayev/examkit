"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";

export default function WaitingPage() {
  const params = useParams<{ sessionId: string }>();
  const sid = params.sessionId || "";
  const [name] = useState(() => typeof window !== "undefined" ? localStorage.getItem("examkit_name") || "..." : "...");
  const [examTitle, setExamTitle] = useState("...");
  const [count, setCount] = useState(0);
  const [fbConnected, setFbConnected] = useState(false);

  useEffect(() => {
    let unsubStatus: (() => void) | undefined;
    let unsubStudents: (() => void) | undefined;

    import("@/lib/realtime").then(({ subscribeToExamStatus, subscribeToStudents }) => {
      // RTDB'den gerçek öğrenci sayısı
      const examId = typeof window !== "undefined" ? localStorage.getItem("examkit_examId") || "mock_exam_id" : "mock_exam_id";
      setFbConnected(true);

        // Mode'u RTDB'den al
        import('firebase/database').then(({ref, get}) => {
          import('@/lib/firebase').then(({getRtdb}) => {
            get(ref(getRtdb()!, `exams/${examId}/mode`)).then(snap => {
              const mode = snap.val() || 'scroll';
              localStorage.setItem('examkit_mode', mode);
            });
          });
        });
        unsubStatus = subscribeToExamStatus(examId, (status) => {
          const mode = localStorage.getItem('examkit_mode') || 'scroll';
          if (status === "active") window.location.href = `/exam/${sid}?mode=${mode}`;
          if (status === "ended") window.location.href = `/results/${sid}`;
        });

      unsubStudents = subscribeToStudents(examId, (students) => {
        const names = Object.values(students);
        setCount(names.length);
      });
    }).catch(() => {});

    return () => { unsubStatus?.(); unsubStudents?.(); };
  }, [sid]);

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
