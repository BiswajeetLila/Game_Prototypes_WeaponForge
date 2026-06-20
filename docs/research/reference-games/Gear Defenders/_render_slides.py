"""Render each slide of gear-defenders-deck.html to a PNG via Playwright."""
import pathlib
from playwright.sync_api import sync_playwright

ROOT = pathlib.Path(r"C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\docs\research\reference-games\Gear Defenders")
DECK = ROOT / "gear-defenders-deck.html"
OUT  = ROOT / "_slides_png"
OUT.mkdir(exist_ok=True)

# Clear stale PNGs first
for old in OUT.glob("slide-*.png"):
    old.unlink()

NUM_SLIDES = 18
VIEWPORT = {"width": 1920, "height": 1080}

with sync_playwright() as p:
    browser = p.chromium.launch()
    ctx = browser.new_context(viewport=VIEWPORT, device_scale_factor=1)
    page = ctx.new_page()
    page.goto(f"file:///{DECK.as_posix()}", wait_until="networkidle")
    page.wait_for_timeout(2000)
    for i in range(NUM_SLIDES):
        page.evaluate(f"go({i})")
        page.wait_for_timeout(700)
        out = OUT / f"slide-{i+1:02d}.png"
        page.screenshot(path=str(out), clip={"x":0, "y":0, "width":1920, "height":1080})
        print(f"  saved {out.name} ({out.stat().st_size // 1024} KB)")
    browser.close()

print(f"\nDone. {NUM_SLIDES} slides rendered to {OUT}")
