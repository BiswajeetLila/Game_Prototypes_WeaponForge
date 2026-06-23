# tests/

**[`check_run.py`](check_run.py)** — contract checker for a marketing-reels RUN folder. Stdlib Python 3.

```
python check_run.py <game-folder>/_art-build/marketing-reels/<YYYY-MM-DD>
```
Exit code = number of failed checks (0 = contract met).

## Asserts
1. run folder exists
2. `brief.md`, `positioning.md`, `beat-sheet.md`, `validation-scorecard.md`, `manifest.md` present
3. `hooks/` has ≥3 `hook-*.md`
4. `storyboard/` has ≥1
5. `video/` has a real `.mp4`
6. `beat-sheet.md` declares sound-off captions
7. `manifest.md` records cost + names the winning variant

## TDD status
- **RED** before the first run (folder absent → fails for the right reason).
- **GREEN** after the one full run on the test fixture.
- When the workflow grows pure, deterministic logic worth unit-testing in isolation, add focused tests beside this checker.
