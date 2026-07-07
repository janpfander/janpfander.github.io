# Website context (`CLAUDE.md`)

> Working notes for Claude Code — auto-loaded every session. Excluded from the Quarto render via `_quarto.yml` `project.render: ["!CLAUDE.md"]` (a negation-only list renders everything else by default), so it is not published as a page.

## What this is

Personal academic website for **Jan Pfänder** (postdoc, Eawag; trust in science & misinformation).
Built with **Quarto** (`project: type: website`), rendered R/knitr where needed.
Deployed via GitHub Pages from the **`docs/`** output dir (`.nojekyll` present). Branch: `main`.

- Render locally with `quarto render` (or `quarto preview`). Output goes to `docs/`.
- `freeze: auto` globally; some pages set `freeze: false` (cv) or `freeze: true` (blog).

## Layout

| Path | Role |
|------|------|
| `_quarto.yml` | Site config: navbar, footer, theme (`cosmo`), css. |
| `_variables.yml` | Shortcode vars: `orcid`, `github-url`, `years`. Used via `{{< var ... >}}`. |
| `index.qmd` | Homepage. Hardcoded bio (profile pic + intro prose). |
| `styles.css` / `alternative_font.css` | Styling. `alternative_font.css` is **untracked** and not wired into `_quarto.yml` (only `styles.css` is). |
| `references.bib`, `talks.yaml`, `reviews.yaml`, `links.yaml` | **Canonical data (repo root) = the single source.** Edit these, never the generated output. |
| `Makefile` | Build commands: `make` (all), `make cv`, `make site`, `make preview`, `make clean`. |
| `_build.py` | Generator. Reads the data files → writes CV sections + website partials (via `write_if_changed`, so unchanged files aren't touched). `_`-prefixed so Quarto won't render it as a page. Run by `cv/render.sh` and `make site`. |
| `research/index.qmd` | Thin shell: `{{< include _publications.md >}}` + `_talks.md`; `bibliography: ../references.bib`, `apa-cv.csl`, `suppress-bibliography`. |
| `research/_publications.md`, `research/_talks.md` | **GENERATED** by `_build.py`. Do not hand-edit. |
| `research/pdfs/`, `research/talks/` | Local PDFs linked from research page (paths in `links.yaml`/`talks.yaml` are relative to `research/`). |
| `cv/index.qmd` | Embeds `cv.pdf` in an iframe + download button. |
| `cv/cv.yaml` | RenderCV input; `publications`/`presentations`/`Peer Reviewing` are GENERATED, rest hand-maintained. |
| `cv/cv.pdf` | CV output — built by `cv/render.sh` (RenderCV), embedded by `cv/index.qmd`. (Old `cv/cv.tex` deleted 2026-07.) |
| `README.md` | Plain-language user guide: how to add papers/talks/reviews + build commands. |
| `blog.qmd` + `blog/` | Blog listing + posts (one folder per post, `index.qmd` each). |
| `teaching/index.qmd` + `teaching/` | Teaching listing (grid of subfolder items). |
| `images/` | `profile.jpeg` (note: `_quarto.yml` references `images/profile.jpg` for social card — extension mismatch, jpeg vs jpg). |
| `docs/` | Rendered output (committed, served by Pages). Don't hand-edit. |

## Single-source content pipeline (DONE — the core goal)

Scholarly content lives in **one place each**, and `_build.py` fans it out to both the CV and the website:

| Edit this | Feeds (via `_build.py`) |
|-----------|-------------------------|
| `references.bib` (Zotero-fed later) | CV `publications` + `research/_publications.md` |
| `talks.yaml` | CV `presentations` + `research/_talks.md` |
| `reviews.yaml` | CV "Peer Reviewing" entry (auto `(n=…)`) |
| `links.yaml` (per-citekey website links) | research page per-paper links |

**Build via `make`** (`Makefile` at root):
- `make` (=`all`) → `cv` + `site`.
- `make cv` → builds `cv/cv.pdf`; it's a real file target depending on the data files + `cv/cv.yaml` + `_build.py`, so **it skips when nothing changed**. Recipe is `./cv/render.sh` (`_build.py` + RenderCV). Incrementality is clean because (a) `cv.pdf` is written last so it stays newest, and (b) `_build.py` uses `write_if_changed` — it only rewrites `cv.yaml`/partials when content actually differs (no spurious mtime bumps, no git noise).
- `make site` → `$(PYTHON) _build.py` then `quarto render`. `make preview` → same + `quarto preview`. `make clean` → removes `docs/` + `cv/_rendercv_output`.
- **Python:** Makefile + `cv/render.sh` use the active conda env's Python (`$CONDA_PREFIX/bin/python3`), not a bare `python3`. Reason: in IDE terminals (Positron/VS Code) `CONDA_PREFIX` is pre-set so conda doesn't re-prepend its bin, and a bare `python3` resolves to macOS's old Apple/Xcode Python (3.9, read-only) → build fails. Deps (`rendercv[full]`, `bibtexparser`, `ruamel.yaml`) must live in conda base. `_build.py` prints a friendly install hint if a package is missing.
- **No Quarto `pre-render` hook** — an earlier attempt (`pre-render: ./build.sh`) coupled the generator into `quarto render`, so a generator failure aborted the whole render and produced no `docs/`. Removed. (`build.sh` also removed, superseded by the Makefile.)

Publication **grouping is derived** (see below): a working paper moves to "peer-reviewed" automatically once it has a journal+DOI. Only manual signal is the `collaboration` keyword. Talk grouping is `type: invited|conference` in `talks.yaml`.

**User workflow:** add a paper → `references.bib` (+ optional `links.yaml` entry for code/poster); add a talk → `talks.yaml`; add a review → `reviews.yaml`. Then `make`.

## RenderCV pipeline (built 2026-07, modelled on masonyoungblood/website)

The CV uses **RenderCV** (YAML → Typst → PDF), matching Mason Youngblood's layout in **purple `rgb(126, 86, 194)`** + JetBrains Mono. Content generation is done by root `_build.py` (see single-source section above), which **derives** publication grouping (no hand-typed headers, so it survives a Zotero auto-export):
  - `keywords` has "collaboration" → *Large collaborations (minor role)*
  - `@inproceedings`/proceedings venue → *Conference proceedings*
  - has a journal → *Peer-reviewed publications*
  - no venue → *Working papers* (so a working paper self-promotes once it gets a journal+DOI)

Authors → initials (own name bolded, particles like "de" handled, >10 authors compressed to `A, B, C, ..., Pfänder, ... et al.`). `_build.py` overwrites `cv.sections.publications`, `presentations` (from `talks.yaml`), and the `professional_service` → "Peer Reviewing" entry (from `reviews.yaml`).

Files:
- `references.bib` (repo root) — **Zotero-shaped** bibliography; only manual signal is `keywords = {collaboration}` on minor-role papers.
- `cv/cv.yaml` — RenderCV input. Structure mirrors Mason's closely: **no `headline`** (avoids duplicating the current position, which lives only in the Positions section); section keys are lowercase-with-underscores (RenderCV Title-Cases them: `work_experience` → "Work Experience"); **subheaders are entries with only a `name`** (e.g. Presentations → "Invited talks"/"Conference presentations"; Teaching → "Courses"/"Workshops"; Advising → "Graduate students"/"Undergraduate students"). Presentation talks keep a right-aligned year (title+venue in `name`+`summary`, year in `date`). Design block copied from Mason, recolored navy, `single_date: YEAR`.
- `reviews.yaml` (repo root) — single source for the "Peer Reviewing" entry (list of `venue`/`count`). `_build.py` computes the total `(n = …)` and the per-journal string, automated like the publication `(n = …)` counts.

**Line break after institution:** `design.templates.experience_entry.main_column` is overridden to `**COMPANY**\n\nPOSITION\n\nSUMMARY\n\nHIGHLIGHTS` (paragraph breaks). The RenderCV default joins with a single `\n`, which collapses to a space and puts the role inline after the company — this template puts the institution on its own line with the role beneath (role stays in the semantic `position` field, no summary hack).

**Date convention:** `design.templates.single_date: YEAR`, so every normal date renders as just the year (education, publications, presentations, summer schools — robust for any hand-typed year). **Positions & Work Experience use an explicit `date:` string with month abbreviations** instead of `start_date`/`end_date`, e.g. `date: "Jan 2025 – present"` or a research visit `date: "Mar 2027 – Jun 2027"`. The string renders verbatim — that's the intended way to add month-level entries. No `show_time_spans_in` (no "1 year 2 months"). The **top note** uses `templates.top_note: '*LAST_UPDATED MONTH_NAME YEAR*'` — the `MONTH_NAME`/`YEAR` placeholders are independent of `single_date`, so "Last updated in July 2026" shows the month while publications stay year-only.
- `cv/render.sh` — `_build.py` → `rendercv render cv.yaml --pdf-path cv.pdf` → output at `cv/cv.pdf`, which `cv/index.qmd` embeds. **Run this to rebuild the CV.**
- `cv/fonts/` — **JetBrains Mono TTFs (Regular/Bold/Italic/BoldItalic). REQUIRED** — RenderCV/Typst auto-loads a `fonts/` folder next to the YAML. Without it, Typst silently falls back to a serif default and the CV looks nothing like Mason's. Do not delete.
- `cv/_rendercv_output/` — gitignored build artifacts (typst/pdf); `_`-prefixed so Quarto doesn't render them as pages.
- No photo: Mason's CV has none; matched.

**Tooling:** `rendercv` installed via `pip install "rendercv[full]"` (bundles Typst). Python deps: `bibtexparser`, `ruamel.yaml`. Renders in ~1.5s, currently 3 pages.

**Zotero (LIVE since 2026-07-07):** `references.bib` is now written by a Better BibTeX auto-export ("Keep updated") from Jan's Zotero — **never hand-edit it**. Export format is **Better BibTeX** (classic `journal`/`year` fields; Better BibLaTeX would break `_build.py`). Workflow: drag PDF into Zotero (item must be in the exported collection) → tag `collaboration` only if minor-role → export fires → `make`. When a preprint is published: edit the same item (type → Journal Article, add journal+DOI), don't create a second item. Theses (`@phdthesis` etc.) are skipped by `_build.py` (belong in CV Education, not publications). Citekey hygiene: keys must be **pinned** in Zotero (right-click → Better BibTeX → Pin BibTeX key; ideally the "automatically pin after N seconds" preference) — the 2026-07 first export reshuffled two a/b suffixes because keys weren't pinned, breaking `links.yaml` matching. Export still includes `abstract`/`file` fields (BBT "Fields to omit" not configured; user OK with that). Talks may later move to Zotero "Presentation" items; for now `talks.yaml`.

## Brand color (website ↔ CV)

Mason's purple **`#7e56c2`** (= `rgb(126, 86, 194)`) is the brand accent everywhere; the **top navbar is neutral grey `#e9ecef`** (the earlier navy `#1e3a5f` was dropped for being too dark).
- `theme.scss` — Quarto/Bootstrap theme: `$primary`/`$link-color` = purple; `$navbar-bg` = grey `#e9ecef` with dark `$navbar-fg` and purple hover/active; footer links purple. Wired via `_quarto.yml` `theme: [cosmo, theme.scss]`.
- Title-block-banners are explicit purple `#7e56c2` with white text on all pages: `blog.qmd`, `teaching/index.qmd`, `teaching/_metadata.yml`, `blog/_metadata.yml` (posts). NB: `title-block-banner: true` renders **grey** (follows navbar), so banners are set to the explicit hex to stay purple.
- CV (`cv/cv.yaml` `design.colors`: name/headline/section_titles/links/footer/top_note) = `rgb(126, 86, 194)`.
To rebrand, change `#7e56c2` / `rgb(126,86,194)` in `theme.scss`, the four banner files, and the CV `design.colors`. Website body font is **JetBrains Mono** (Google Fonts in `styles.css`), matching the CV. Footer year comes from `_variables.yml` `years`.

## Gotchas / cleanup noticed
- `references.bib` contains duplicate/older versions of several entries (2024 vs 2025 preprint versions). Prune before treating it as source of truth.
- Citekey drift between `.bib` and what `research/index.qmd` cites — verify each `@key` on the research page resolves.
- Social-card image path `images/profile.jpg` vs actual `images/profile.jpeg`.
- `alternative_font.css` untracked and unreferenced — decide keep/wire-in/delete.
- `cv.pdf`/`cv.tex` have `-rw-------` perms (owner-only); harmless but unusual.
