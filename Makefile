# Update the website + CV from the data files
# (references.bib, talks.yaml, reviews.yaml, links.yaml, cv/cv.yaml).
#
#   make          build everything (CV + website)   [default]
#   make cv       build only the CV PDF (skipped if nothing changed)
#   make site     build only the website (docs/)
#   make preview  live-preview the website in the browser
#   make clean    remove build output

# Use the active conda env's Python (avoids macOS's old system python3).
# Override if needed: make PYTHON=/path/to/python
PYTHON := $(if $(CONDA_PREFIX),$(CONDA_PREFIX)/bin/python3,python3)

.PHONY: all cv site preview clean

all: cv site

cv: cv/cv.pdf

# Rebuilds the PDF only when a source file is newer than it.
cv/cv.pdf: references.bib talks.yaml reviews.yaml links.yaml cv/cv.yaml _build.py
	./cv/render.sh

site:
	$(PYTHON) _build.py
	quarto render

preview:
	$(PYTHON) _build.py
	quarto preview

clean:
	rm -rf docs cv/_rendercv_output
