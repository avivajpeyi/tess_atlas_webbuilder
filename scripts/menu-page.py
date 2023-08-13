#!/usr/bin/env python

import argparse
from pathlib import Path
import itables

import pandas as pd
from jinja2 import Environment, FileSystemLoader


# Custom Jinja2 filter
def pretty_name(name):
    return name.replace("_", " ").upper()


# Uses itables to generate html for a fancy table
def generate_table_html(src_dir, csv_path):
    tois = []
    phaseplots = []
    for d in (src_dir / "objects").glob("toi_*_files"):
        i_toi = int(str(d.name).removeprefix("toi_").removesuffix("_files"))
        tois.append(i_toi)
        phaseplots.append([str(i.name) for i in d.glob("phase_plot_TOI*.png")])

    df = pd.read_csv(csv_path)[["TOI", "Status", "Category", "Classification"]]
    df = df.loc[df["TOI"].isin(tois)]

    html = itables.to_html_datatable(
        df.reset_index(drop=True),
        caption="TESS Atlas Catalog Summary",
        scrollX=True,
        lengthMenu=[5, 10, 20, 50],
        classes="compact",
        maxBytes=0,
        connected=True,
    )

    return html


if __name__ == "__main__":
    cwd = Path(__file__).parent
    parser = argparse.ArgumentParser()
    parser.add_argument("source_directory", type=Path)
    args = parser.parse_args()
    src_dir = args.source_directory.resolve()

    csv_path = src_dir / "analysis_summary.csv"
    assert csv_path.is_file()

    html_table = generate_table_html(src_dir, csv_path)

    # Get analysis counts
    counts = pd.read_csv(csv_path)["Status"].value_counts().to_dict()

    # Set up jinja2 env
    environment = Environment(
        loader=FileSystemLoader(cwd / "templates"),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    environment.filters["pretty"] = pretty_name
    template = environment.get_template("menu_page.j2")

    # Render menu_page.myst and print to stdout
    content = template.render(
        N_TESS_ATLAS=" **TODO** ",
        N_EXOFOP=" **TODO** ",
        N_PASS=counts.get("completed", 0),
        N_FAIL=counts.get("failed", 0),
        N_NOT_STARTED=counts.get("not_started", 0),
        html_table=html_table,
    )
    print(content)
