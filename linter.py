import argparse
import re
import time
import shutil
import sys, os

from pathlib import Path

from assets.build.tex.conspect_builder import TexConspectBuilder

# for making tex *** fancier ***

DEFAULT_OUTPUT_DIRECTORY = Path("conspects")

parser = argparse.ArgumentParser(
    prog='linter.py',
    description='This program helps you to build source files into ready-to-read PDFs!'
)
parser.add_argument('input_filename', help="Path to an input TeX file")
parser.add_argument('-o', '--output-directory', help="Path to a directory of the file to be compiled")
parser.add_argument('-l', '--linted-output', help="Path to a directory which will store temporary files", default='linted')
parser.add_argument('-v', '--verbose', action='store_true', help="Show verbose output")
parser.add_argument('-f', '--force', action='store_true', help="Force continued processing past errors")
parser.add_argument('--bibtex', action='store_true', help="Uses bibtex (by default bibtex isn't used)")

args = parser.parse_args()

t = TexConspectBuilder(args.input_filename, None, args.linted_output)

exit(t.build(args))

