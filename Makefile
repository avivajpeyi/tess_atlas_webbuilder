# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS   ?=
SPHINXBUILD  ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
SCRIPTDIR     = scripts
MENUPAGE      = $(SOURCEDIR)/menu_page.md
SUMMARYFILE   = $(SOURCEDIR)/analysis_summary.csv

# Internal variables.
# $(O) is meant as a shortcut for $(SPHINXOPTS)
ALLSPHINXOPTS = -v -j auto -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(O) $(SOURCEDIR)

.PHONY: dirhtml tocs tocpage menupage help clean check Makefile preprocess

dirhtml html changes linkcheck dummy: Makefile menupage
	@echo "==> Running sphinx build..."
	$(eval BDIR=$(BUILDDIR)/$@)
	mkdir -p $(BDIR); rm -f $(BDIR)/toi_data
	ln -s $(PWD)/$(SOURCEDIR)/objects $(BDIR)/toi_data
	$(SPHINXBUILD) -b "$@" $(ALLSPHINXOPTS) "$(BDIR)"

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  dirhtml     to make HTML files named index.html in directories (default)"
	@echo "  html        to make standalone HTML files"
	@echo "  changes     to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck   to check all external links for integrity"
	@echo "  dummy       to check syntax errors of document sources"
	@echo "  clean       to remove everything in the build directory"

menupage: check
	@echo "==> Writing: $(MENUPAGE)"
	@./$(SCRIPTDIR)/menu-page.py -s $(SUMMARYFILE) $(SOURCEDIR) > $(MENUPAGE)

check:
	@./$(SCRIPTDIR)/check $(SUMMARYFILE)

clean:
	rm -rf $(BUILDDIR)/*

preprocess:
	for item in $(SOURCEDIR)/objects/toi_*.ipynb; do echo $$item; ./$(SCRIPTDIR)/preprocess.py $$item; done
