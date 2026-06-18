"use client";

/**
 * W3 — Bekleme Odası (/waiting/[sessionId])
 * Öğrenci, öğretmenin sınavı başlatmasını bekler.
 * RTDB stream ile otomatik geçiş.
 * Stitch referans: design/stitch_screens/bekleme_odas_1/code.html
 */

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";

export default function WaitingPage() {
  const params = useParams<{ sessionId: string }>();
  const sessionId = params.sessionId || "";

  const [studentName] = useState(() => {
    if (typeof window === "undefined") return "...";
    return localStorage.getItem("examkit_name") || "...";
  });

  const [studentCount, setStudentCount] = useState(8);

  // TODO: subscribeToExamStatus(examId) → RTDB stream
  // status "active" olunca → /exam/[sessionId] otomatik yönlendirme
  useEffect(() => {
    // Mock: sayı animasyonu
    const interval = setInterval(() => {
      setStudentCount((c) => c + (Math.random() > 0.7 ? 0 : 0));
    }, 10000);
    return () => clearInterval(interval);
  }, []);

  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
      <div className="w-full max-w-[480px] text-center space-y-8 animate-fade-in-up">
        {/* Pulse circle */}
        <div className="flex justify-center">
          <div className="relative">
            <div className="w-[120px] h-[120px] rounded-full bg-primary animate-pulse-green" />
            <div className="absolute inset-0 flex items-center justify-center">
              <svg
                className="w-12 h-12 text-on-primary"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z" />
              </svg>
            </div>
          </div>
        </div>

        {/* Headline */}
        <h1 className="text-2xl font-bold text-text-primary">
          Öğretmeni bekleyin...
        </h1>
        <p className="text-lg font-semibold text-primary">
          Biologiya Final İmtahanı
        </p>

        {/* Student count badge */}
        <div className="inline-flex items-center gap-2 px-4 py-2 bg-success-light text-success rounded-full text-sm font-medium">
          <span className="inline-block w-2 h-2 rounded-full bg-success animate-pulse-green" />
          Bekleme odasında: {studentCount} öğrenci
        </div>

        {/* Info */}
        <p className="text-sm text-text-secondary">
          Öğretmen başlatınca otomatik açılacak
        </p>

        {/* Joined confirmation */}
        <p className="text-sm text-success font-medium">
          Katılan: {studentName} ✓
        </p>

        {/* Back link */}
        <div className="pt-4">
          <Link
            href="/"
            className="text-sm text-text-secondary hover:text-text-primary underline transition-colors"
          >
            ← Vazgeç ve çık
          </Link>
        </div>

        {/* Thin animated loader at bottom */}
        <div className="w-full max-w-[320px] mx-auto h-1 bg-border rounded-full overflow-hidden">
          <div className="h-full w-1/3 bg-primary rounded-full animate-[pulse_1.5s_infinite]" />
        </div>
      </div>
    </main>
  );
}
