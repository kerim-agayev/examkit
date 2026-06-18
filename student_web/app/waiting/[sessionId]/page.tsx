"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";

export default function WaitingPage() {
  const params = useParams<{ sessionId: string }>();
  const [name] = useState(() => typeof window !== "undefined" ? localStorage.getItem("examkit_name") || "..." : "...");
  const [count] = useState(8);

  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
      <div className="w-full max-w-[480px] text-center space-y-8">
        <div className="flex justify-center">
          <div className="w-[120px] h-[120px] rounded-full bg-primary flex items-center justify-center" style={{animation: "pulse 1.5s infinite"}}>
            <svg className="w-12 h-12 text-on-primary" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
          </div>
        </div>
        <h1 className="text-2xl font-bold text-text-primary">Öğretmeni bekleyin...</h1>
        <p className="text-lg font-semibold text-primary">Biologiya Final İmtahanı</p>
        <div className="inline-flex items-center gap-2 px-4 py-2 bg-success-light text-success rounded-full text-sm font-medium">
          <span className="inline-block w-2 h-2 rounded-full bg-success" style={{animation: "pulse 1.5s infinite"}}/>Bekleme odasında: {count} öğrenci
        </div>
        <p className="text-sm text-text-secondary">Öğretmen başlatınca otomatik açılacak</p>
        <p className="text-sm text-success font-medium">Katılan: {name} ✓</p>
        <Link href="/" className="text-sm text-text-secondary underline">← Vazgeç ve çık</Link>
      </div>
    </main>
  );
}
