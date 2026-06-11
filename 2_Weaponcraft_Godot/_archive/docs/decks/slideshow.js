/* 101-deck slideshow — keyboard + click navigation, URL hash deep-links.
 *
 * Acceptance:
 *   1. Exactly one .slide has .is-active at all times.
 *   2. ArrowRight / ArrowDown / Space / PageDown / "n" → next slide.
 *   3. ArrowLeft / ArrowUp / PageUp / "p" → previous slide.
 *   4. Home / End → first / last slide.
 *   5. Esc closes any focus state but does not navigate.
 *   6. Clicking a .slide-dots button jumps to that slide.
 *   7. Clicking .slide-nav__btn--prev/--next advances.
 *   8. URL hash (#3) reflects current slide; opening the page at #3 lands there.
 *   9. Progress bar fills proportionally to (current / total).
 *  10. prefers-reduced-motion: no opacity/transform transitions (handled in CSS).
 */
(() => {
  "use strict";

  function init() {
    const slides   = Array.from(document.querySelectorAll(".slide"));
    const dotsList = document.querySelector(".slide-dots");
    const prevBtn  = document.querySelector(".slide-nav__btn--prev");
    const nextBtn  = document.querySelector(".slide-nav__btn--next");
    const counter  = document.querySelector(".slide-topbar__counter");
    const progress = document.querySelector(".slide-progress");
    if (slides.length === 0) return;

    // Build the dots row (one per slide).
    if (dotsList) {
      dotsList.innerHTML = "";
      slides.forEach((_, i) => {
        const li  = document.createElement("li");
        const btn = document.createElement("button");
        btn.type = "button";
        btn.setAttribute("aria-label", `Go to slide ${i + 1}`);
        btn.addEventListener("click", () => goTo(i));
        li.appendChild(btn);
        dotsList.appendChild(li);
      });
    }
    const dotEls = dotsList ? Array.from(dotsList.children) : [];

    let current = 0;

    function clamp(i) { return Math.max(0, Math.min(slides.length - 1, i)); }

    function paint() {
      slides.forEach((s, i) => s.classList.toggle("is-active", i === current));
      dotEls.forEach((el, i) => el.classList.toggle("is-active", i === current));
      if (counter)  counter.innerHTML = `<strong>${current + 1}</strong> / ${slides.length}`;
      if (progress) progress.style.width = `${((current + 1) / slides.length) * 100}%`;
      if (prevBtn)  prevBtn.disabled = current === 0;
      if (nextBtn)  nextBtn.disabled = current === slides.length - 1;
      if (history.replaceState) history.replaceState(null, "", `#${current + 1}`);
    }

    function goTo(i) {
      const next = clamp(i);
      if (next === current) return;
      current = next;
      paint();
    }

    if (prevBtn) prevBtn.addEventListener("click", () => goTo(current - 1));
    if (nextBtn) nextBtn.addEventListener("click", () => goTo(current + 1));

    document.addEventListener("keydown", e => {
      // Ignore when a form input has focus, so the page is accessible to AT users.
      const tgt = e.target;
      if (tgt && (tgt.tagName === "INPUT" || tgt.tagName === "TEXTAREA" || tgt.isContentEditable)) return;

      switch (e.key) {
        case "ArrowRight":
        case "ArrowDown":
        case "PageDown":
        case " ":
        case "n":
        case "N":
          goTo(current + 1); e.preventDefault(); break;
        case "ArrowLeft":
        case "ArrowUp":
        case "PageUp":
        case "p":
        case "P":
          goTo(current - 1); e.preventDefault(); break;
        case "Home":
          goTo(0); e.preventDefault(); break;
        case "End":
          goTo(slides.length - 1); e.preventDefault(); break;
        default:
          break;
      }
    });

    // Deep-link via hash (#1, #2, ...).
    const hashNum = parseInt(location.hash.replace("#", ""), 10);
    if (Number.isFinite(hashNum) && hashNum >= 1 && hashNum <= slides.length) {
      current = hashNum - 1;
    }

    paint();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
