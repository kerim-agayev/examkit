import type { Metadata } from "next";

export const metadata: Metadata = { title: "ExamKit — Sınava Katıl" };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="tr">
      <head>
        <script src="https://cdn.tailwindcss.com"></script>
        <script dangerouslySetInnerHTML={{__html: `
          tailwind.config = {
            theme: {
              extend: {
                colors: {
                  primary: '#2563EB', 'primary-light': '#DBEAFE', 'primary-dark': '#1E40AF', 'on-primary': '#FFFFFF',
                  success: '#059669', 'success-light': '#D1FAE5',
                  warning: '#D97706', 'warning-light': '#FEF3C7',
                  error: '#DC2626', 'error-light': '#FEE2E2',
                  info: '#0284C7', 'info-light': '#E0F2FE',
                  surface: '#FFFFFF', background: '#F1F5F9',
                  'text-primary': '#0F172A', 'text-secondary': '#475569', 'text-disabled': '#94A3B8',
                  border: '#E2E8F0'
                }
              }
            }
          }
        `}} />
      </head>
      <body>{children}</body>
    </html>
  );
}
