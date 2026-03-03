import argparse
import os
import sys
import time
from pathlib import Path

from assets.build.typst.conspect_builder import TypstConspectBuilder
from assets.build.tex.conspect_builder import TexConspectBuilder
from assets.build.markdown.superconspect_builder import MarkdownSuperconspectBuilder
from assets.build.typst.superconspect_builder import TypstSuperconspectBuilder
from assets.build.tex.superconspect_builder import TexSuperconspectBuilder

DEFAULT_OUTPUT_DIRECTORY = Path("conspects")
BLACKLIST_WORDS = ['exam', 'superconspect']
SUPERCONSPECT_BLACKLIST_WORDS = ['cheatsheet', 'superconspect']

parser = argparse.ArgumentParser(
    prog='compile_all.py',
    description='This program helps you to build all files in a directory!'
)
parser.add_argument('input_directory', help="Path to an input directory")
parser.add_argument(
    '-o', '--output-directory', 
    help="Path to a directory for ready files to be compiled "
    "(by default is `conspects/subjectname/` for tex/typ and `subjectname/` for md)"
)
parser.add_argument('-s', '--source-filename', help="Path to a source superconspect file to be generated (by default is `subjectname/subjectname_superconspect.tex/typ`) (for Tex and Typst only)")
parser.add_argument('-l', '--linted-output', help="Path to a directory which will store temporary files (for Tex only)", default='linted')
parser.add_argument('-v', '--verbose', action='store_true', help="Show verbose output (for Tex only)")
parser.add_argument('-f', '--force', action='store_true', help="Force continued processing past errors (for Tex only)")
parser.add_argument('--bibtex', action='store_true', help="Uses bibtex (by default bibtex isn't used) (for Tex only)")
parser.add_argument('--only-linter', action='store_true', help="Only uses linter, do not compiles the actual PDF (for Tex only)")

args = parser.parse_args()


folder_files = [
    Path(args.input_directory) / i for i in os.listdir(args.input_directory) 
    if not i.startswith('__') and
        not i.endswith('.log') and
        not i.endswith('.aux') and
        not i.endswith('.fls') and
        not i.endswith('.fdb_latexmk') and
        (Path(args.input_directory) / i).is_file()
]
folder_files.sort()

results = {
    'nothing_to_do': [],
    'unsupported': [],
    'ignored': []
}

folder = Path(args.input_directory)
output_directory = pdf_output_directory = Path(args.output_directory) if args.output_directory else None
if output_directory is None:
    output_directory = folder
    pdf_output_directory = DEFAULT_OUTPUT_DIRECTORY / folder

start = time.time()

for filename in folder_files:
    if filename.stem.endswith('superconspect'):
        continue

    if not all(map(lambda x: x not in str(filename), BLACKLIST_WORDS)):
        results['nothing_to_do'].append(filename)
        continue


    if filename.suffix == '.md':
        results['nothing_to_do'].append(filename)
        continue
    elif filename.suffix == '.typ':
        output_filename = os.path.join(pdf_output_directory, filename.stem + '.pdf')
        t = TypstConspectBuilder(filename, output_filename)
    elif filename.suffix == '.tex':
        output_filename = os.path.join(pdf_output_directory, filename.stem + '.pdf')
        t = TexConspectBuilder(filename, output_filename, args.linted_output)
    else:
        # print(f'Unsupported file format in `{i}`, only `tex`, `md` and `typ` is allowed')
        results['unsupported'].append(filename)
        continue

    exit_code = t.build(args)

    if exit_code not in results:
        results[exit_code] = []

    results[exit_code].append(filename)


if list(map(lambda x: x.suffix == '.md', folder_files)).count(True) >= len(folder_files) / 2:
    output_filename = output_directory / (Path(args.input_directory).name + '_superconspect.md')
    t = MarkdownSuperconspectBuilder(args.input_directory, SUPERCONSPECT_BLACKLIST_WORDS, output_filename)
    exit_code = t.build(args)
elif list(map(lambda x: x.suffix == '.typ', folder_files)).count(True) >= len(folder_files) / 2:
    output_filename = pdf_output_directory / (Path(args.input_directory).name + '_superconspect.pdf')
    t = TypstSuperconspectBuilder(args.input_directory, SUPERCONSPECT_BLACKLIST_WORDS, output_filename, source_filename=args.source_filename)
    exit_code = t.build(args)
elif list(map(lambda x: x.suffix == '.tex', folder_files)).count(True) >= len(folder_files) / 2:
    output_filename = pdf_output_directory / (Path(args.input_directory).name + '_superconspect.pdf')
    t = TexSuperconspectBuilder(args.input_directory, SUPERCONSPECT_BLACKLIST_WORDS, output_filename, source_filename=args.source_filename)
    exit_code = t.build(args)
else:
    print(f'In folder `{args.input_directory}` there are less `.md`, `.typ`, `.tex` than others, I cannot detect file extension for superconspect')
    exit_code = 'unsupported'

if exit_code not in results:
    results[exit_code] = []
results[exit_code].append(t.superconspect_filename)

print("\nResults of compilation")

if results['unsupported']:
    print(f"\033[93mUnsupported file formats\033[0m:")
    for j in results['unsupported']:
        print(f'\t{j}')

if results['ignored']:
    print(f"\033[96mIgnored files\033[0m:")
    for j in results['ignored']:
        print(f'\t{j}')

if results['nothing_to_do']:
    print(f"\033[96mNothing to do files\033[0m:")
    for j in results['nothing_to_do']:
        print(f'\t{j}')

if 0 in results:
    print(f"\033[92mSuccess\033[0m:")
    for j in results[0]:
        print(f'\t{j}')

for i in filter(lambda x: isinstance(x, int) and x != 0 and results[x], results):
    print(f"\033[91mExit code = {i}\033[0m:")
    for j in results[i]:
        print(f'\t{j}')

print(f"Time spent: {round(time.time() - start, 2)} s")
