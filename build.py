#!/usr/bin/python

import argparse
import os
import re
import shutil
import sys
import time

from pathlib import Path

from assets.build.typst.conspect_builder import TypstConspectBuilder
from assets.build.tex.conspect_builder import TexConspectBuilder

DEFAULT_OUTPUT_DIRECTORY = Path("conspects")

parser = argparse.ArgumentParser(
    prog='build.py',
    description='This program helps you to build source files into ready-to-read PDFs!'
)
parser.add_argument('input_filename', help="Path to an input file")
parser.add_argument('-o', '--output-directory', help="Path to a directory of the file to be compiled (by default is `conspects/subjectname`)")
parser.add_argument('--watch', action='store_true', help="Watches an input file and recompiles on changes (for Typst only)")
parser.add_argument('-l', '--linted-output', help="Path to a directory which will store temporary files (for Tex only)", default='linted')
parser.add_argument('-v', '--verbose', action='store_true', help="Show verbose output (for Tex only)")
parser.add_argument('-f', '--force', action='store_true', help="Force continued processing past errors (for Tex only)")
parser.add_argument('--bibtex', action='store_true', help="Uses bibtex (by default bibtex isn't used) (for Tex only)")
parser.add_argument('--only-linter', action='store_true', help="Only uses linter, do not compiles the actual PDF (for Tex only)")

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
    t = TypstConspectBuilder(filename, output_filename)
elif filename.suffix == '.md':
    print("The file has markdown extension, nothing to do!")
    exit(0)
elif filename.suffix == '.tex':
    output_filename = os.path.join(output_directory, filename.stem + '.pdf')
    t = TexConspectBuilder(filename, output_filename, args.linted_output)
else:
    print('Unsupported file format, only `tex`, `md` and `typ` is allowed')
    exit(1)

exit(t.build(args))
