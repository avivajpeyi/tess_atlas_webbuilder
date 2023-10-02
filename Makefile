# You can set these variables from the command line.
SPHINXOPTS   ?=
SPHINXBUILD  ?= sphinx-build
SUMMARYFILE  ?= source/analysis_summary.csv

# Internal variables
ALLSPHINXOPTS = -v -j auto -d build/doctrees $(SPHINXOPTS) source
SCRIPTDIR     = scripts
MENUPAGE      = source/menu_page.md

notebooks = $(notdir $(wildcard source/objects/toi_*.ipynb))
file_dirs = $(notdir $(wildcard source/objects/toi_*_files))
expected_dirs = $(addsuffix _files, $(basename $(notebooks)))

# Use GNU version of ln on Darwin (MacOS)
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  LN = ln
else
  LN = gln
endif

.PHONY: dirhtml menupage help clean check preprocess checks check_for_file_dirs check_for_summary_file checkall

# Default is to build 'dirhtml'
dirhtml html changes linkcheck dummy: menupage
	@mkdir -p "build/$@/toi_data"
	$(SPHINXBUILD) -b "$@" $(ALLSPHINXOPTS) "build/$@"
	$(if $(findstring $@, dirhtml html), @$(MAKE) "$@_links")

%_links:
	$(eval BUILDDIR=build/$(subst _links,,$@))
	@echo "==> Adding links to source..."
	rm -f $(BUILDDIR)/toi_data/toi_*_files
	$(LN) -rs source/objects/toi_*_files $(BUILDDIR)/toi_data/

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  dirhtml     to make HTML files named index.html in directories (default)"
	@echo "  html        to make standalone HTML files"
	@echo "  changes     to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck   to check all external links for integrity"
	@echo "  dummy       to check syntax errors of document sources"
	@echo "  clean       to remove everything in the build directory"

menupage: checks
	@echo "==> Writing: $(MENUPAGE)"
	@./$(SCRIPTDIR)/menu-page.py -s $(SUMMARYFILE) source > $(MENUPAGE)

clean:
	rm -rf build/*

# Max concurrent procs
NP = $(shell echo $$(( $(shell nproc) * 8 )))
preprocess:
	@find ./source/objects -name 'toi_*.ipynb' -type f | xargs -t -P $(NP) -I FILE ./$(SCRIPTDIR)/preprocess.py FILE -o FILE

checks: check_for_summary_file check_for_file_dirs

check_for_file_dirs:
ifneq ($(expected_dirs), $(file_dirs))
	@echo "WARNING: missing file directories... $(filter-out $(file_dirs), $(expected_dirs))"
endif

check_for_summary_file:
	@test -f $(SUMMARYFILE) || (echo "ERROR: $(SUMMARYFILE) does not exist" && exit 1)

checkall: checks linkcheck dummy

test_build:
	@echo "==> Testing the sphinx build workflow..."
	$(eval TMPDIR=test_notebooks_dir)
	python $(SCRIPTDIR)/fake_notebooks_generator.py -n 10 -o $(TMPDIR)
	$(SPHINXBUILD) -b "html" $(ALLSPHINXOPTS) "$(TMPDIR)/html"
	@echo "==> Open pages at: file:///$(PWD)/$(TMPDIR)/html/index.html"
