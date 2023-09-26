# Tess Atlas Web-builder

## Installing dependencies
You'll need Python (>=3.9), GNU Make, Sphinx + a bunch of sphinx extensions.
Notebook rendering is done with `myst-nb`. Install all python deps from the requirements file with
```
pip install -r requirements.txt
```

## Building the site
1. Put notebooks and other content into `source/objects/`
2. Build website by running `make html`
3. Clean site build dir by running `make clean`



## Notes on configs for server 
symlink the apache webdir to the tess-atlas html pages:
```
sudo ln -fs /mnt/storage/tess_atlas_webbuilder/build/dirhtml html
```
Then restart 
```
sudo systemctl restart httpd
```
