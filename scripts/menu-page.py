#!/usr/bin/env python

import argparse
from jinja2 import Environment, FileSystemLoader
from pathlib import Path


def pretty_name(name):
    return name.replace("_", " ").upper()


if __name__ == "__main__":
    cwd = Path(__file__).parent

    parser = argparse.ArgumentParser()
    parser.add_argument("notebooks", nargs="+", type=Path)
    args = parser.parse_args()

    names = []
    tois = []
    phaseplots = []
    for nb in args.notebooks:
        toi_name = str(nb.with_suffix("").name)
        files_dir = nb.resolve().parent / (toi_name + "_files")
        toi_name

        phaseplots.append([str(i.name) for i in files_dir.glob("phase_plot_TOI*.png")])
        tois.append(toi_name)

    environment = Environment(
        loader=FileSystemLoader(cwd / "templates"),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    environment.filters["pretty"] = pretty_name
    template = environment.get_template("menu_page.tmpl")

    content = template.render(
        N_TESS_ATLAS="X",
        N_EXOFOP="X",
        N_PASS="X",
        N_FAIL="X",
        N_NOT_STARTED="X",
        rows=zip(tois, phaseplots),
    )
    print(content)
