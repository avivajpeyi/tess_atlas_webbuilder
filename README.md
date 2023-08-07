# Tess Atlas Web-builder

## Installing dependencies
You'll need Python (tested with 3.10), Make, Sphinx + a bunch of sphinx extensions.
Notebook rendering is done with `myst-nb`. Install all python deps from the requirements file.
```
pip install -r requirements.txt
```

## Building the site
1. Put notebooks and other content into `source/objects/`
2. Build website by running `make html`
3. Clean site build dir by running `make clean`
