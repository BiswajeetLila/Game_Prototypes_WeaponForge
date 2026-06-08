/* WeaponForge teammate deck — scrub.js
   Bran 5-tier portrait scrubber + IntersectionObserver for engraved dividers.

   Acceptance (manual check at end of D-3):
     1. Slider value 0..4 maps to portrait frame 0..4 (★1..★5).
     2. Caption changes per tier: Apprentice / Adept / Veteran / Champion / Master.
     3. Arrow keys nudge the slider one tier left/right when focused.
     4. object-position transitions 200ms ease (visible morph).
     5. prefers-reduced-motion: transitions become instant.
*/
(() => {
  "use strict";

  const TIER_NAMES = ["Apprentice", "Adept", "Veteran", "Champion", "Master"];

  function initScrubber() {
    const slider = document.getElementById("bran-tier");
    const img    = document.getElementById("bran-scrub");
    const label  = document.getElementById("bran-tier-label");
    if (!slider || !img || !label) return;
    // The source is 5 frames wide; the rondel masks to 1 frame.
    // Frame N is shown by translating the wide img to the left by N * 20% (since 5 frames -> 100%/5 = 20% per frame relative to img width which is 500% of container).
    // With object-fit: cover and the img being 500% wide, object-position controls horizontal alignment within that 500% strip; 0% = leftmost frame, 100% = rightmost. The 5 frames are at 0%, 25%, 50%, 75%, 100%.
    const FRAME_POS = [0, 25, 50, 75, 100];
    function paint(idx) {
      const i = Math.max(0, Math.min(4, idx | 0));
      img.style.objectPosition = `${FRAME_POS[i]}% center`;
      label.textContent = `Tier ${i + 1} · ${TIER_NAMES[i]}`;
      img.setAttribute("alt", `Bran portrait at tier ${i + 1} (${TIER_NAMES[i]})`);
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
