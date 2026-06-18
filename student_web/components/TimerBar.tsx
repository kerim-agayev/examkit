"use client";

/**
 * TimerBar — Global sınav süre sayacı.
 * Sticky top bar. Kırmızı <5 dk, yanıp sönme <1 dk.
 */

import { useEffect, useState } from "react";

interface TimerBarProps {
  totalMs: number | null; // null = süre sınırı yok
  onExpired?: () => void;
}

export function TimerBar({ totalMs, onExpired }: TimerBarProps) {
  const [remaining, setRemaining] = useState<number | null>(
    totalMs ? Math.max(0, totalMs) : null
  );

  useEffect(() => {
    if (remaining === null || remaining <= 0) return;
    const interval = setInterval(() => {
      setRemaining((prev) => {
        if (prev === null || prev <= 0) return prev;
        const next = prev - 1000;
        if (next <= 0) {
          onExpired?.();
          return 0;
        }
        return next;
      });
    }, 1000);
    return () => clearInterval(interval);
  }, [remaining, onExpired]);

  if (remaining === null || remaining <= 0) return null;

  const minutes = Math.floor(remaining / 60000);
  const seconds = Math.floor((remaining % 60000) / 1000);
  const display = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
  const isWarning = remaining < 300000; // <5 dk
  const isCritical = remaining < 60000; // <1 dk

  return (
    <div className="flex items-center gap-2">
      <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
        <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z" />
      </svg>
      <span
        className={`font-mono font-bold text-base tabular-nums ${
          isCritical
            ? "text-error animate-pulse"
            : isWarning
              ? "text-warning"
              : "text-text-primary"
        }`}
      >
        {display}
      </span>
    </div>
  );
}
