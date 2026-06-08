/* WeaponForge teammate deck — scrub.js
   Bran 5-tier portrait scrubber + IntersectionObserver for engraved dividers.

   Acceptance (manual check at end of D-3):
     1. Slider value 0..4 maps to portrait frame 0..4 (★1..★5).
     2. Caption changes per tier: Basic / Awakened / Ascended / Eternal / Apotheosis.
     3. Arrow keys nudge the slider one tier left/right when focused.
     4. object-position transitions 200ms ease (visible morph).
     5. prefers-reduced-motion: transitions become instant.

   The source asset (assets/bran_5tier.png) is a 1344×768 horizontal strip
   of 5 portraits laid out side-by-side. The CSS renders it inside a square
   rondel with `object-fit: none` (no scaling), so the rondel acts as a
   180×180 window onto the natural-size source and `object-position`
   horizontally pans which frame is visible.

   With `object-fit: none`, `object-position: P%` aligns the P% point of the
   source image with the P% point of the container. To center frame i in the
   container we compute:

       frame_center_px = (i + 0.5) * (naturalWidth / N)
       P% = (frame_center_px - clientWidth / 2) / (naturalWidth - clientWidth) * 100

   For 1344-wide source, 180-wide rondel, N=5 frames, this yields roughly
   [3.81, 26.91, 50, 73.09, 96.19]. We compute it at runtime so the math
   stays correct if the source asset or rondel size changes later.

   Vertical positioning: the source has portrait art in roughly the upper
   80% and a label band in the lower 20%. We bias vertically to ~35% so the
   face + chest sits center-ish in the rondel.
*/
(() => {
  "use strict";

  const TIER_NAMES = ["Basic", "Awakened", "Ascended", "Eternal", "Apotheosis"];
  const N_FRAMES = 5;
  const VERTICAL_POS = "35%";

  /** Compute the horizontal object-position percentage that centers frame i. */
  function framePercent(i, naturalWidth, clientWidth) {
    if (naturalWidth <= 0 || clientWidth <= 0 || naturalWidth <= clientWidth) {
      // Fallback to evenly-spaced percentages if dimensions aren't ready.
      return [0, 25, 50, 75, 100][i];
    }
    const frameWidth = naturalWidth / N_FRAMES;
    const frameCenterPx = (i + 0.5) * frameWidth;
    return (frameCenterPx - clientWidth / 2) / (naturalWidth - clientWidth) * 100;
  }

  function initScrubber() {
    const slider = document.getElementById("bran-tier");
    const img    = document.getElementById("bran-scrub");
    const label  = document.getElementById("bran-tier-label");
    if (!slider || !img || !label) return;

    function paint(idx) {
      const i = Math.max(0, Math.min(N_FRAMES - 1, idx | 0));
      const px = framePercent(i, img.naturalWidth, img.clientWidth);
      img.style.objectPosition = `${px}% ${VERTICAL_POS}`;
      label.textContent = `Tier ${i + 1} · ${TIER_NAMES[i]}`;
      img.setAttribute("alt", `Bran portrait at tier ${i + 1} (${TIER_NAMES[i]})`);
    }

    slider.addEventListener("input", e => paint(Number(e.target.value)));

    // Initial paint: if the image is already loaded (cached), paint now;
    // otherwise wait for load so naturalWidth is non-zero before computing.
    if (img.complete && img.naturalWidth > 0) {
      paint(Number(slider.value));
    } else {
      img.addEventListener("load", () => paint(Number(slider.value)), { once: true });
      // Best-effort initial paint with the fallback percentages so the
      // caption updates even if the image is slow.
      paint(Number(slider.value));
    }

    // Recompute on resize — clientWidth may change if CSS rondel size scales.
    window.addEventListener("resize", () => paint(Number(slider.value)));
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
