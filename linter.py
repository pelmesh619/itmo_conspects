import re
import shutil
import sys, os

# for making tex *** fancier ***

OUT_FOLDER = "./conspects/"

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

filename = sys.argv[1]
folder = os.path.join(*os.path.split(filename)[:-1])

file = open(filename, encoding='utf8').read()

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

new_filename = os.path.join('linted', os.path.split(filename)[-1])
open(new_filename, 'w', encoding='utf8').write(file)

os.system(f"pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf "
          f"-output-directory=./{OUT_FOLDER}/{folder} "
          f"-aux-directory=./auxil/ {new_filename}")
