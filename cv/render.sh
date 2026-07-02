#!/usr/bin/env bash
# Build the CV: regenerate data-driven sections (../_build.py), render to PDF,
# and place it where cv/index.qmd embeds it (cv/cv.pdf).
set -euo pipefail
cd "$(dirname "$0")"

# Pick a Python: the active conda env's if there is one (avoids macOS/Xcode's
# old system python3), else whatever python3 is on PATH. Override with PYTHON=…
if [ -z "${PYTHON:-}" ]; then
  if [ -n "${CONDA_PREFIX:-}" ] && [ -x "$CONDA_PREFIX/bin/python3" ]; then
    PYTHON="$CONDA_PREFIX/bin/python3"
  else
    PYTHON="python3"
  fi
fi
# Use the rendercv installed next to that Python, if present.
RENDERCV="$(dirname "$PYTHON")/rendercv"
[ -x "$RENDERCV" ] || RENDERCV="rendercv"

"$PYTHON" ../_build.py
"$RENDERCV" render cv.yaml -o _rendercv_output --pdf-path cv.pdf -nopng -nohtml -nomd

echo "Done: cv/cv.pdf"
