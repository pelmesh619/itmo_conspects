#!/usr/bin/python

import argparse
import os
import re
import shutil
import sys
import time

from pathlib import Path

DEFAULT_OUTPUT_DIRECTORY = Path("conspects")

parser = argparse.ArgumentParser(
    prog='build.py',
    description='This program helps you to build source files into ready-to-read PDFs!'
)
parser.add_argument('input_filename', help="Path to an input file")
parser.add_argument('-o', '--output-directory', help="Path to a directory of the file to be compiled")
parser.add_argument('--watch', action='store_true', help="Watches an input file and recompiles on changes")

args = parser.parse_args()

filename = Path(args.input_filename)
folder = filename.parent
output_directory = Path(args.output_directory) if args.output_directory else None

if output_directory is None:
    output_directory = DEFAULT_OUTPUT_DIRECTORY / folder

if not output_directory.exists():
    os.mkdir(output_directory)

if filename.suffix == '.typ':
    output_filename = os.path.join(output_directory, filename.stem + '.pdf')

    print(f'Compiling {filename}...\n')

    start_time = time.time()

    exit_code = os.system(
        f"typst {'compile' if not args.watch else 'watch'} "
        f"{filename} "
        f"{output_filename} "
        f"--root . "
    )

    if not args.watch:
        if exit_code == 0:
            print(f'Compilation of {output_filename} completed in {round(time.time() - start_time, 2)} s!')
        else:
            print(f'Compilation of {output_filename} failed')

