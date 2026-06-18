"use client";

import { useEffect, useState, useCallback } from "react";

interface ToastProps {
  message: string;
  type?: "success" | "error" | "info";
  duration?: number;
  onClose?: () => void;
}

const colors = { success: "bg-success text-on-primary", error: "bg-error text-on-primary", info: "bg-primary text-on-primary" };

function ToastItem({ message, type = "info", duration = 3000, onClose }: ToastProps) {
  useEffect(() => {
    const t = setTimeout(onClose, duration);
    return () => clearTimeout(t);
  }, [duration, onClose]);

  return (
    <div className={`px-4 py-3 rounded-xl shadow-lg animate-fade-in-up text-sm font-medium ${colors[type]}`}>
      {message}
    </div>
  );
}

// Global toast manager
let toastId = 0;
type ToastEntry = { id: number; message: string; type: "success" | "error" | "info" };

export function showToast(message: string, type: "success" | "error" | "info" = "info") {
  const event = new CustomEvent("examkit-toast", { detail: { id: ++toastId, message, type } });
  window.dispatchEvent(event);
}

export function ToastContainer() {
  const [toasts, setToasts] = useState<ToastEntry[]>([]);

  useEffect(() => {
    const handler = (e: Event) => {
      const detail = (e as CustomEvent).detail as ToastEntry;
      setToasts(prev => [...prev, detail]);
    };
    window.addEventListener("examkit-toast", handler);
    return () => window.removeEventListener("examkit-toast", handler);
  }, []);

  const remove = useCallback((id: number) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  }, []);

  return (
    <div className="fixed bottom-20 left-1/2 -translate-x-1/2 z-50 flex flex-col gap-2 w-[90%] max-w-[400px]">
      {toasts.map(t => <ToastItem key={t.id} message={t.message} type={t.type} onClose={() => remove(t.id)} />)}
    </div>
  );
}
