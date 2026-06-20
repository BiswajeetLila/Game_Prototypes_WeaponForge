"""Build afk-journey-deck-preview.html — 2 slides (Cover + Core Loop)."""
import base64
import pathlib

ROOT = pathlib.Path(__file__).parent
COVER_FRAME = ROOT / "videos/v1-f2-9q0wgfOY/frames/f_00060.jpg"
ICON = ROOT / "web-sources/02-appstore-us-listing/images/AppIcon-512x512.jpg"
OUT = ROOT / "afk-journey-deck-preview.html"


def b64(p: pathlib.Path, mime: str = "image/jpeg") -> str:
    return f"data:{mime};base64,{base64.b64encode(p.read_bytes()).decode()}"


cover_data = b64(COVER_FRAME)
icon_data = b64(ICON)

HTML = r"""<!doctype html>
<html lang="en"><head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>AFK Journey — Deck Preview (2 slides)</title>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;600;700;800&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root {
  --bg-deep:        #0B1428;
  --bg-panel:       #16223A;
  --bg-panel-2:     #1F2D4A;
  --primary:        #F4D58D;
  --primary-bright: #FFE9B3;
  --secondary:      #C8A165;
  --tertiary:       #7CB8E0;
  --danger:         #D9381E;
  --ivory:          #E8DCC4;
  --mute:           #8DA0B8;
  --stroke:         #2B3A5C;
}
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; background: var(--bg-deep); color: var(--ivory); font-family: 'Inter', system-ui, sans-serif; overflow: hidden; height: 100vh; }
body::before {
  content: ""; position: fixed; inset: 0; pointer-events: none; z-index: 0;
  background-image:
    radial-gradient(ellipse at 20% 10%, rgba(124,184,224,0.08) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 90%, rgba(244,213,141,0.05) 0%, transparent 50%);
}
.deck { position: relative; width: 100vw; height: 100vh; overflow: hidden; z-index: 1; }
.slide {
  position: absolute; inset: 0; display: none; flex-direction: column;
  padding: 3.2vh 4.5vw 2.5vh; opacity: 0; transform: translateX(30px);
  transition: opacity 400ms ease, transform 400ms ease;
}
.slide.active { display: flex; opacity: 1; transform: translateX(0); }
.slide h1 {
  font-family: 'Cinzel', serif; font-weight: 700; letter-spacing: 0.01em;
  font-size: clamp(2.8rem, 5.5vw, 5rem); margin: 0 0 0.4em;
  background: linear-gradient(135deg, var(--primary-bright) 0%, var(--primary) 50%, var(--secondary) 100%);
  -webkit-background-clip: text; background-clip: text; color: transparent;
  text-shadow: 0 0 60px rgba(244,213,141,0.15);
}
.slide h2 {
  font-family: 'Cinzel', serif; font-weight: 600; color: var(--primary);
  font-size: clamp(1.6rem, 2.6vw, 2.4rem); margin: 0 0 0.3em;
}
.slide h3 { font-family: 'Inter', sans-serif; font-weight: 600; color: var(--primary-bright); font-size: 1.05rem; margin: 0 0 0.4em; }
.slide p, .slide li { font-size: clamp(0.95rem, 1.15vw, 1.1rem); line-height: 1.55; color: var(--ivory); }
.slide .subtitle { font-family: 'Cinzel', serif; font-weight: 500; color: var(--mute); font-size: 1.1rem; letter-spacing: 0.18em; text-transform: uppercase; }
.slide footer { position: absolute; left: 4.5vw; right: 4.5vw; bottom: 1.2vh; display: flex; justify-content: space-between; font-family: 'JetBrains Mono', monospace; font-size: 0.78rem; color: var(--mute); opacity: 0.7; }
.src { font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; padding: 0.15em 0.55em; background: rgba(124,184,224,0.12); border: 1px solid rgba(124,184,224,0.3); border-radius: 3px; color: var(--tertiary); margin-left: 0.4em; vertical-align: middle; white-space: nowrap; }
.src.inf { background: rgba(244,213,141,0.1); border-color: rgba(244,213,141,0.3); color: var(--primary); }
.src.gap { background: rgba(217,56,30,0.12); border-color: rgba(217,56,30,0.3); color: #FFA899; }

/* ===== Cover Slide ===== */
.cover-wrap { display: grid; grid-template-columns: 1.4fr 1fr; gap: 4vw; flex: 1; align-items: center; }
.cover-text { display: flex; flex-direction: column; }
.cover-text .subtitle { margin-bottom: 1.2vh; }
.cover-text h1 { line-height: 0.95; }
.cover-text .tagline { font-size: clamp(1rem, 1.4vw, 1.3rem); color: var(--mute); margin-top: 0.3em; max-width: 36ch; }
.stats-grid {
  display: grid; grid-template-columns: 1fr 1fr; gap: 1.4vh 1.4vw;
  background: var(--bg-panel); border: 1px solid var(--stroke); border-radius: 14px;
  padding: 2.4vh 1.8vw; box-shadow: 0 18px 50px rgba(0,0,0,0.4);
}
.stat { display: flex; flex-direction: column; }
.stat .label { font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--tertiary); text-transform: uppercase; letter-spacing: 0.12em; }
.stat .value { font-family: 'Cinzel', serif; font-weight: 700; color: var(--primary-bright); font-size: clamp(1.4rem, 2vw, 2rem); line-height: 1.1; margin-top: 0.2em; }
.stat .sub { font-size: 0.78rem; color: var(--mute); margin-top: 0.15em; }
.cover-hero { position: relative; display: flex; flex-direction: column; align-items: center; }
.cover-hero img.icon { width: 110px; height: 110px; border-radius: 22px; border: 2px solid var(--stroke); box-shadow: 0 12px 40px rgba(124,184,224,0.4); margin-bottom: -55px; z-index: 2; }
.cover-hero img.shot { width: 100%; max-height: 56vh; object-fit: cover; border-radius: 14px; border: 1px solid var(--stroke); box-shadow: 0 22px 60px rgba(0,0,0,0.55); }

/* ===== Loop Slide ===== */
.loop-wrap { display: grid; grid-template-columns: 1.3fr 1fr; gap: 3vw; flex: 1; align-items: center; min-height: 0; }
.loop-svg { width: 100%; height: auto; max-height: 70vh; }
.loop-notes { display: flex; flex-direction: column; gap: 1.2vh; min-height: 0; overflow: hidden; }
.loop-note { background: var(--bg-panel); border: 1px solid var(--stroke); border-left: 3px solid var(--primary); border-radius: 8px; padding: 0.9vh 1.1vw; }
.loop-note h3 { color: var(--primary-bright); margin-bottom: 0.2em; font-size: 0.95rem; }
.loop-note p { font-size: 0.88rem; color: var(--ivory); margin: 0; }

/* ===== Nav ===== */
.nav-bottom { position: fixed; left: 50%; bottom: 1.2vh; transform: translateX(-50%); display: flex; gap: 8px; z-index: 100; padding: 6px 14px; background: rgba(11,20,40,0.65); border: 1px solid var(--stroke); border-radius: 999px; backdrop-filter: blur(8px); }
.nav-dot { width: 9px; height: 9px; border-radius: 50%; background: var(--stroke); border: none; cursor: pointer; padding: 0; transition: background 200ms; }
.nav-dot.active { background: var(--primary); box-shadow: 0 0 8px rgba(244,213,141,0.7); }
.nav-dot:hover { background: var(--mute); }

.hint { position: fixed; top: 1vh; right: 1vw; font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--mute); opacity: 0.5; z-index: 100; }
</style></head>
<body>
<div class="hint">← → · F (fullscreen)</div>
<div class="deck" id="deck">

  <!-- ===== Slide 1: Cover ===== -->
  <section class="slide active" data-go="0">
    <div class="cover-wrap">
      <div class="cover-text">
        <div class="subtitle">Game Design Research · Lila Internal</div>
        <h1>AFK<br/>Journey</h1>
        <p class="tagline">A casual-strategy auto-battler with an idle-collection backbone, championed by the genre-defining <em>Resonating Hall</em> innovation — level the bench, not the heroes.</p>
        <div style="margin-top: 2vh; display: flex; gap: 0.5em; flex-wrap: wrap;">
          <span class="src">Reviews-lifetime</span>
          <span class="src">SensorTower</span>
          <span class="src">v1-Gacha-Josh</span>
          <span class="src">Fandom</span>
          <span class="src">PlayStore-3161</span>
        </div>
      </div>
      <div class="cover-hero">
        <img class="icon" src="__ICON_B64__" alt="AFK Journey app icon"/>
        <img class="shot" src="__COVER_B64__" alt="AFK Journey victory party"/>
        <div class="stats-grid" style="margin-top: 1.6vh; width: 100%;">
          <div class="stat"><span class="label">Play Store ratings</span><span class="value">296,395</span><span class="sub">4.50 ★ lifetime <span class="src">Reviews-lifetime</span></span></div>
          <div class="stat"><span class="label">iOS ratings (ST)</span><span class="value">274,310</span><span class="sub">4.83 ★ <span class="src">SensorTower</span></span></div>
          <div class="stat"><span class="label">Lifetime revenue</span><span class="value">$158.2M</span><span class="sub">27mo · Mar 2024 → May 2026 <span class="src">SensorTower</span></span></div>
          <div class="stat"><span class="label">Peak MAU</span><span class="value">3.22M</span><span class="sub">Apr 2024 · 844K by May 2026 <span class="src">SensorTower</span></span></div>
          <div class="stat"><span class="label">Scraped pool</span><span class="value">3.37 ★</span><span class="sub">3,161 bodies, complaint-biased <span class="src">PlayStore-3161</span></span></div>
          <div class="stat"><span class="label">Research corpus</span><span class="value">55 + 4 + 3,161</span><span class="sub">web · videos · reviews <span class="src inf">Inferred</span></span></div>
        </div>
      </div>
    </div>
    <footer><span>AFK Journey · Design Research Deck</span><span><span class="pageno">01</span> / 18</span></footer>
  </section>

  <!-- ===== Slide 4: Core Gameplay Loop ===== -->
  <section class="slide" data-go="1">
    <div class="subtitle">Slide 04 · Preview</div>
    <h2>Core Gameplay Loop</h2>
    <div class="loop-wrap">
      <svg class="loop-svg" viewBox="0 0 700 560" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <radialGradient id="g-center" cx="50%" cy="50%">
            <stop offset="0%" stop-color="#F4D58D" stop-opacity="0.95"/>
            <stop offset="100%" stop-color="#C8A165" stop-opacity="0.7"/>
          </radialGradient>
          <linearGradient id="g-stroke" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="#7CB8E0"/>
            <stop offset="100%" stop-color="#F4D58D"/>
          </linearGradient>
          <marker id="arr" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M 0 0 L 10 5 L 0 10 z" fill="#7CB8E0"/>
          </marker>
        </defs>

        <!-- Center anchor -->
        <circle cx="350" cy="280" r="68" fill="url(#g-center)" stroke="#FFE9B3" stroke-width="2"/>
        <text x="350" y="270" text-anchor="middle" font-family="Cinzel" font-size="18" font-weight="700" fill="#0B1428">AFK</text>
        <text x="350" y="295" text-anchor="middle" font-family="Cinzel" font-size="18" font-weight="700" fill="#0B1428">Loop</text>

        <!-- Ring path (5 nodes, pentagon) -->
        <!-- Node positions: top, top-right, bottom-right, bottom-left, top-left -->
        <g font-family="Inter" font-size="13" fill="#E8DCC4">
          <!-- Node 1: Idle collect -->
          <circle cx="350" cy="80" r="42" fill="#1F2D4A" stroke="url(#g-stroke)" stroke-width="2"/>
          <text x="350" y="78" text-anchor="middle" font-weight="600" fill="#FFE9B3">1 · Idle</text>
          <text x="350" y="95" text-anchor="middle" font-size="11">collect</text>

          <!-- Node 2: Pull / Roster -->
          <circle cx="615" cy="225" r="42" fill="#1F2D4A" stroke="url(#g-stroke)" stroke-width="2"/>
          <text x="615" y="223" text-anchor="middle" font-weight="600" fill="#FFE9B3">2 · Pull</text>
          <text x="615" y="240" text-anchor="middle" font-size="11">roster</text>

          <!-- Node 3: Team / Resonate -->
          <circle cx="515" cy="490" r="42" fill="#1F2D4A" stroke="url(#g-stroke)" stroke-width="2"/>
          <text x="515" y="488" text-anchor="middle" font-weight="600" fill="#FFE9B3">3 · Team</text>
          <text x="515" y="505" text-anchor="middle" font-size="11">resonate</text>

          <!-- Node 4: Stage / Mode -->
          <circle cx="185" cy="490" r="42" fill="#1F2D4A" stroke="url(#g-stroke)" stroke-width="2"/>
          <text x="185" y="488" text-anchor="middle" font-weight="600" fill="#FFE9B3">4 · Stage</text>
          <text x="185" y="505" text-anchor="middle" font-size="11">push</text>

          <!-- Node 5: Ascend / Equip -->
          <circle cx="85" cy="225" r="42" fill="#1F2D4A" stroke="url(#g-stroke)" stroke-width="2"/>
          <text x="85" y="223" text-anchor="middle" font-weight="600" fill="#FFE9B3">5 · Ascend</text>
          <text x="85" y="240" text-anchor="middle" font-size="11">equip</text>
        </g>

        <!-- Arrows -->
        <g stroke="#7CB8E0" stroke-width="1.6" fill="none" stroke-dasharray="0" marker-end="url(#arr)" opacity="0.75">
          <path d="M 388 110 Q 510 130 580 195"/>
          <path d="M 600 263 Q 595 410 545 455"/>
          <path d="M 475 502 Q 350 540 225 502"/>
          <path d="M 158 460 Q 90 380 90 263"/>
          <path d="M 120 195 Q 200 120 310 100"/>
        </g>
      </svg>

      <div class="loop-notes">
        <div class="loop-note"><h3>1 · Idle collect (every 1–12h)</h3><p>AFK Stage farms Gold/XP/Diamonds while offline. Two free "Instant" fast-collects (2/2) gate active sessions. <span class="src">v1-Gacha-Josh</span></p></div>
        <div class="loop-note"><h3>2 · Pull on Epic / All-Hero / Rate-up banner</h3><p>300 diamonds/single · 2700/ten · A-tier wishlist softens variance. Soft pity ~60 / hard 80 for S-tier. <span class="src">Bluestacks</span></p></div>
        <div class="loop-note"><h3>3 · Compose team in Resonating Hall</h3><p>Only 5 slot levels needed — Hands of Resonance applies to entire roster of the same class. <span class="src">v2-CarzakTheBull</span></p></div>
        <div class="loop-note"><h3>4 · Push AFK Stage / mode loop</h3><p>Stages, Dream Realm boss, Honor Duel roguelite, Arena, Battle Drills, Tower of Memory. <span class="src">Fandom</span></p></div>
        <div class="loop-note"><h3>5 · Ascend → unlock cap → loop back</h3><p>A-tier 64 copies + 200 acorns to Supreme+. Each Supreme+ adds +5 to Resonance Synergy cap (base 300). <span class="src">Lootbar-Ascension</span></p></div>
      </div>
    </div>
    <footer><span>AFK Journey · Core Loop</span><span><span class="pageno">04</span> / 18</span></footer>
  </section>

</div>

<!-- Nav -->
<nav class="nav-bottom" id="nav">
  <button class="nav-dot active" data-idx="0" aria-label="Slide 1"></button>
  <button class="nav-dot" data-idx="1" aria-label="Slide 2"></button>
</nav>

<script>
(function(){
  const slides = document.querySelectorAll('.slide');
  const dots = document.querySelectorAll('.nav-dot');
  let cur = 0;
  function go(i){
    if (i < 0 || i >= slides.length) return;
    slides[cur].classList.remove('active');
    dots[cur].classList.remove('active');
    cur = i;
    slides[cur].classList.add('active');
    dots[cur].classList.add('active');
  }
  window.go = go;
  document.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight' || e.key === ' ' || e.key === 'PageDown') { e.preventDefault(); go(Math.min(cur+1, slides.length-1)); }
    else if (e.key === 'ArrowLeft' || e.key === 'PageUp') { e.preventDefault(); go(Math.max(cur-1, 0)); }
    else if (e.key.toLowerCase() === 'f') { if (!document.fullscreenElement) document.documentElement.requestFullscreen(); else document.exitFullscreen(); }
  });
  dots.forEach(d => d.addEventListener('click', () => go(parseInt(d.dataset.idx))));
})();
</script>
</body></html>
"""

HTML = HTML.replace("__ICON_B64__", icon_data).replace("__COVER_B64__", cover_data)
OUT.write_text(HTML, encoding="utf-8")
print(f"Wrote {OUT} ({len(HTML)//1024} KB)")
