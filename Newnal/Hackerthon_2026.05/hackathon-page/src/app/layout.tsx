import type { Metadata } from "next";
import { Syne, Geist_Mono } from "next/font/google";
import "./globals.css";

const syne = Syne({
  variable: "--font-syne",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
  weight: ["400", "500"],
});

export const metadata: Metadata = {
  title: "Reinventing the Phone: AI-Native OS Hackathon | Newnal × Stanford SDGC",
  description:
    "The Era of Apps is Over. The Era of AI-native OS has Begun. May 9–10, 2026 at Stanford University. $10,000 in prizes.",
  openGraph: {
    title: "AI-Native OS Hackathon @Stanford",
    description: "May 9–10, 2026 · Stanford University · $10,000 in prizes",
    images: [{ url: "/og-image.svg", width: 1200, height: 630 }],
  },
  twitter: {
    card: "summary_large_image",
    images: ["/og-image.svg"],
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${syne.variable} ${geistMono.variable}`}
    >
      <body>{children}</body>
    </html>
  );
}
