"use client";

/**
 * ConfirmDialog — Sınavı tamamlama onay dialog'u.
 * Sequential modda son soruda ve Scroll modda submit'te kullanılır.
 */

interface ConfirmDialogProps {
  open: boolean;
  title: string;
  message: string;
  cancelText?: string;
  confirmText?: string;
  onCancel: () => void;
  onConfirm: () => void;
}

export function ConfirmDialog({
  open,
  title,
  message,
  cancelText = "Geri Dön",
  confirmText = "Evet, Tamamla",
  onCancel,
  onConfirm,
}: ConfirmDialogProps) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 animate-fade-in-up">
      <div className="w-full max-w-[400px] bg-surface rounded-2xl p-6 space-y-5 shadow-xl">
        <div className="text-center">
          <span className="text-4xl">🎯</span>
          <h3 className="text-lg font-bold text-text-primary mt-2">{title}</h3>
          <p className="text-sm text-text-secondary mt-1">{message}</p>
        </div>
        <div className="flex gap-3">
          <button
            className="flex-1 h-[48px] rounded-xl border-[1.5px] border-border text-text-secondary font-semibold text-base hover:bg-surface-variant transition-colors"
            onClick={onCancel}
          >
            {cancelText}
          </button>
          <button
            className="flex-1 h-[48px] rounded-xl bg-success text-on-primary font-semibold text-base hover:bg-success/90 transition-colors"
            onClick={onConfirm}
          >
            {confirmText}
          </button>
        </div>
      </div>
    </div>
  );
}
