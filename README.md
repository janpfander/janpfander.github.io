# Jan Pfänder — personal website & CV

Built with [Quarto](https://quarto.org). The website and the CV are both generated
from the **same data files**, so you enter each paper, talk, or review **once**.

## The one rule

Edit the **data files** (below). Never edit the generated files — they get
overwritten on every build.

| Edit this | Updates |
|-----------|---------|
| `references.bib` | publications (website + CV) |
| `talks.yaml` | talks (website + CV) |
| `reviews.yaml` | peer-review list + count (CV) |
| `links.yaml` | per-paper links on the website (preprint / code / poster …) |
| `cv/cv.yaml` | everything else on the CV (positions, education, teaching, skills …) |

## How to add things

**A paper** → add a BibTeX entry to `references.bib`.
Grouping is automatic: no journal = "working paper"; has a journal = "peer-reviewed";
proceedings = "conference". Add `keywords = {collaboration}` for big group papers
where you're a minor author. To show preprint/code/poster links on the website, add
an entry in `links.yaml` under the paper's citation key.

**A talk** → add a block to `talks.yaml` (set `type: invited` or `type: conference`).

**A review** → add a `venue` + `count` line to `reviews.yaml` (the total updates itself).

**Anything else on the CV** (a new job, course, etc.) → edit `cv/cv.yaml` directly.

## How to build

**One command** builds everything — website **and** CV:

```bash
make
```

It regenerates your publications/talks, rebuilds the CV PDF (`cv/cv.pdf`), and
rebuilds the website into `docs/`. Then commit and push — the site is served from
the `docs/` folder.

Other commands:

```bash
make cv        # build only the CV PDF (skipped if nothing changed)
make site      # build only the website
make preview   # live-preview the website in the browser
make clean     # delete build output
```

## Structure

```
references.bib, talks.yaml, reviews.yaml, links.yaml   ← your data (edit these)
Makefile             ← the build commands (make, make cv, make site …)
_build.py            ← generator: turns the data into website + CV content
index.qmd            ← home page
research/index.qmd   ← research page (auto-filled from your data)
cv/cv.yaml           ← CV content (publications/talks auto-filled, rest by hand)
cv/render.sh         ← builds the CV PDF
theme.scss           ← site colours (purple brand)
docs/                ← the built website (don't edit by hand)
```

You normally don't touch `_build.py` — it runs automatically when you build.

## One-time setup

Needs [Quarto](https://quarto.org) and a Python 3.10+ — use your **conda** Python
(macOS's built-in `python3` is old and read-only). Install the tools once, into
conda:

```bash
"$CONDA_PREFIX/bin/python3" -m pip install "rendercv[full]" bibtexparser ruamel.yaml
```

The build always uses your conda Python automatically (via `$CONDA_PREFIX`), so
`make` works even if your terminal's plain `python3` points at the wrong one
(e.g. in an IDE terminal like Positron/VS Code).
