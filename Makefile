# You can set these variables from the command line.
SPHINXOPTS   ?=
SPHINXBUILD  ?= sphinx-build

# Internal variables. $(O) is meant as a shortcut for $(SPHINXOPTS)
ALLSPHINXOPTS = -v -j auto -d build/doctrees $(SPHINXOPTS) $(O) source
SCRIPTDIR     = scripts
MENUPAGE      = source/menu_page.md
SUMMARYFILE   = source/analysis_summary.csv

.PHONY: dirhtml tocs tocpage menupage help clean check Makefile preprocess

dirhtml html changes linkcheck dummy: menupage
	@echo "==> Running sphinx build..."
	$(eval BUILDDIR=build/$@)
	mkdir -p $(BUILDDIR); rm -f $(BUILDDIR)/toi_data
	ln -s $(PWD)/source/objects $(BUILDDIR)/toi_data
	$(SPHINXBUILD) -b "$@" $(ALLSPHINXOPTS) "$(BUILDDIR)"

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
	@./$(SCRIPTDIR)/menu-page.py -s $(SUMMARYFILE) source > $(MENUPAGE)

check:
	@./$(SCRIPTDIR)/check $(SUMMARYFILE)

clean:
	rm -rf build/*

preprocess:
	for item in source/objects/toi_*.ipynb; do echo $$item; ./$(SCRIPTDIR)/preprocess.py $$item; done
