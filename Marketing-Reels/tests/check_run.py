#!/usr/bin/env python3
"""Contract checker for a marketing-reels RUN folder.

Usage:  python check_run.py <run-folder>
Exit code = number of failed checks (0 = contract met).

Validates the output contract from discussions/2026-06-14-3phase-design.md.
Stdlib only. RED before the first full run (folder absent); GREEN after.
"""
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: python check_run.py <run-folder>")
        return 1
    run = Path(sys.argv[1])
    checks = []  # (label, passed, detail)

    def check(label, passed, detail=""):
        checks.append((label, bool(passed), detail))

    exists = run.is_dir()
    check("run folder exists", exists, str(run))
    if not exists:
        _report(checks)
        return sum(1 for _, p, _ in checks if not p)

    def has(rel):
        return (run / rel).is_file()

    check("brief.md", has("brief.md"))
    check("positioning.md", has("positioning.md"))
    check("beat-sheet.md", has("beat-sheet.md"))
    check("validation-scorecard.md (the gate result)", has("validation-scorecard.md"))
    check("manifest.md", has("manifest.md"))

    hooks = list((run / "hooks").glob("hook-*.md")) if (run / "hooks").is_dir() else []
    check("hooks/ has >=3 variants", len(hooks) >= 3, f"{len(hooks)} found")

    sb = list((run / "storyboard").glob("*.md")) if (run / "storyboard").is_dir() else []
    check("storyboard/ has >=1", len(sb) >= 1, f"{len(sb)} found")

    mp4s = list((run / "video").glob("*.mp4")) if (run / "video").is_dir() else []
    check("video/ has a real .mp4", len(mp4s) >= 1, f"{len(mp4s)} found")

    # sound-off captions present in the beat sheet
    if has("beat-sheet.md"):
        bs = (run / "beat-sheet.md").read_text(encoding="utf-8", errors="ignore").lower()
        check("beat-sheet declares sound-off captions", "caption" in bs)
    else:
        check("beat-sheet declares sound-off captions", False, "no beat-sheet.md")

    # manifest records cost + a named winner
    if has("manifest.md"):
        mf = (run / "manifest.md").read_text(encoding="utf-8", errors="ignore").lower()
        check("manifest records cost", "cost" in mf or "$" in mf)
        check("manifest names the winning variant", "winner" in mf or "won" in mf)
    else:
        check("manifest records cost", False, "no manifest.md")
        check("manifest names the winning variant", False, "no manifest.md")

    _report(checks)
    return sum(1 for _, p, _ in checks if not p)


def _report(checks):
    print("\nmarketing-reels run contract:")
    for label, passed, detail in checks:
        mark = "PASS" if passed else "FAIL"
        line = f"  [{mark}] {label}"
        if detail:
            line += f"  ({detail})"
        print(line)
    fails = sum(1 for _, p, _ in checks if not p)
    print(f"\n{'OK — contract met' if fails == 0 else str(fails) + ' check(s) failed'}\n")


if __name__ == "__main__":
    sys.exit(main())
