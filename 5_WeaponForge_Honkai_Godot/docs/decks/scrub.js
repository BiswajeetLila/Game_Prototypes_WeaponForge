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
    document.addEventListener("DOMContentLoaded", () => { initScrubber(); initDividerDrawIn(); });
  } else {
    initScrubber(); initDividerDrawIn();
  }
})();
