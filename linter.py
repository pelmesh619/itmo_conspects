import re
import sys, os

# for making tex *** fancier ***

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

filename = sys.argv[1]

file = open(filename, encoding='utf8').read()

print(list(re.finditer(r'\$.+?\$', file, re.MULTILINE | re.DOTALL)))

for i in list(re.finditer(r'\$.+?\$', file, re.MULTILINE | re.DOTALL)):
    if '\\displaystyle' in i.group(0):
        continue
    if any(map(lambda x: x in i.group(0), ['\\frac', '\\Sigma', '\\int', '\\iint', '\\iiint'])):
        file = file.replace(i.group(0), '$\\displaystyle ' + i.group(0)[1:])

for i in list(re.finditer(r'\n *([^ ].+:)\n', file)):
    if '$' not in i.group(1):
        print(i)
        file = file.replace(i.group(1), f'\n    \\vspace{{5mm}}\n    \\textbf{{{i.group(1)}}}')

for i in ['Nota', 'Def', 'Mem', 'Th', 'Ex']:
    file = file.replace(i, f'\\vspace{{3mm}}\n\\textit{{{i}}}')

if not os.path.exists('linted'):
    os.mkdir('linted')

new_filename = 'linted\\' + filename.split('\\')[-1]
open(new_filename, 'w', encoding='utf8').write(file)

os.system("pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf "
          "-output-directory=./out/ "
          "-aux-directory=./auxil/ {}".format(new_filename))





