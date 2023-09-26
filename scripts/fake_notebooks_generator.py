""" Generates N fake TOI notebooks for testing purposes.

NOTE: This assumes you have installed tess_atlas as a package.

"""
from tqdm.auto import trange
from tess_atlas.notebook_controllers.controllers import TOINotebookController
from tess_atlas.data.analysis_summary import AnalysisSummary
import argparse


def generate_fake_notebooks_dir(
        n_toi: int = 5, outdir: str = "test_notebooks", additional_files=True
) -> None:
    for i in trange(101, 101 + n_toi, desc="Generating fake TOI notebooks"):
        TOINotebookController._generate_test_notebook(
            toi_int=i, outdir=outdir, additional_files=additional_files
        )
    print(f"Generated {n_toi} fake TOI notebooks in {outdir}")
    summary = AnalysisSummary.load(outdir)
    print(f"Saved analysis summary to {summary.fname(outdir)}")


def parse_cli_args():
    # get cli args (n notebooks, outdir)
    cli_parser = argparse.ArgumentParser(
        description="Generate fake TOI notebooks for testing purposes.")
    cli_parser.add_argument(
        "-n", "--n", type=int, default=5, help="Number of fake notebooks to generate.")
    cli_parser.add_argument(
        "-o", "--outdir", type=str, default="test_notebooks", help="Output directory.")
    return cli_parser.parse_args()


def main():
    args = parse_cli_args()
    generate_fake_notebooks_dir(n_toi=args.n, outdir=args.outdir)


if __name__ == '__main__':
    main()
