# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS   ?=
SPHINXBUILD  ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Internal variables.
# $(O) is meant as a shortcut for $(SPHINXOPTS)
ALLSPHINXOPTS = -v -j auto -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(O) $(SOURCEDIR)

.PHONY: html
html: Makefile
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) "$(BUILDDIR)/$@"

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html        to make standalone HTML files"
	@echo "  changes     to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck   to check all external links for integrity"
	@echo "  doctest     to run all doctests embedded in the documentation (if enabled)"
	@echo "  coverage    to run coverage check of the documentation (if enabled)"
	@echo "  dummy       to check syntax errors of document sources"
	@echo "  clean       to remove everything in the build directory"

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)/*

# Catch-all target: route all unknown targets to Sphinx
.PHONY: Makefile
%: Makefile
	$(SPHINXBUILD) -b "$@" $(ALLSPHINXOPTS) "$(BUILDDIR)/$@"
