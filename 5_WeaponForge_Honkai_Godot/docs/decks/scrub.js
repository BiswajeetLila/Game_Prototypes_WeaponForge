/* WeaponForge teammate deck — scrub.js
   Bran 5-tier portrait scrubber + IntersectionObserver for engraved dividers.

   Acceptance (manual check after each change):
     1. Slider value 0..4 maps to portrait frame 0..4 (★1..★5).
     2. Caption changes per tier: Basic / Awakened / Ascended / Eternal / Apotheosis.
     3. Arrow keys nudge the slider one tier left/right when focused.
     4. background-position transitions 200ms ease (visible morph).
     5. prefers-reduced-motion: transitions become instant.

   Implementation:

   The Bran card's rondel is a rectangular <div id="bran-scrub"> with the source
   image set as a background. `background-size: 500% auto` makes the image render
   5× the container's width, and `background-position: P% 0%` snaps the visible
   window to one of the 5 frames at clean 0 / 25 / 50 / 75 / 100% intervals
   (no per-asset math required — CSS does it for us).
*/
(() => {
  "use strict";

  const TIER_NAMES = ["Basic", "Awakened", "Ascended", "Eternal", "Apotheosis"];
  const N_FRAMES = 5;
  const FRAME_POS = [0, 25, 50, 75, 100];  // background-position-x % per tier

  function initScrubber() {
    const slider = document.getElementById("bran-tier");
    const el     = document.getElementById("bran-scrub");
    const label  = document.getElementById("bran-tier-label");
    if (!slider || !el || !label) return;

    function paint(idx) {
      const i = Math.max(0, Math.min(N_FRAMES - 1, idx | 0));
      el.style.backgroundPosition = `${FRAME_POS[i]}% 0%`;
      label.textContent = `Tier ${i + 1} · ${TIER_NAMES[i]}`;
      el.setAttribute("aria-label", `Bran portrait at tier ${i + 1}, ${TIER_NAMES[i]}`);
    }

    slider.addEventListener("input", e => paint(Number(e.target.value)));
    paint(Number(slider.value));
  }

  /* Beats carousel — 6 mockups from the 2E prototype pass. Clicking a
     thumbnail (or the prev/next arrows) swaps the featured beat with a
     200 ms cross-fade. Per-beat title/sub/desc strings live in the array
     below so adding/removing a beat is a single-place edit. */
  const BEATS = [
    {
      img: "decks/assets/beats/beat1-combat-read-2E.jpg",
      alt: "Beat 1 mockup — combat read",
      title: "Combat read",
      sub: "Stage 1, mid-wave · 3 heroes vs minions",
      desc: "Side-view auto-resolve. Heroes attack on their own timers. A kill meter fills with each kill; full meter pauses combat for the Forge Draft. Single-tap ultimates fire when each hero's gauge fills."
    },
    {
      img: "decks/assets/beats/beat2-forge-draft-2E.png",
      alt: "Beat 2 mockup — Forge Draft modal",
      title: "Forge Draft",
      sub: "Mid-wave · 3-card pick (5 on the boss wave)",
      desc: "Combat pauses. 3 run-buff cards — stat / ability / element / hero — appear; the player picks one. The pick flies to the hero's pip row (●○○ → ●●○ → ●●●). The W5 boss wave shows 5 cards instead of 3."
    },
    {
      img: "decks/assets/beats/beat3-boss-defeat-2E.png",
      alt: "Beat 3 mockup — boss wave 5",
      title: "Boss defeat",
      sub: "Wave 5 · Slime King → Iron Golem → Arcane Lich",
      desc: "Bosses rotate by stage. Slime King heals at HP>50%; Iron Golem windups + AoE-slams; Arcane Lich phase-shifts at HP<33%. Stage clear awards +Ember, advances the stage, restores heroes to full HP."
    },
    {
      img: "decks/assets/beats/beat4-forge-wheel-pull-2E.jpg",
      alt: "Beat 4 mockup — Forge Wheel pull",
      title: "Forge Wheel pull",
      sub: "Home meta · 5 Ember per pull",
      desc: "Anvil-strike reel reveals a weapon. Pull #1 = guaranteed Fire-Bran-class. Pull #3 = guaranteed Ice-Elara-class (first Catalyst reveal). Pull #2 + #4+ are RNG, class-matched. Dupes convert to gems (C 20 / R 40 / E 80 / L 160)."
    },
    {
      img: "decks/assets/beats/beat4b-forge-phase1-part-pull-2E.jpg",
      alt: "Beat 4b mockup — Phase-1 part-pull",
      title: "Phase-1 part-pull",
      sub: "Stage 10+ · Master Smith unlocks the second wheel",
      desc: "Targeted part-pulls (head / hilt / rune) for 150 gems each. 5-tier Forge Math applies on equip — same-tier +50%, +1 instant, +2 ½×2, +3 ⅓×3, +4 banked. Earth runes drop from here; Earth-pair Catalysts unlock."
    },
    {
      img: "decks/assets/beats/beat5-hot-paladin-cinematic-2E.png",
      alt: "Beat 5 mockup — Hot Paladin cinematic",
      title: "Hot Paladin descent",
      sub: "Stage 2 cinematic · the FM-8 hero-bond probe (option A)",
      desc: "Mid-stage scripted defeat. A lance crashes to centre stage; the Hot Paladin descends, ult-overrides the wave, joins the roster. A 4-hero squad slot opens for the retry and every stage after."
    },
    {
      img: "decks/assets/beats/beat6-elara-signature-mission.png",
      alt: "Beat 6 mockup — Elara signature mission",
      title: "Elara signature mission",
      sub: "Mid-game · the FM-8 hero-bond probe (option B)",
      desc: "Triggered when Elara crit-kills a boss while in the squad. A 'Spark of Power' cinematic plays; the spark-chain combat mechanic unlocks (crits chain to N targets); the small-B Meteor talent tree opens (gem-spend per node, Meteor → Meteor Shower → Meteor Storm). Probes player attachment and build-investment in a single arc."
    }
  ];

  function initBeatsCarousel() {
    const featuredImg   = document.getElementById("beats-featured-img");
    const featuredTitle = document.getElementById("beats-featured-title");
    const featuredSub   = document.getElementById("beats-featured-sub");
    const featuredDesc  = document.getElementById("beats-featured-desc");
    const thumbs        = Array.from(document.querySelectorAll(".beats-thumb"));
    const prev          = document.querySelector(".beats-arrow--prev");
    const next          = document.querySelector(".beats-arrow--next");
    if (!featuredImg || thumbs.length === 0) return;

    let idx = 0;
    const reducedMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const FADE_MS = reducedMotion ? 0 : 200;

    function paint(i) {
      idx = ((i % BEATS.length) + BEATS.length) % BEATS.length;
      const b = BEATS[idx];
      const swap = () => {
        featuredImg.src = b.img;
        featuredImg.alt = b.alt;
        featuredTitle.textContent = b.title;
        featuredSub.textContent = b.sub;
        featuredDesc.textContent = b.desc;
        if (FADE_MS > 0) {
          requestAnimationFrame(() => { featuredImg.style.opacity = "1"; });
        }
      };
      if (FADE_MS > 0) {
        featuredImg.style.opacity = "0";
        setTimeout(swap, FADE_MS);
      } else {
        swap();
      }
      thumbs.forEach((t, j) => {
        const active = j === idx;
        t.classList.toggle("is-active", active);
        t.setAttribute("aria-selected", active ? "true" : "false");
      });
    }

    thumbs.forEach((t, j) => {
      t.addEventListener("click", () => paint(j));
      t.addEventListener("keydown", e => {
        if (e.key === "ArrowRight") { paint(idx + 1); thumbs[idx].focus(); e.preventDefault(); }
        if (e.key === "ArrowLeft")  { paint(idx - 1); thumbs[idx].focus(); e.preventDefault(); }
      });
    });
    if (prev) prev.addEventListener("click", () => paint(idx - 1));
    if (next) next.addEventListener("click", () => paint(idx + 1));

    paint(0);
  }

  function initDividerDrawIn() {
    const dividers = document.querySelectorAll(".divider-engraved");
    if (!("IntersectionObserver" in window) || dividers.length === 0) return;
    const obs = new IntersectionObserver(entries => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          entry.target.classList.add("divider-engraved--drawn");
          obs.unobserve(entry.target);
        }
      }
    }, { threshold: 0.4 });
    dividers.forEach(d => obs.observe(d));
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => { initScrubber(); initBeatsCarousel(); initDividerDrawIn(); });
  } else {
    initScrubber(); initBeatsCarousel(); initDividerDrawIn();
  }
})();
