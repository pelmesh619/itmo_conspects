import argparse
import os
import re
import sys

from pathlib import Path
from urllib.parse import quote

BLACKLIST_WORDS = [
    'cheatsheet', 
    "superconspect", 
]

parser = argparse.ArgumentParser(
    prog='superconspect.py',
    description='This program helps you to build superconspect from multiple tex/md/typ-files to one big file!'
)
parser.add_argument('input_directory', help="Path to an input directory")
parser.add_argument('--verbose', action='store_true', help="Show verbose output")

args = parser.parse_args()

folder_files = [i for i in os.listdir(args.input_directory) if not i.startswith('__')]
folder_files.sort()

if all(map(lambda x: x.endswith('.md') or '.' not in x, folder_files)):
    from assets.build.markdown.superconspect_builder import MarkdownSuperconspectBuilder

    t = MarkdownSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS)

    t.build(args)

    print("Markdown file is combined!")

elif all(map(lambda x: x.endswith('.typ') or '.' not in x, folder_files)):
    from assets.build.typst.superconspect_builder import TypstSuperconspectBuilder

    t = TypstSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS)

    t.build(args)
else:
    from assets.build.tex.superconspect_builder import TexSuperconspectBuilder

    t = TexSuperconspectBuilder(args.input_directory, BLACKLIST_WORDS)

    t.build(args)


