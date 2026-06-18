import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin", "latin-ext"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  title: "ExamKit — Sınava Katıl",
  description:
    "Uygulama indirmeden sınava katıl. Öğretmenin paylaştığı kodu gir, hemen başla.",
  keywords: ["sınav", "imtahan", "exam", "eğitim", "ExamKit", "online sınav"],
  robots: "index, follow",
  openGraph: {
    title: "ExamKit — Sınava Katıl",
    description: "Uygulama indirmeden sınava katıl.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="tr">
      <body
        className={`${inter.variable} font-sans antialiased bg-background text-text-primary`}
      >
        {children}
      </body>
    </html>
  );
}
