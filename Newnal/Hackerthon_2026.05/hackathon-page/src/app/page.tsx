'use client';

import { useEffect, useRef, type CSSProperties, type ReactNode } from 'react';
import Image from 'next/image';

/* ═══════════════════════════════════════════════════════════
   DESIGN TOKENS (inline)
   ═══════════════════════════════════════════════════════════ */
const C = {
  bg: '#000000',
  bgAlt: '#111111',
  accent: '#4D9FFF',
  textPrimary: '#ffffff',
  textSub: '#FFFFFFB3',
  textBody: '#FFFFFF80',
  textMuted: '#FFFFFF66',
  textDim: '#FFFFFF4D',
  line: '#222222',
  blueGlow: '#4D9FFF66',
  blueBorder: '#4D9FFF4D',
  blueBg: '#4D9FFF0A',
  gray: '#666666',
} as const;

const FONT = {
  syne: "var(--font-syne), system-ui, sans-serif",
  body: "'Google Sans', system-ui, sans-serif",
  mono: "'Google Sans', system-ui, sans-serif",
} as const;

/* ═══════════════════════════════════════════════════════════
   REUSABLE COMPONENTS
   ═══════════════════════════════════════════════════════════ */

/* ── Section Reveal ── */
function SectionReveal({ children, style, className }: { children: ReactNode; style?: CSSProperties; className?: string }) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const obs = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          el.classList.add('revealed');
          obs.unobserve(el);
        }
      },
      { threshold: 0.08 }
    );
    obs.observe(el);
    return () => obs.disconnect();
  }, []);

  return (
    <div ref={ref} className={`section-reveal ${className ?? ''}`} style={style}>
      {children}
    </div>
  );
}

/* ── Inner Container ── */
function Inner({ children, style }: { children: ReactNode; style?: CSSProperties }) {
  return (
    <div
      style={{
        maxWidth: 1000,
        margin: '0 auto',
        padding: '0 60px',
        ...style,
      }}
      className="inner-container"
    >
      {children}
    </div>
  );
}

/* ── Section Number / Label ── */
function SecNum({ children }: { children: string }) {
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 16,
        marginBottom: 24,
      }}
    >
      <span
        style={{
          fontFamily: FONT.mono,
          fontSize: 16,
          letterSpacing: '0.2em',
          textTransform: 'uppercase',
          color: C.accent,
        }}
      >
        {children}
      </span>
    </div>
  );
}

/* ── Section Title (H2) ── */
function SectionTitle({ children }: { children: ReactNode }) {
  return (
    <h2
      style={{
        fontFamily: FONT.syne,
        fontSize: 'clamp(32px, 4vw, 48px)',
        fontWeight: 400,
        letterSpacing: '-0.02em',
        lineHeight: 1.3,
        color: C.textPrimary,
        textAlign: 'center',
        marginBottom: 20,
      }}
    >
      {children}
    </h2>
  );
}

/* ── Message ── */
function Message({ children }: { children: ReactNode }) {
  return (
    <p
      style={{
        fontSize: 18,
        color: C.textSub,
        lineHeight: 1.7,
        maxWidth: 680,
        margin: '0 auto',
        textAlign: 'center',
      }}
    >
      {children}
    </p>
  );
}

/* ── Body Text ── */
function Body({ children, style }: { children: ReactNode; style?: CSSProperties }) {
  return (
    <p
      className="body-text"
      style={{
        fontWeight: 400,
        color: C.textBody,
        lineHeight: 1.9,
        maxWidth: 760,
        margin: '0 auto',
        textAlign: 'center',
        ...style,
      }}
    >
      {children}
    </p>
  );
}

/* ── Callout ── */
function Callout({ children }: { children: ReactNode }) {
  return (
    <div
      style={{
        borderTop: `2px solid ${C.accent}`,
        borderBottom: `1px solid #4D9FFF26`,
        padding: '28px 36px',
        background: C.blueBg,
        margin: '40px auto',
        maxWidth: 580,
        textAlign: 'center',
      }}
    >
      <p className="body-text" style={{ color: C.textSub, lineHeight: 1.7 }}>{children}</p>
    </div>
  );
}

/* ── Divider ── */
function Divider() {
  return <div style={{ width: 48, height: 1, background: C.line, margin: '48px auto' }} />;
}

/* ── Primary Button ── */
function PrimaryBtn({ children, href, small }: { children: ReactNode; href: string; small?: boolean }) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      style={{
        display: 'inline-block',
        background: C.accent,
        color: '#000',
        fontFamily: FONT.body,
        fontSize: small ? 13 : 15,
        fontWeight: 500,
        padding: small ? '10px 22px' : '14px 32px',
        border: 'none',
        borderRadius: 2,
        textDecoration: 'none',
        cursor: 'pointer',
        transition: 'opacity 0.2s',
        whiteSpace: 'nowrap',
      }}
      onMouseEnter={(e) => (e.currentTarget.style.opacity = '0.85')}
      onMouseLeave={(e) => (e.currentTarget.style.opacity = '1')}
    >
      {children}
    </a>
  );
}

/* ── Secondary Button ── */
function SecondaryBtn({ children, href, small }: { children: ReactNode; href: string; small?: boolean }) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      style={{
        display: 'inline-block',
        background: 'transparent',
        border: '1px solid #FFFFFF33',
        color: '#fff',
        fontFamily: FONT.body,
        fontSize: small ? 13 : 15,
        fontWeight: 500,
        padding: small ? '10px 22px' : '14px 32px',
        borderRadius: 2,
        textDecoration: 'none',
        cursor: 'pointer',
        transition: 'border-color 0.2s, color 0.2s',
        whiteSpace: 'nowrap',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.borderColor = C.accent;
        e.currentTarget.style.color = C.accent;
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.borderColor = '#FFFFFF33';
        e.currentTarget.style.color = '#fff';
      }}
    >
      {children}
    </a>
  );
}

/* ── Three Grid ── */
function ThreeGrid({ items }: { items: { num: string; title: string }[] }) {
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: 1,
        background: C.line,
        margin: '40px auto',
        maxWidth: 760,
      }}
      className="three-grid"
    >
      {items.map((item, i) => (
        <div
          key={i}
          style={{
            background: C.bgAlt,
            padding: '36px 28px',
            textAlign: 'center',
          }}
        >
          <div
            style={{
              fontFamily: FONT.mono,
              fontSize: 9,
              color: C.accent,
              letterSpacing: '0.15em',
              textTransform: 'uppercase',
              marginBottom: 12,
            }}
          >
            {item.num}
          </div>
          <div
            style={{
              fontFamily: FONT.body,
              fontSize: 15,
              color: '#FFFFFFE6',
            }}
          >
            {item.title}
          </div>
        </div>
      ))}
    </div>
  );
}

/* ── Timeline Row ── */
function TimelineRow({ date, content }: { date: string; content: ReactNode }) {
  return (
    <div
      style={{
        display: 'flex',
        gap: 24,
        padding: '24px 0',
        borderBottom: `1px solid ${C.line}`,
        alignItems: 'flex-start',
      }}
      className="timeline-row"
    >
      <div
        style={{
          fontFamily: FONT.mono,
          fontSize: 11,
          color: C.accent,
          textTransform: 'uppercase',
          letterSpacing: '0.15em',
          minWidth: 140,
          flexShrink: 0,
          paddingTop: 3,
        }}
        className="timeline-date"
      >
        {date}
      </div>
      <div
        className="body-text"
        style={{
          fontFamily: FONT.body,
          color: '#FFFFFFD9',
          lineHeight: 1.7,
        }}
      >
        {content}
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════
   MAIN PAGE
   ═══════════════════════════════════════════════════════════ */
export default function HackathonPage() {
  return (
    <>
      {/* ── Responsive Styles ── */}
      <style jsx global>{`
        @media (max-width: 1024px) {
          .inner-container {
            padding: 0 40px !important;
          }
          .hero-grid {
            grid-template-columns: 1fr !important;
            padding: 100px 40px 60px !important;
            max-width: 700px !important;
            text-align: center;
          }
          .hero-text { order: 2; }
          .hero-poster-wrap { order: 1; margin-bottom: 40px; }
          .hero-h1-text { font-size: 64px !important; }
          .hero-cta-row { justify-content: center !important; }
          .hero-eyebrow-text { justify-content: center !important; }
        }
        @media (max-width: 768px) {
          .inner-container {
            padding: 0 20px !important;
          }
          .section-pad {
            padding-top: 80px !important;
            padding-bottom: 80px !important;
          }
          .hero-title-block {
            padding: 60px 20px 32px !important;
          }
          .hero-content-row {
            padding: 0 20px 60px !important;
            flex-direction: column !important;
          }
          .hero-stanford-img {
            width: 100% !important;
            aspect-ratio: 4/3 !important;
          }
          .hero-info-rows {
            width: 100% !important;
          }
          .hero-h1-text { font-size: 52px !important; }
          .hero-info-col {
            width: 100% !important;
          }
          .hero-cta-row {
            margin: 0 20px !important;
            padding-top: 24px !important;
          }
          .track-grid {
            grid-template-columns: 1fr !important;
          }
          .two-col {
            grid-template-columns: 1fr !important;
          }
          .three-grid {
            grid-template-columns: 1fr !important;
          }
          .three-col-reg {
            grid-template-columns: 1fr !important;
          }
          .timeline-row {
            flex-direction: column !important;
            gap: 8px !important;
          }
          .timeline-date {
            min-width: unset !important;
          }
          .nav-inner {
            padding: 16px 20px !important;
          }
        }
        @media (max-width: 425px) {
          .hero-title-block { padding: 48px 20px 24px !important; }
          .hero-content-row { padding: 0 20px 48px !important; }
          .hero-info-row { padding: 8px 16px !important; }
        }
        .body-text { font-size: 18px; }
        @media (max-width: 768px) { .body-text { font-size: 16px !important; } }
        @media (max-width: 768px) {
          .schedule-row {
            flex-direction: column !important;
            gap: 12px !important;
            padding: 20px 16px !important;
            background: #111 !important;
            border-bottom: none !important;
            border-radius: 0 !important;
            margin-bottom: 1px !important;
          }
          .schedule-date {
            min-width: unset !important;
            font-size: 14px !important;
          }
        }
      `}</style>

      {/* ═══════════════════════════════════════════════════════
          1. NAV
          ═══════════════════════════════════════════════════════ */}
      <nav
        style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          zIndex: 100,
          backdropFilter: 'blur(16px)',
          WebkitBackdropFilter: 'blur(16px)',
          background: '#000000D9',
          borderBottom: '1px solid #FFFFFF0D',
        }}
      >
        <div
          className="nav-inner"
          style={{
            maxWidth: 1300,
            margin: '0 auto',
            padding: '0 60px',
            height: 68,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: 32,
          }}
        >
          {/* Logo */}
          <a
            href="https://newnal.com"
            target="_blank"
            rel="noopener noreferrer"
            style={{
              fontFamily: FONT.syne,
              fontSize: 18,
              letterSpacing: '0.15em',
              textTransform: 'uppercase',
              color: C.textPrimary,
              fontWeight: 700,
              textDecoration: 'none',
              flexShrink: 0,
            }}
          >
            NEWNAL
          </a>

          {/* CTA Buttons */}
          <div style={{ display: 'flex', gap: 10, flexShrink: 0 }}>
            <PrimaryBtn href="https://luma.com/rrdnhd97" small>REGISTER</PrimaryBtn>
            <SecondaryBtn href="https://discord.gg/utpTjdCRNe" small>DISCORD</SecondaryBtn>
          </div>
        </div>
      </nav>

      {/* ═══════════════════════════════════════════════════════
          2. HERO
          ═══════════════════════════════════════════════════════ */}
      <section
        style={{
          background: '#000',
          overflow: 'hidden',
          paddingTop: 68,
        }}
      >
        {/* Title block */}
        <div
          className="hero-title-block"
          style={{
            maxWidth: 1300,
            margin: '0 auto',
            padding: '80px 60px 40px',
            display: 'flex',
            flexDirection: 'column',
            gap: 8,
            textAlign: 'center',
            alignItems: 'center',
          }}
        >
          <h1
            className="hero-h1-text"
            style={{
              fontFamily: FONT.syne,
              fontWeight: 400,
              fontSize: 'clamp(42px, 5.8vw, 84px)',
              color: C.textPrimary,
              lineHeight: 1,
              margin: 0,
            }}
          >
            AI-Native OS Hackathon @Stanford
          </h1>
          <div
            style={{
              fontFamily: FONT.syne,
              fontWeight: 400,
              fontSize: 'clamp(14px, 2.2vw, 32px)',
              color: C.textPrimary,
              lineHeight: 1,
            }}
          >
            HOSTED BY{' '}
            <span style={{ color: C.accent }}>STANFORD SDGC</span>
            {' '}IN PARTNERSHIP WITH{' '}
            <span style={{ color: C.accent }}>NEWNAL</span>
          </div>
        </div>

        {/* Content row: image + info */}
        <div
          className="hero-content-row"
          style={{
            maxWidth: 1300,
            margin: '0 auto',
            padding: '0 60px 80px',
            display: 'flex',
            alignItems: 'flex-start',
            gap: 0,
          }}
        >
          {/* Stanford image */}
          <div
            className="hero-stanford-img"
            style={{
              flexShrink: 0,
              width: '50%',
              aspectRatio: '563/572',
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            <Image
              src="https://www.figma.com/api/mcp/asset/58c4c2c0-673d-4635-966b-ccb1ddf70fa2"
              alt="Stanford University"
              fill
              style={{ objectFit: 'cover' }}
              priority
              unoptimized
            />
          </div>

          {/* Info + buttons */}
          <div className="hero-info-col" style={{ width: '50%', flexShrink: 0, minWidth: 0, display: 'flex', flexDirection: 'column' }}>
            {/* Info rows */}
            <div className="hero-info-rows" style={{ flex: 1 }}>
              {[
                { label: 'WHEN', lines: ['May 9–10, 2026 (Sat–Sun)'], highlight: false },
                { label: 'WHERE', lines: ['Stanford Shriram Center for Bioengineering and Chemical Engineering'], highlight: false },
                { label: 'WHO', lines: ['Open to all Stanford undergraduate & graduate students', 'Individuals or teams welcome — max 5 members per team, up to 20 teams'], highlight: false },
                { label: 'PRIZE', lines: ['- 1ST PLACE  $5,000', '- 2ND PLACE  $3,000', '- 3RD PLACE  $2,000', '---', 'Winning teams will be granted a main-stage speaking slot at the upcoming conference on May 18th.'], highlight: false },
              ].map((row) => (
                <div
                  key={row.label}
                  className="hero-info-row"
                  style={{
                    borderLeft: `2px solid ${row.highlight ? C.accent : C.gray}`,
                    background: row.highlight ? '#444' : 'transparent',
                    padding: '10px 20px',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: 8,
                    transition: 'background 0.2s, border-color 0.2s',
                    cursor: 'default',
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.background = '#444';
                    e.currentTarget.style.borderLeftColor = C.accent;
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.background = row.highlight ? '#444' : 'transparent';
                    e.currentTarget.style.borderLeftColor = row.highlight ? C.accent : C.gray;
                  }}
                >
                  <div
                    style={{
                      fontFamily: FONT.syne,
                      fontSize: 16,
                      fontWeight: 700,
                      color: row.highlight ? C.textPrimary : C.accent,
                      letterSpacing: '1px',
                      lineHeight: 1.6,
                    }}
                  >
                    {row.label}
                  </div>
                  <div style={{ fontFamily: FONT.syne, fontSize: 18, color: C.textPrimary, lineHeight: 1.6 }}>
                    {row.lines.map((line, i) =>
                      line === '---'
                        ? <div key={i} style={{ width: '100%', height: 1, background: C.line, margin: '8px 0' }} />
                        : <div key={i}>{line}</div>
                    )}
                  </div>
                </div>
              ))}
            </div>

            {/* CTA buttons */}
            <div
              className="hero-cta-row"
              style={{ display: 'flex', paddingTop: 40 }}
            >
              <a
                href="https://luma.com/rrdnhd97"
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  flex: 1,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  padding: 20,
                  background: 'transparent',
                  border: '1px solid #FFFFFF33',
                  color: '#fff',
                  fontFamily: FONT.syne,
                  fontSize: 16,
                  textDecoration: 'none',
                  transition: 'background 0.2s, border-color 0.2s',
                }}
                onMouseEnter={(e) => { e.currentTarget.style.background = C.accent; e.currentTarget.style.borderColor = C.accent; e.currentTarget.style.color = '#000'; }}
                onMouseLeave={(e) => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.borderColor = '#FFFFFF33'; e.currentTarget.style.color = '#fff'; }}
              >
                REGISTER NOW
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M4 16L16 4M16 4H8M16 4V12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </a>
              <a
                href="https://discord.gg/utpTjdCRNe"
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  flex: 1,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  padding: 20,
                  border: '1px solid #FFFFFF33',
                  color: '#fff',
                  fontFamily: FONT.syne,
                  fontSize: 16,
                  textDecoration: 'none',
                  transition: 'border-color 0.2s, color 0.2s',
                }}
                onMouseEnter={(e) => { e.currentTarget.style.background = C.accent; e.currentTarget.style.borderColor = C.accent; e.currentTarget.style.color = '#000'; }}
                onMouseLeave={(e) => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.borderColor = '#FFFFFF33'; e.currentTarget.style.color = '#fff'; }}
              >
                JOIN DISCORD
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M4 16L16 4M16 4H8M16 4V12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════
          2-B. NEWNAL PHONE BENEFIT (Hero 직후, 폰 배경)
          ═══════════════════════════════════════════════════════ */}
      <section
        id="phone-benefit"
        style={{
          position: 'relative',
          background: '#000',
          overflow: 'hidden',
          padding: '160px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        {/* 배경 폰 이미지 — 더 크고 밝게 */}
        <div
          style={{
            position: 'absolute',
            inset: 0,
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            opacity: 0.55,
            pointerEvents: 'none',
          }}
        >
          <Image
            src="/hero2.png"
            alt=""
            fill
            style={{ objectFit: 'contain', objectPosition: 'center' }}
            unoptimized
          />
        </div>
        {/* 하단 그라디언트 */}
        <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, height: '50%', background: 'linear-gradient(to top, #000 0%, transparent 100%)', pointerEvents: 'none', zIndex: 1 }} />

        {/* 콘텐츠 — 하단 배치 */}
        <SectionReveal style={{ position: 'relative', zIndex: 2, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', minHeight: 480 }}>
          <Inner style={{ textAlign: 'center', paddingTop: 320 }}>
            <SecNum>— SPECIAL BENEFIT —</SecNum>
            <SectionTitle>Every Participant Gets a Newnal Phone</SectionTitle>
            <Message>
              As a special first release, all participants will be provided with the{' '}
              <span style={{ color: C.accent, fontWeight: 500 }}>Newnal AIOS Phone V1</span>{' '}
              — real AI-native OS hardware to build, test, and prototype on throughout the hackathon.
            </Message>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          3. THE CHALLENGE
          ═══════════════════════════════════════════════════════ */}
      <section
        id="challenge"
        className="section-pad"
        style={{
          background: C.bg,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— THE CHALLENGE —</SecNum>
            <SectionTitle>Join the First Generation of Builders</SectionTitle>
            <Message>
              Every once in a while, a revolutionary product changes everything. 1995 gave us
              Windows. 2007 gave us the iPhone. Today, join us in building the first AI-native OS
              phone for the AI Computing Era.
            </Message>
            <Callout>
              The Era of Apps is Over.
              <br />
              Apps will be replaced by AI Agents.
              <br />
              Be the ones who build them first.
            </Callout>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          4. TRACKS
          ═══════════════════════════════════════════════════════ */}
      <section
        id="tracks"
        className="section-pad"
        style={{
          background: C.bgAlt,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— TRACKS —</SecNum>
            <SectionTitle>Choose Your Track</SectionTitle>
            <Message>Two paths. One mission: reinvent the phone. Participants may choose one of the following tracks or combine elements across tracks.</Message>

            <div
              className="track-grid"
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                gap: 1,
                background: C.line,
                marginTop: 48,
              }}
            >
              {/* Track 1 */}
              <div
                style={{
                  borderTop: `2px solid ${C.accent}`,
                  background: C.bg,
                  padding: '40px 32px',
                  display: 'flex',
                  flexDirection: 'column',
                }}
              >
                {/* Card body — grows to fill */}
                <div style={{ flex: 1 }}>
                  <div style={{ marginBottom: 16 }}>
                    <span
                      style={{
                        fontFamily: FONT.mono,
                        fontSize: 13,
                        letterSpacing: '0.1em',
                        color: C.accent,
                        textTransform: 'uppercase',
                      }}
                    >
                      TRACK 01
                    </span>
                  </div>
                  <h3
                    style={{
                      fontFamily: FONT.syne,
                      fontSize: 22,
                      fontWeight: 400,
                      color: C.textPrimary,
                      marginBottom: 16,
                      lineHeight: 1.3,
                    }}
                  >
                    Redesigning the Newnal AIOS Phone Experience
                  </h3>
                  <p
                    className="body-text"
                    style={{
                      color: C.textSub,
                      lineHeight: 1.7,
                      marginBottom: 16,
                    }}
                  >
                    The Newnal V1 phone is a device that embodies the core architecture of Newnal OS. Design innovation includes but is not limited to: creating a new onboarding process, building a new AI interface, hardware design, and/or the archetypal UX fit for the new AI era.
                  </p>
                  <div style={{ width: '100%', height: 1, background: C.line, margin: '4px 0 16px' }} />
                  <p
                    className="body-text"
                    style={{
                      color: C.textSub,
                      lineHeight: 1.7,
                    }}
                  >
                    Participants are encouraged, but not required, to consider sustainable principles, such as: (1) Systems designed to encourage sustainable consumption rather than maximize usage, (2) Designs that support Newnal's mission of user sovereignty, including ethical data use and control.
                  </p>
                </div>
              </div>

              {/* Track 2 */}
              <div
                style={{
                  borderTop: `2px solid ${C.accent}`,
                  background: C.bg,
                  padding: '40px 32px',
                  display: 'flex',
                  flexDirection: 'column',
                }}
              >
                {/* Card body — grows to fill */}
                <div style={{ flex: 1 }}>
                  <div style={{ marginBottom: 16 }}>
                    <span
                      style={{
                        fontFamily: FONT.mono,
                        fontSize: 13,
                        letterSpacing: '0.1em',
                        color: C.accent,
                        textTransform: 'uppercase',
                      }}
                    >
                      TRACK 02
                    </span>
                  </div>
                  <h3
                    style={{
                      fontFamily: FONT.syne,
                      fontSize: 22,
                      fontWeight: 400,
                      color: C.textPrimary,
                      marginBottom: 16,
                      lineHeight: 1.3,
                    }}
                  >
                    Developing AI Agents on Newnal AIOS Phone
                  </h3>
                  <p
                    className="body-text"
                    style={{
                      color: C.textSub,
                      lineHeight: 1.7,
                      marginBottom: 16,
                    }}
                  >
                    In the AI era, most of the IT technology-based services currently offered in the form of "Apps" will be converted to "AI Agents". Implement AI Agent services that can be demonstrated on the Newnal AIOS phone provided with creative ideas on AI Agents that can grow into future killer AI services operating in the Newnal AIOS ecosystem.
                  </p>
                  <div style={{ width: '100%', height: 1, background: C.line, margin: '4px 0 16px' }} />
                  <p
                    className="body-text"
                    style={{
                      color: C.textSub,
                      lineHeight: 1.7,
                    }}
                  >
                    Participants are encouraged, but not required, to consider sustainable principles, such as: (1) Leverage personal AI agents to solve real-world challenges in sustainability, accessibility, and social welfare, (2) AI services for underserved communities.
                  </p>
                </div>
              </div>
            </div>

            <Body style={{ marginTop: 40 }}>
              Both tracks encourage sustainable principles — designing systems that promote
              sustainable consumption, user sovereignty, accessibility, and social welfare.
            </Body>
          </Inner>
        </SectionReveal>
      </section>


      {/* ═══════════════════════════════════════════════════════
          6. SCHEDULE
          ═══════════════════════════════════════════════════════ */}
      <section
        id="schedule"
        className="section-pad"
        style={{
          background: C.bgAlt,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— SCHEDULE —</SecNum>
            <SectionTitle>Event Schedule</SectionTitle>

            <div style={{ marginTop: 48 }}>
              {/* Simple rows */}
              {[
                { date: '~ MAY 4', label: 'Applications Open Until May 4', sub: 'Selected applicants will be notified — not all who apply are guaranteed a spot.' },
              ].map((item, i) => (
                <div
                  key={i}
                  className="schedule-row"
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: 20,
                    padding: '20px 0',
                    borderBottom: `1px solid ${C.line}`,
                  }}
                >
                  <span
                    className="schedule-date"
                    style={{
                      fontFamily: FONT.mono,
                      fontSize: 18,
                      color: C.accent,
                      letterSpacing: '0.1em',
                      textTransform: 'uppercase',
                      minWidth: 200,
                      flexShrink: 0,
                      paddingTop: 2,
                    }}
                  >
                    {item.date}
                  </span>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                    <span style={{ fontFamily: FONT.syne, fontSize: 18, color: C.textPrimary, letterSpacing: '0.03em' }}>
                      {item.label}
                    </span>
                    {item.sub && (
                      <span style={{ fontFamily: FONT.body, fontSize: 15, color: C.textMuted, lineHeight: 1.6 }}>
                        {item.sub}
                      </span>
                    )}
                  </div>
                </div>
              ))}

              {/* Day rows with tag + detail */}
              {[
                {
                  date: 'MAY 9',
                  day: 'DAY 1',
                  details: ['09:00  Check-in', '09:30  Opening', '13:00  Working Session'],
                },
                {
                  date: 'MAY 10',
                  day: 'DAY 2',
                  details: ['13:30  Check-in', '14:00 – 17:00  Presentations', '17:00  Winners Announced'],
                },
                {
                  date: 'MAY 18',
                  day: 'UPCOMING CONFERENCE',
                  details: ['Winning teams will be granted a main-stage speaking slot'],
                },
              ].map((item, i) => (
                <div
                  key={item.date}
                  className="schedule-row"
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: 20,
                    padding: '20px 0',
                    borderBottom: `1px solid ${C.line}`,
                  }}
                >
                  <span
                    className="schedule-date"
                    style={{
                      fontFamily: FONT.mono,
                      fontSize: 18,
                      color: C.accent,
                      letterSpacing: '0.1em',
                      textTransform: 'uppercase',
                      minWidth: 200,
                      flexShrink: 0,
                      paddingTop: 2,
                    }}
                  >
                    {item.date}
                  </span>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                    {/* Tag */}
                    <span
                      style={{
                        display: 'inline-block',
                        fontFamily: FONT.mono,
                        fontSize: 16,
                        color: C.accent,
                        letterSpacing: '0.15em',
                        border: `1px solid ${C.accent}`,
                        background: C.blueBg,
                        padding: '4px 14px',
                        alignSelf: 'flex-start',
                      }}
                    >
                      {item.day}
                    </span>
                    {/* Details */}
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                      {item.details.map((d, j) => (
                        <span key={j} style={{ fontFamily: FONT.mono, fontSize: 18, color: C.textPrimary, letterSpacing: '0.03em' }}>
                          {d}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          7. PRIZES
          ═══════════════════════════════════════════════════════ */}
      <section
        id="prizes"
        className="section-pad"
        style={{
          background: C.bg,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— PRIZES —</SecNum>
            <SectionTitle>Total Prize Pool: $10,000</SectionTitle>

            {/* Prize Grid */}
            <div
              className="three-grid"
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(3, 1fr)',
                gap: 1,
                background: C.line,
                margin: '48px auto',
                maxWidth: 760,
              }}
            >
              {[
                { place: '1ST PLACE', amount: '$5,000' },
                { place: '2ND PLACE', amount: '$3,000' },
                { place: '3RD PLACE', amount: '$2,000' },
              ].map((p, i) => (
                <div
                  key={i}
                  style={{
                    background: i === 0 ? C.bgAlt : C.bg,
                    padding: '48px 28px',
                    textAlign: 'center',
                    borderTop: i === 0 ? `2px solid ${C.accent}` : `1px solid ${C.line}`,
                  }}
                >
                  <div
                    style={{
                      fontFamily: FONT.mono,
                      fontSize: 10,
                      color: C.accent,
                      letterSpacing: '0.2em',
                      textTransform: 'uppercase',
                      marginBottom: 16,
                    }}
                  >
                    {p.place}
                  </div>
                  <div
                    style={{
                      fontFamily: FONT.syne,
                      fontSize: 'clamp(28px, 4vw, 40px)',
                      fontWeight: 700,
                      color: C.textPrimary,
                    }}
                  >
                    {p.amount}
                  </div>
                </div>
              ))}
            </div>

            <Body>
              Winning teams will be granted a main-stage speaking slot at the upcoming conference on May 18th. Sponsored by Stanford SDGC and Newnal.
            </Body>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          8. JUDGING & REGISTRATION
          ═══════════════════════════════════════════════════════ */}
      <section
        id="register"
        className="section-pad"
        style={{
          background: C.bgAlt,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— HOW TO PARTICIPATE —</SecNum>
            <SectionTitle>Judging &amp; What to Bring</SectionTitle>

            {/* Two-col grid */}
            <div
              className="two-col"
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                gap: 1,
                background: C.line,
                marginTop: 48,
              }}
            >
              {/* Judging */}
              <div style={{ background: C.bgAlt, padding: '32px 28px' }}>
                <h3
                  style={{
                    fontFamily: FONT.syne,
                    fontSize: 20,
                    fontWeight: 400,
                    color: C.textPrimary,
                    marginBottom: 16,
                  }}
                >
                  Judging Criteria
                </h3>
                <ul style={{ listStyle: 'none', padding: 0 }}>
                  {[
                    'Panel from SDGC, Newnal, and invited industry leaders',
                    'All presentations will be evaluated on May 10',
                    'Winners get main-stage speaking slot at upcoming conference on May 18',
                  ].map((item, i) => (
                    <li
                      key={i}
                      className="body-text"
                      style={{
                        color: C.textSub,
                        lineHeight: 1.7,
                        padding: '8px 0',
                        borderBottom: `1px solid ${C.line}`,
                        display: 'flex',
                        gap: 12,
                        alignItems: 'flex-start',
                      }}
                    >
                      <span style={{ color: C.textSub, flexShrink: 0 }}>-</span>
                      {item}
                    </li>
                  ))}
                </ul>
              </div>

              {/* What to Bring */}
              <div style={{ background: C.bgAlt, padding: '32px 28px' }}>
                <h3
                  style={{
                    fontFamily: FONT.syne,
                    fontSize: 20,
                    fontWeight: 400,
                    color: C.textPrimary,
                    marginBottom: 16,
                  }}
                >
                  What to Bring
                </h3>
                <ul style={{ listStyle: 'none', padding: 0 }}>
                  {[
                    'Laptop and charger',
                    'Stanford Student ID (required at check-in)',
                    'Curiosity, creativity, and a strong drive to build',
                  ].map((item, i) => (
                    <li
                      key={i}
                      className="body-text"
                      style={{
                        color: C.textSub,
                        lineHeight: 1.7,
                        padding: '8px 0',
                        borderBottom: `1px solid ${C.line}`,
                        display: 'flex',
                        gap: 12,
                        alignItems: 'flex-start',
                      }}
                    >
                      <span style={{ color: C.textSub, flexShrink: 0 }}>-</span>
                      {item}
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            <Divider />

            {/* Discord */}
            <Body>
              A dedicated Discord channel opens April 20 with tech docs, team formation support,
              and direct Q&amp;A with Newnal engineers. The channel stays active post-hackathon to
              keep participants connected.
            </Body>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          9. ABOUT
          ═══════════════════════════════════════════════════════ */}
      <section
        id="about"
        className="section-pad"
        style={{
          background: C.bg,
          padding: '120px 0',
          borderBottom: `1px solid ${C.line}`,
        }}
      >
        <SectionReveal>
          <Inner>
            <SecNum>— ABOUT —</SecNum>
            <SectionTitle>About the Organizers</SectionTitle>

            <div
              className="two-col"
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                gap: 48,
                marginTop: 48,
              }}
            >
              {/* Newnal */}
              <div>
                <h3
                  style={{
                    fontFamily: FONT.syne,
                    fontSize: 20,
                    fontWeight: 400,
                    color: C.textPrimary,
                    marginBottom: 16,
                  }}
                >
                  Newnal
                </h3>
                <p className="body-text" style={{ color: C.textBody, lineHeight: 1.9 }}>
                  Newnal is developing a next-generation AI-native operating system on mobile
                  devices, enabling a new paradigm of deeply personalized AI agents and
                  experiences. Each user interacts with a personal AI that proactively generates
                  recommendations tailored to individual preferences, contexts, and needs.
                </p>
              </div>

              {/* Stanford SDGC */}
              <div>
                <h3
                  style={{
                    fontFamily: FONT.syne,
                    fontSize: 20,
                    fontWeight: 400,
                    color: C.textPrimary,
                    marginBottom: 16,
                  }}
                >
                  Stanford SDGC
                </h3>
                <p className="body-text" style={{ color: C.textBody, lineHeight: 1.9 }}>
                  For over 20 years, Stanford SDGC has engaged in research and educational
                  programs integrating organization development strategies and cutting-edge
                  technologies with leadership practices ensuring growth within a sustainable
                  environment. Today exploring application of native AI solutions to global supply
                  chains, product design, infrastructure, finance, and knowledge management.
                </p>
              </div>
            </div>

            <Divider />

            <div style={{ textAlign: 'center', maxWidth: 680, margin: '0 auto' }}>
              <p
                style={{
                  fontSize: 18,
                  color: C.textSub,
                  lineHeight: 1.8,
                  fontStyle: 'italic',
                }}
              >
                This is not the era where AI becomes the center of the world.
                <br />
                This is the era where you become the center of AI.
              </p>
            </div>
          </Inner>
        </SectionReveal>
      </section>

      {/* ═══════════════════════════════════════════════════════
          11. FOOTER
          ═══════════════════════════════════════════════════════ */}
      <footer
        style={{
          borderTop: `1px solid ${C.line}`,
          padding: '32px 60px',
        }}
      >
        <div
          className="nav-inner"
          style={{
            maxWidth: 1300,
            margin: '0 auto',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            flexWrap: 'wrap',
            gap: 16,
          }}
        >
          <span
            style={{
              fontFamily: FONT.syne,
              fontSize: 16,
              letterSpacing: '0.15em',
              textTransform: 'uppercase',
              color: C.textPrimary,
              fontWeight: 700,
            }}
          >
            NEWNAL
          </span>
          <span
            style={{
              fontFamily: FONT.mono,
              fontSize: 11,
              color: C.gray,
              letterSpacing: '0.05em',
            }}
          >
            © 2026 Newnal. All rights reserved.
          </span>
        </div>
      </footer>
    </>
  );
}
