# Jan Pfänder — personal website & CV

Built with [Quarto](https://quarto.org). The website and the CV are both generated
from the **same data files**, so you enter each paper, talk, or review **once**.

## The one rule

Edit the **data files** (below). Never edit the generated files — they get
overwritten on every build.

| Edit this | Updates |
|-----------|---------|
| Zotero (writes `references.bib`) | publications (website + CV) |
| `talks.yaml` | talks (website + CV) |
| `reviews.yaml` | peer-review list + count (CV) |
| `links.yaml` | per-paper links on the website (preprint / code / poster …) |
| `cv/cv.yaml` | everything else on the CV (positions, education, teaching, skills …) |

## How to add things

**A paper** → everything starts in Zotero. `references.bib` is written by the
Better BibTeX auto-export, so never edit it by hand.

1. Add the paper to Zotero, in the collection that auto-exports. The export
   fires on its own and rewrites `references.bib`.
2. Pin the citation key: right-click the item → Better BibTeX → Pin BibTeX key.
   A pinned key never changes, and `links.yaml` matches papers by that key.
3. If it's a big group paper where you're a minor author, add the Zotero tag
   `collaboration`.
4. Optional website links: add an entry in `links.yaml` under the paper's
   citation key (fields: `preprint`, `published`, `pdf`, `code`, `poster`,
   `slides`, or `note` for a status like "submitted"). Local PDFs go in
   `research/pdfs/`, named `YEAR_short_title.pdf` for the published version and
   `YEAR_short_title_preprint.pdf` for a preprint copy. Paths in `links.yaml`
   are relative to `research/` (e.g. `pdfs/2026_precise_consensual.pdf`).
5. Run `make`, check the result, then commit and push.

Grouping on the website and CV is automatic: an entry with a journal counts as
peer-reviewed, proceedings count as conference papers, and an entry with no
venue counts as a working paper.

**When a preprint gets published** → edit the *same* Zotero item: change the
type to Journal Article and fill in the journal and DOI. Creating a second item
makes the paper appear twice (once as a working paper, once as published). Then
update the paper's entry in `links.yaml` (add the `published` link, drop the
`note`) and run `make`.

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
references.bib       ← publications, written by the Zotero auto-export (hands off)
talks.yaml, reviews.yaml, links.yaml   ← your data (edit these)
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
