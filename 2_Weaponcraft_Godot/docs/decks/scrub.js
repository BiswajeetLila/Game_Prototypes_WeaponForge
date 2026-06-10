/* WeaponCraft teammate deck — scrub.js
   Bran 5-tier portrait scrubber + Beats carousel + IntersectionObserver dividers.

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
  const FRAME_POS = [0, 25, 50, 75, 100];

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

  /* Beats carousel — 5 D1 mockups from the 2E pass (the originals; 5_ later
     extended this set with 4b/6/7/8 for the WeaponForge fork). Click a thumb
     or use the arrows to swap the featured beat with a 200 ms cross-fade.
     Per-beat title/sub/desc strings live in the array below — single-place edit. */
  const BEATS = [
    {
      img: "decks/assets/beats/beat1-combat-read-2E.jpg",
      alt: "Beat 1 mockup — combat read",
      title: "Combat read",
      sub: "Stage 1, mid-wave · 3 heroes vs minions · SHIPPED",
      desc: "Side-view auto-resolve. Heroes attack on 1.1s ticks. Damage pops with weak/resist prefixes per enemy affinity. Element-colored hits (fire orange, ice cyan). Persistent ult gauge under each hero portrait — tap to fire when full. The 15-wave Stage D substrate is shipped today: 144 tests green."
    },
    {
      img: "decks/assets/beats/beat2-forge-draft-2E.png",
      alt: "Beat 2 mockup — TFT forge + recipe discovery",
      title: "Forge + Codex discovery",
      sub: "Between every wave · TFT-style parts shop · SHIPPED (as 3-socket forge)",
      desc: "Note: this 2E mockup illustrates the future Forge-Draft card layout for the fork. The shipped 2_ build instead opens a TFT-style parts shop between every wave — 5 parts roll, buy with round currency, reroll for 2g, slot onto a 3-socket weapon (head/hilt/rune). Tag-combos trigger the Recipe Codex first-discovery overlay (Steamburst, Inferno, …) — this is the actual core hook."
    },
    {
      img: "decks/assets/beats/beat3-boss-defeat-2E.png",
      alt: "Beat 3 mockup — boss wave",
      title: "Boss defeat + Reforge-&-Retry",
      sub: "Waves 5 / 10 / 15 · Slime King → Iron Golem → Arcane Lich · SHIPPED",
      desc: "Bosses anchor W5, W10, and the W15 stage-end. Each boss telegraphs an affinity row (weak/resist for fire / ice / pierce). On wipe, the ReforgeRetryModal opens — keep all inventory, rearrange parts, swap a rune, try again. The counter-build dopamine loop. (Per-enemy weak/resist applies to minions too, not just bosses — addendum 0.1.5.)"
    },
    {
      img: "decks/assets/beats/beat4-forge-wheel-pull-2E.jpg",
      alt: "Beat 4 mockup — Forge Wheel pull (design-only)",
      title: "Forge Wheel pull",
      sub: "Home meta · slot-machine weapon-gacha · DESIGN-ONLY (fork only)",
      desc: "An anvil-strike reel resolves on a named whole weapon (e.g. \"Stormblaze Katana — Warrior — Fire-imbued\"). This is the v2.2 Wittle-inversion bet — pull weapons instead of heroes. Not in 2_'s playable build. Wired up in the fork (5_WeaponForge_Honkai_Godot) where the legacy 3-socket forge is being replaced by this slot-machine meta."
    },
    {
      img: "decks/assets/beats/beat5-hot-paladin-cinematic-2E.png",
      alt: "Beat 5 mockup — Hot Paladin cinematic (design-only)",
      title: "Hot Paladin descent",
      sub: "Stage 2 cinematic · FM-8 hero-bond probe · DESIGN-ONLY (fork only)",
      desc: "Mid-stage scripted defeat: a lance crashes to centre stage, the Hot Paladin descends, ult-overrides the wave, joins the roster — the squad expands to four. The session-2 hook for the v2.2 Wittle-inversion design. Not in 2_'s playable build. Wired up in the fork."
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
