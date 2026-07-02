#!/usr/bin/env python3
"""
Single build step for the whole site's scholarly content.

Reads the canonical data files at the repo root:
    references.bib   publications (metadata + DOI; Zotero-fed later)
    talks.yaml       every talk
    reviews.yaml     peer-review record
    links.yaml       per-paper website links (preprint / code / poster / ...)

and regenerates BOTH outputs so a single edit propagates everywhere:
    cv/cv.yaml                 -> publications, presentations, "Peer Reviewing"
    research/_publications.md  -> website publications (Quarto @cite + CSL)
    research/_talks.md         -> website talks

Run via `make` (or `make cv` / `make site`); also invoked by cv/render.sh.
Can be run directly: `python3 _build.py`.
"""

import calendar
import re
import sys
from io import StringIO
from pathlib import Path

try:
    import bibtexparser
    from bibtexparser.bparser import BibTexParser
    from bibtexparser.customization import convert_to_unicode
    from ruamel.yaml import YAML
except ModuleNotFoundError as exc:
    sys.exit(
        f"\nMissing Python package: '{exc.name}'.\n"
        "Install the build tools once (in the terminal you run `make` from):\n\n"
        '    python3 -m pip install "rendercv[full]" bibtexparser ruamel.yaml\n'
    )

ROOT = Path(__file__).parent
REFERENCES = ROOT / "references.bib"
TALKS = ROOT / "talks.yaml"
REVIEWS = ROOT / "reviews.yaml"
LINKS = ROOT / "links.yaml"
CV_YAML = ROOT / "cv" / "cv.yaml"
PUBS_PARTIAL = ROOT / "research" / "_publications.md"
TALKS_PARTIAL = ROOT / "research" / "_talks.md"

OWN_LAST_NAME = "Pfänder"
COMPRESS_AUTHORS_ABOVE = 10
NAME_PARTICLES = {"de", "van", "von", "der", "den", "del", "della", "di",
                  "da", "dos", "du", "la", "le", "el", "bin", "al"}

# Publication groups, in CV order.
SECTION_ORDER = [
    ("Peer-reviewed publications", "peer-reviewed"),
    ("Conference proceedings", "conference"),
    ("Large collaborations (minor role)", "collaboration"),
    ("Working papers", "working"),
]

# CV: which section/entry the auto review count lands in.
PROFESSIONAL_SERVICE_KEY = "professional_service"
PEER_REVIEW_ENTRY_NAME = "Peer Reviewing"

# Website link fields, in display order: (field, font-awesome class, label).
LINK_FIELDS = [
    ("preprint", "fas fa-file-pdf", "preprint"),
    ("published", "fas fa-file-pdf", "published version"),
    ("pdf", "fas fa-file-pdf", "pdf"),
    ("code", "fab fa-github", "code & data"),
    ("poster", "fa-solid fa-person-chalkboard", "poster"),
    ("slides", "fa-solid fa-person-chalkboard", "slides"),
]
TALK_LINK_FIELDS = [f for f in LINK_FIELDS if f[0] in ("slides", "poster")]

# Separator between links on the website, e.g. "preprint \| code" (escaped pipe
# so Markdown doesn't read it as a table). Kept as a constant because older
# Pythons forbid a backslash inside an f-string expression.
LINK_SEP = " \\| "

_yaml = YAML()


def load_yaml(path, default=None):
    if not Path(path).exists():
        return default
    with open(path, encoding="utf-8") as f:
        return _yaml.load(f)


def clean_tex(text):
    if not text:
        return ""
    text = text.replace("{", "").replace("}", "").replace("\n", " ")
    return re.sub(r"\s+", " ", text).strip()


def year_as_int(value):
    try:
        return int(str(value).strip()[:4])
    except (TypeError, ValueError):
        return 0


def write_if_changed(path, content):
    """Write only when the content differs, so unchanged files keep their
    timestamp (lets `make` skip work) and git stays quiet."""
    path = Path(path)
    if path.exists() and path.read_text(encoding="utf-8") == content:
        return
    path.write_text(content, encoding="utf-8")


# --------------------------------------------------------------------------- #
# Publications (from references.bib)
# --------------------------------------------------------------------------- #

def classify(entry):
    if "collaboration" in clean_tex(entry.get("keywords", "")).lower():
        return "collaboration"
    entry_type = entry.get("ENTRYTYPE", "").lower()
    venue = clean_tex(entry.get("journal") or entry.get("booktitle") or "")
    if entry_type in ("inproceedings", "proceedings", "conference") or "proceedings" in venue.lower():
        return "conference"
    if venue:
        return "peer-reviewed"
    return "working"


def format_author(raw_name):
    """'Pfänder, Jan' / 'Jan Pfänder' -> 'J. Pfänder' (own name bolded)."""
    raw_name = clean_tex(raw_name.strip())
    if "," in raw_name:
        last, first = (p.strip() for p in raw_name.split(",", 1))
    else:
        parts = raw_name.split()
        if len(parts) < 2:
            return raw_name
        last, first = parts[-1], " ".join(parts[:-1])

    first_tokens = first.split()
    while first_tokens and first_tokens[-1].lower() in NAME_PARTICLES:
        last = f"{first_tokens.pop().lower()} {last}"
    first = " ".join(first_tokens)

    last_tokens = last.split()
    if len(last_tokens) > 1 and last_tokens[0].lower() in NAME_PARTICLES:
        last = " ".join([last_tokens[0].lower(), *last_tokens[1:]])

    initials = []
    for part in first.replace(".", " ").split():
        if "-" in part:
            initials.append("-".join(p[0].upper() + "." for p in part.split("-") if p))
        elif part:
            initials.append(part[0].upper() + ".")
    formatted = f"{' '.join(initials)} {last}".strip()
    return f"**{formatted}**" if last == OWN_LAST_NAME else formatted


def format_authors(entry):
    raw = [a for a in entry.get("author", "").split(" and ") if a.strip()]
    formatted = [format_author(a) for a in raw]
    if len(formatted) > COMPRESS_AUTHORS_ABOVE:
        me = next((a for a in formatted if OWN_LAST_NAME in a), formatted[-1])
        return formatted[:3] + ["...", me, "... et al."]
    return formatted


def load_entries():
    parser = BibTexParser(common_strings=True)
    parser.customization = convert_to_unicode
    with open(REFERENCES, encoding="utf-8") as f:
        database = bibtexparser.load(f, parser=parser)
    seen, entries = set(), []
    for i, entry in enumerate(database.entries):
        key = entry.get("ID", "")
        if key and key in seen:
            continue
        seen.add(key)
        entry["_order"] = i
        entries.append(entry)
    return entries


def grouped_entries(entries):
    groups = {key: [] for _, key in SECTION_ORDER}
    for entry in entries:
        groups[classify(entry)].append(entry)
    for group in groups.values():
        group.sort(key=lambda e: (-year_as_int(e.get("year")), e["_order"]))
    return groups


def build_cv_publications(groups):
    publications = []
    for title, key in SECTION_ORDER:
        group = groups[key]
        if not group:
            continue
        publications.append({"title": title, "authors": [f"(*n* = {len(group)})"]})
        for entry in group:
            doi = entry.get("doi", "").strip()
            if doi and not doi.startswith("http"):
                doi = f"https://doi.org/{doi}"
            venue = clean_tex(entry.get("journal") or entry.get("booktitle") or "")
            pub = {"title": clean_tex(entry.get("title", "")), "authors": format_authors(entry)}
            if venue:
                pub["journal"] = venue
            if year_as_int(entry.get("year")):
                pub["date"] = year_as_int(entry["year"])
            if doi:
                pub["doi"] = doi
            elif entry.get("url"):
                pub["url"] = entry["url"].strip()
            publications.append(pub)
    return publications


# --------------------------------------------------------------------------- #
# Talks (from talks.yaml)
# --------------------------------------------------------------------------- #

def talk_year(talk):
    return year_as_int(talk.get("date"))


def talk_month_name(talk):
    m = re.match(r"\d{4}-(\d{2})", str(talk.get("date", "")))
    return calendar.month_name[int(m.group(1))] if m else ""


def build_cv_presentations(talks):
    order = [("Invited talks", "invited"), ("Conference presentations", "conference")]
    presentations = []
    for title, kind in order:
        group = sorted((t for t in talks if t.get("type") == kind),
                       key=lambda t: str(t.get("date")), reverse=True)
        if not group:
            continue
        presentations.append({"name": title})
        for t in group:
            name = clean_tex(t["title"])
            if t.get("kind"):
                name += f" ({t['kind']})"
            presentations.append({
                "name": name,
                "summary": f"{clean_tex(t['venue'])}, {clean_tex(t['location'])}",
                "date": talk_year(t),
            })
    return presentations


# --------------------------------------------------------------------------- #
# Reviews (from reviews.yaml) -> CV "Peer Reviewing" entry
# --------------------------------------------------------------------------- #

def inject_reviews(data):
    reviews = load_yaml(REVIEWS) or []
    total = sum(int(r.get("count", 0)) for r in reviews)
    venues = ", ".join(f"*{clean_tex(r['venue'])}* ({int(r.get('count', 0))})"
                       for r in reviews if r.get("venue"))
    section = data.get("cv", {}).get("sections", {}).get(PROFESSIONAL_SERVICE_KEY) or []
    for entry in section:
        if isinstance(entry, dict) and entry.get("name") == PEER_REVIEW_ENTRY_NAME:
            entry["summary"] = f"(*n* = {total})"
            entry["highlights"] = [f"Journals: {venues}"]
            return total
    return None


# --------------------------------------------------------------------------- #
# Website partials
# --------------------------------------------------------------------------- #

def render_links(link_data, fields):
    parts = []
    for field, icon, label in fields:
        url = (link_data or {}).get(field)
        if url:
            parts.append(f'[<i class="{icon}"></i> {label}]({url})')
    return parts


def links_suffix(link_data):
    parts = render_links(link_data, LINK_FIELDS)
    note = (link_data or {}).get("note")
    if note:
        parts.append(f"*{note}*")
    return f" ({LINK_SEP.join(parts)})" if parts else ""


def write_website_publications(groups, links):
    out = []
    if groups["working"]:
        out.append("# Working papers\n")
        for e in groups["working"]:
            out.append(f"-   @{e['ID']}{links_suffix(links.get(e['ID']))}")
        out.append("")

    if groups["peer-reviewed"] or groups["collaboration"] or groups["conference"]:
        out.append("# Peer reviewed publications\n")

        by_year = {}
        for e in groups["peer-reviewed"]:
            by_year.setdefault(year_as_int(e.get("year")), []).append(e)
        for year in sorted(by_year, reverse=True):
            out.append(f"## {year}\n")
            for e in by_year[year]:
                out.append(f"-   @{e['ID']}{links_suffix(links.get(e['ID']))}")
            out.append("")

        if groups["collaboration"]:
            out.append("## Large collaborations [minor roles]\n")
            for e in groups["collaboration"]:
                out.append(f"-   @{e['ID']}{links_suffix(links.get(e['ID']))}")
            out.append("")

        if groups["conference"]:
            out.append("## Conference proceedings\n")
            for e in groups["conference"]:
                out.append(f"-   @{e['ID']}{links_suffix(links.get(e['ID']))}")
            out.append("")

    write_if_changed(PUBS_PARTIAL, "\n".join(out).rstrip() + "\n")


def write_website_talks(talks):
    out = ["# Talks\n"]
    for year in sorted({talk_year(t) for t in talks}, reverse=True):
        out.append(f"## {year}\n")
        group = sorted((t for t in talks if talk_year(t) == year),
                       key=lambda t: str(t.get("date")), reverse=True)
        for t in group:
            authors = clean_tex(t.get("authors") or "Pfänder, J.")
            month = talk_month_name(t)
            date = f"{year}, {month}" if month else f"{year}"
            title = clean_tex(t["title"])
            if t.get("kind"):
                title += f" ({t['kind']})"
            parts = render_links(t, TALK_LINK_FIELDS)
            suffix = f" ({LINK_SEP.join(parts)})" if parts else ""
            out.append(
                f"-   {authors} ({date}). *{title}*. "
                f"{clean_tex(t['venue'])}, {clean_tex(t['location'])}.{suffix}"
            )
        out.append("")
    write_if_changed(TALKS_PARTIAL, "\n".join(out).rstrip() + "\n")


# --------------------------------------------------------------------------- #

def main():
    if not REFERENCES.exists():
        sys.exit(f"Error: {REFERENCES} not found")

    entries = load_entries()
    groups = grouped_entries(entries)
    talks = load_yaml(TALKS) or []
    links = load_yaml(LINKS) or {}

    # --- CV ---
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.width = 4096
    with open(CV_YAML, encoding="utf-8") as f:
        data = yaml.load(f)
    data["cv"]["sections"]["publications"] = build_cv_publications(groups)
    data["cv"]["sections"]["presentations"] = build_cv_presentations(talks)
    total_reviews = inject_reviews(data)
    buf = StringIO()
    yaml.dump(data, buf)
    write_if_changed(CV_YAML, buf.getvalue())

    # --- Website ---
    write_website_publications(groups, links)
    write_website_talks(talks)

    n_pubs = sum(len(g) for g in groups.values())
    print(f"Built: {n_pubs} publications, {len(talks)} talks, "
          f"Peer Reviewing (n={total_reviews}) -> cv.yaml + research partials")


if __name__ == "__main__":
    main()
