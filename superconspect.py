import os
import re
import sys

if len(sys.argv) <= 1:
    print('Enter source folder name as command argument')
    exit(1)


folder = sys.argv[1]
supername = folder + "_superconspect.tex"
BLACKLIST = ['cheatsheet', supername]

subject = None
teacher = None

text = ''

for i in os.listdir(folder):
    if i.endswith('tex') and not any([j in i for j in BLACKLIST]):
        t = open(os.path.join(folder, i), 'r', encoding='utf8').read()
        if subject is None:
            subject = re.search(r'\\fancyhead\[LO,LE]\{(.*)}', t).group(1)
        if teacher is None:
            teacher = re.search(r'\\fancyhead\[RO,RE]\{(.*)}', t).group(1)
        t = re.search(r'\\begin\{document\}(.+?)\n*\\end\{document\}', t, re.S | re.M | re.I)

        text += f'    % begin {i}\n'

        text += t.group(1) + f'\n    % end {i}\n\n'


text = re.sub(r'section\[.*]', 'section', text)
text = (open('superconspect_template.tex', encoding='utf8').read().
        replace('$conspects$', text).
        replace('$subject$', subject).
        replace('$teacher$', teacher))
open(os.path.join(folder, supername), 'w', encoding='utf8').write(text)

os.system("python linter.py " + os.path.join(".", folder, supername))

