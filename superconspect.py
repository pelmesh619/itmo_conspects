#!/usr/bin/python

import argparse
import os
import re
import sys

from pathlib import Path
from urllib.parse import quote

from assets.build.markdown.superconspect_builder import MarkdownSuperconspectBuilder
from assets.build.typst.superconspect_builder import TypstSuperconspectBuilder
from assets.build.tex.superconspect_builder import TexSuperconspectBuilder

BLACKLIST_WORDS = [
    'cheatsheet', 
    "superconspect", 
]

parser = argparse.ArgumentParser(
    prog='superconspect.py',
    description='This program helps you to build superconspect from multiple tex/md/typ-files to one big file!'
)
parser.add_argument('input_directory', help="Path to an input directory")
parser.add_argument(
    '-o', '--output-filename', 
    help="Path to a ready file (.pdf or .md) to be compiled "
    "(by default is `conspects/subjectname/subjectname_superconspect.pdf` or `subjectname/subjectname_superconspect.md`)"
)
parser.add_argument('-s', '--source-filename', help="Path to a source superconspect file to be generated (by default is `subjectname/subjectname_superconspect.tex/typ`) (for Tex and Typst only)")
parser.add_argument('--watch', action='store_true', help="Watches an input file and recompiles on changes (for Typst only)")
parser.add_argument('-l', '--linted-output', help="Path to a directory which will store temporary files (for Tex only)", default='linted')
parser.add_argument('-v', '--verbose', action='store_true', help="Show verbose output (for Tex only)")
parser.add_argument('-f', '--force', action='store_true', help="Force continued processing past errors (for Tex only)")
parser.add_argument('--bibtex', action='store_true', help="Uses bibtex (by default bibtex isn't used) (for Tex only)")
parser.add_argument('--only-linter', action='store_true', help="Only uses linter, do not compiles the actual PDF (for Tex only)")

args = parser.parse_args()

folder_files = [
    i for i in os.listdir(args.input_directory) 
    if not i.startswith('__') and
        not i.endswith('.log') and
        not i.endswith('.aux') and
        not i.endswith('.fls') and
        not i.endswith('.fdb_latexmk')
]
folder_files.sort()

if list(map(lambda x: x.endswith('.md'), folder_files)).count(True) >= len(folder_files) / 2:
    t = MarkdownSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS, args.output_filename)

elif list(map(lambda x: x.endswith('.typ'), folder_files)).count(True) >= len(folder_files) / 2:
    t = TypstSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS, args.output_filename, args.source_filename)

elif list(map(lambda x: x.endswith('.tex'), folder_files)).count(True) >= len(folder_files) / 2:
    t = TexSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS, args.output_filename, args.source_filename)

else:
    print(f'In folder `{args.input_directory}` there are less `.md`, `.typ`, `.tex` than others, I cannot detect file extension')
    exit(1)

exit(t.build(args))


