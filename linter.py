import re
import time
import shutil
import sys, os

# for making tex *** fancier ***

DEFAULT_OUTPUT_DIRECTORY = "./conspects/"

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

show_warnings = False
if '--warning' in sys.argv or '-w' in sys.argv:
    show_warnings = True

linted_output = None
if '--linted-output' in sys.argv or '-l' in sys.argv:
    ind = sys.argv.index('-l') if '-l' in sys.argv else sys.argv.index('--linted-output')

    if ind + 1 < len(sys.argv):
        linted_output = sys.argv[ind + 1]

output_directory = None
if '--output-directory' in sys.argv or '-o' in sys.argv:
    ind = sys.argv.index('-o') if '-o' in sys.argv else sys.argv.index('--output-directory')

    if ind + 1 < len(sys.argv):
        output_directory = sys.argv[ind + 1]
 
filename = sys.argv[1]
folder = os.path.join(*os.path.split(filename)[:-1])

file = open(filename, encoding='utf8').read()
file = "%% THIS FILE IS GENERATED AUTOMATICALLY BY linter.py, ALL CHANGES WILL BE LOST\n\n\n" + file

preamble_path = os.path.join(folder, 'preamble.sty')

preamble_text = open('preamble.sty', 'r', encoding='utf8').read()
preamble_text = "%% THIS FILE IS GENERATED AUTOMATICALLY BY linter.py, ALL CHANGES WILL BE LOST\n\n\n" + preamble_text
open(preamble_path, 'w', encoding='utf8').write(preamble_text)

to_display = True

for i in list(re.finditer(r'(\$.+?\$)|(%nodisplay)|(%yesdisplay)', file, re.MULTILINE | re.DOTALL)):
    if '%nodisplay' in i.group(0):
        to_display = False
    if '%yesdisplay' in i.group(0):
        to_display = True

    if not to_display:
        continue

    if r'\displaystyle' in i.group(0):
        continue
    if any(map(lambda x: x in i.group(0), [r'\frac', r'\sum', r'\int', r'\iint', r'\iiint', '^', '_', r'\lim'])):
        file = file.replace(i.group(0), r'$\displaystyle ' + i.group(0)[1:])


if not os.path.exists('linted'):
    os.mkdir('linted')

if linted_output is None:
    linted_output = os.path.join('linted', os.path.split(filename)[-1])
open(linted_output, 'w', encoding='utf8').write(file)

interaction = 'nonstopmode' if show_warnings else 'batchmode'

print(f'\n\nRendering {filename}...\n')

start_time = time.time()

os.system(f"pdflatex -file-line-error -interaction={interaction} -synctex=1 -output-format=pdf "
          f"-output-directory=\"{os.path.join(DEFAULT_OUTPUT_DIRECTORY, folder) if output_directory is None else output_directory}\" "
          f"-aux-directory=./auxil/ "
          f"{linted_output} "
          f"-file-line-error")

print(f'\nRender of {filename} completed in {round(time.time() - start_time, 2)} s!')

