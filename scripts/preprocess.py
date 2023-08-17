#!/usr/bin/env python
import nbformat as nbf
import argparse
from pathlib import Path

if __name__ == "__main__":
    cwd = Path(__file__).parent
    parser = argparse.ArgumentParser()
    parser.add_argument("notebook", type=Path)
    args = parser.parse_args()

    n=nbf.read(args.notebook, nbf.NO_CONVERT)

    n['metadata']['orphan'] = True
    n['metadata']['nosearch'] = True

    for i, cell in enumerate(n["cells"]):
        if cell['cell_type'] == 'markdown':
            lines = cell["source"].split('\n')
            rejoin = False
            for j, line in enumerate(lines):
                if line.startswith("![]("):
                    src = '/toi_data/' + line.strip().removeprefix('![](').removesuffix(')')
                    lines[j] = f"<img src='{src}'>"
                    rejoin = True
            if rejoin:
                n['cells'][i]["source"] = '\n'.join(lines)

    # Save
    nbf.write(n, args.notebook)
