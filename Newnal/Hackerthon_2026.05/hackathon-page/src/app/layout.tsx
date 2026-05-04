import type { Metadata } from "next";
import { Syne, Geist_Mono } from "next/font/google";
import Script from "next/script";
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
  title: "AI-Native OS Hackathon",
  description:
    "The Era of Apps is Over. The Era of AI-native OS has Begun. May 9–10, 2026 at Stanford University. $10,000 in prizes.",
  openGraph: {
    title: "AI-Native OS Hackathon @Stanford",
    description: "May 9–10, 2026 · Stanford University · $10,000 in prizes",
    images: [{ url: "/og-image.png", width: 1200, height: 630 }],
  },
  twitter: {
    card: "summary_large_image",
    images: ["/og-image.png"],
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
      <Script
        src="https://www.googletagmanager.com/gtag/js?id=G-17Z2JVDVK9"
        strategy="afterInteractive"
      />
      <Script id="google-analytics" strategy="afterInteractive">
        {`
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', 'G-17Z2JVDVK9');
        `}
      </Script>
    </html>
  );
}
