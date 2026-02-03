#!/usr/bin/python

import re
import time
import shutil
import sys, os
from pathlib import Path


DEFAULT_OUTPUT_DIRECTORY = Path("conspects")

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

filename = Path(sys.argv[1])
folder = filename.parent
output_directory = None
if '--output-directory' in sys.argv or '-o' in sys.argv:
    ind = sys.argv.index('-o') if '-o' in sys.argv else sys.argv.index('--output-directory')

    if ind + 1 < len(sys.argv):
        output_directory = Path(sys.argv[ind + 1])

if output_directory is None:
    output_directory = DEFAULT_OUTPUT_DIRECTORY / folder

if not output_directory.exists():
    os.mkdir(output_directory)

if filename.suffix == '.typ':
    output_filename = os.path.join(output_directory, filename.stem + '.pdf')

    print(f'Compiling {filename}...\n')

    start_time = time.time()

    exit_code = os.system(
        f"typst compile "
        f"{filename} "
        f"{output_filename} "
        f"--root . "
    )

    if exit_code == 0:
        print(f'Compilation of {output_filename} completed in {round(time.time() - start_time, 2)} s!')
    else:
        print(f'Compilation of {output_filename} failed')

