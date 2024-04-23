import re
import shutil
import sys, os

# for making tex *** fancier ***

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

filename = sys.argv[1]

file = open(filename, encoding='utf8').read()

preamble_path = os.path.join(*os.path.split(filename)[:-1], 'preamble.sty')

shutil.copyfile('preamble.sty', preamble_path)
preamble_text = "%% THIS FILE IS GENERATED AUTOMATICALLY BY linter.py, ALL CHANGES WILL BE LOST\n\n\n" + open(preamble_path, 'r', encoding='utf8').read()
open(preamble_path, 'w', encoding='utf8').write(preamble_text)

for i in list(re.finditer(r'\$.+?\$', file, re.MULTILINE | re.DOTALL)):
    if '\\displaystyle' in i.group(0):
        continue
    if any(map(lambda x: x in i.group(0), ['\\frac', '\\sum', '\\int', '\\iint', '\\iiint', '^', '_', '\\lim'])):
        file = file.replace(i.group(0), '$\\displaystyle ' + i.group(0)[1:])


if not os.path.exists('linted'):
    os.mkdir('linted')

new_filename = 'linted\\' + filename.split('\\')[-1]
open(new_filename, 'w', encoding='utf8').write(file)

os.system("pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf "
          "-output-directory=./out/ "
          "-aux-directory=./auxil/ {}".format(new_filename))





