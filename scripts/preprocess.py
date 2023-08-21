#!/usr/bin/env python
import sys
import nbformat as nbf
import argparse
from pathlib import Path

if __name__ == "__main__":
    cwd = Path(__file__).parent
    parser = argparse.ArgumentParser()
    parser.add_argument("notebook", type=Path)
    parser.add_argument("-o", "--output", type=Path, help="output file path/name to save to", metavar='file')
    args = parser.parse_args()

    n = nbf.read(args.notebook, nbf.NO_CONVERT)

    n["metadata"]["orphan"] = True
    n["metadata"]["nosearch"] = True

    for i, cell in enumerate(n["cells"]):
        if cell["cell_type"] == "markdown":
            lines = cell["source"].split("\n")
            rejoin = False
            for j, line in enumerate(lines):
                if line.startswith("![]("):
                    src = "/toi_data/" + line.strip().removeprefix("![](").removesuffix(
                        ")"
                    )
                    lines[j] = f"<img src='{src}'>"
                    rejoin = True
            if rejoin:
                n["cells"][i]["source"] = "\n".join(lines)

    if args.output:
        nbf.write(n, args.output)
    else:
        nbf.write(n, sys.stdout)
