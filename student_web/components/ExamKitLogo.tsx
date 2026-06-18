/**
 * ExamKit — Logo bileşeni.
 * Stitch mockup'daki "E" mark'ına referansla oluşturulmuş stylized logo.
 */

export function ExamKitLogo({ size = 32 }: { size?: number }) {
  return (
    <div
      className="flex items-center gap-2 select-none"
      style={{ height: size }}
    >
      {/* Stylized "E" mark */}
      <div
        className="bg-primary rounded-lg flex items-center justify-center shrink-0"
        style={{ width: size, height: size }}
      >
        <svg
          viewBox="0 0 24 24"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          style={{ width: size * 0.6, height: size * 0.6 }}
        >
          <rect x="5" y="4" width="14" height="3" rx="1.5" fill="white" />
          <rect x="5" y="10.5" width="11" height="3" rx="1.5" fill="white" />
          <rect x="5" y="17" width="14" height="3" rx="1.5" fill="white" />
          <path d="M5 5.5v13" stroke="white" strokeWidth="2" strokeLinecap="round" />
        </svg>
      </div>

      {/* Wordmark — sadece yeterli genişlikte göster */}
      {size >= 24 && (
        <span
          className="font-bold tracking-tight text-text-primary hidden sm:inline"
          style={{ fontSize: size * 0.55 }}
        >
          ExamKit
        </span>
      )}
    </div>
  );
}
