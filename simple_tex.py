import re
import time
import shutil
import sys, os

# for making tex simple and *** fancier ***

template = r"""
% THIS FILE IS GENERATED AUTOMATICALLY BY simple_tex.py, ALL CHANGES WILL BE LOST

\documentclass[12pt]{article}
\usepackage{preamble}

\pagestyle{fancy}
\fancyhead[LO,LE]{$subject$}
\fancyhead[CO,CE]{$date$}
\fancyhead[RO,RE]{$teacher$}

\fancyfoot[L]{\scriptsize исходники найдутся тут: \\ \url{https://github.com/pelmesh619/itmo_conspects} \Cat}

\begin{document}
% content %
\end{document}
"""

if len(sys.argv) <= 1:
    print('Enter source filename as command argument')
    exit(1)

show_warnings = False
if '--warning' in sys.argv or '-w' in sys.argv:
    show_warnings = True
 
filename = sys.argv[1]
folder = os.path.join(*os.path.split(filename)[:-1])

file = open(filename, encoding='utf8').read() + '\n'

file = re.sub('(.+)\n', r'    \g<1>\n', file)

for i in re.finditer(r'((\n)|(^))\$(.+)\$\=(.+)\n', file):
    template = template.replace(i.group(4), i.group(5), 1)

new_text = template.replace('% content %', file, 1)

if not os.path.exists('linted'):
    os.mkdir('linted')

new_filename = os.path.join('linted', os.path.split(filename)[-1])
open(new_filename, 'w', encoding='utf8').write(new_text)

os.system(f"python linter.py {new_filename} "
          f"{'-w' if show_warnings else ''} "
          f"-o {os.path.join('conspects', folder)}")
