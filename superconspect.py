import os
import re
import sys

from pathlib import Path

from urllib.parse import quote

if len(sys.argv) <= 1:
    print('Enter source folder name as command argument')
    exit(1)

folder = sys.argv[1]
BLACKLIST_WORDS = [
    'cheatsheet', 
    "superconspect", 
]

warning_all = '-w' in sys.argv or '--wall' in sys.argv

folder_files = [i for i in os.listdir(folder) if not i.startswith('__')]
folder_files.sort()

if all(map(lambda x: x.endswith('.md') or '.' not in x, folder_files)):
    from assets.build.markdown.superconspect_builder import MarkdownSuperconspectBuilder

    t = MarkdownSuperconspectBuilder(folder, BLACKLIST_WORDS)

    t.build()

    print("Markdown file is combined!")

elif all(map(lambda x: x.endswith('.typ') or '.' not in x, folder_files)):
    from assets.build.typst.superconspect_builder import TypstSuperconspectBuilder

    t = TypstSuperconspectBuilder(folder, BLACKLIST_WORDS)

    t.build()
else:
    supername = folder + "_superconspect.tex"

    subject = None
    teacher = None

    text = ''

    for i in folder_files:
        if not i.endswith('.tex') or any([j in i for j in BLACKLIST_WORDS]):
            continue

        t = open(os.path.join(folder, i), 'r', encoding='utf8').read()
        if t.startswith('%ignore'):
            print(f'File {i} is ignored')
            continue

        if subject is None:
            subject = re.search(r'\\fancyhead\[LO,LE]\{(.*)}', t)
            if subject is None:
                subject = re.search(r'\$subject\$=(.*)\n', t).group(1)
            else:
                subject = subject.group(1)
        if teacher is None:
            teacher = re.search(r'\\fancyhead\[RO,RE]\{(.*)}', t)
            if teacher is None:
                teacher = re.search(r'\$teacher\$=(.*)\n', t).group(1)
            else:
                teacher = teacher.group(1)
        match = re.search(r'\\begin\{document\}(.+?)\n*\\end\{document\}', t, re.S | re.M | re.I)

        if not match:
            match_text = t
            for j in re.finditer(r'((\n)|(^))(\$\w+\$)\=(.*)', match_text):
                match_text = match_text.replace(j.group(0), '\n', 1)
        else:
            match_text = match.group(1)

        text += f'% begin {i}\n'

        text += match_text + f'\n% end {i}\n\n'


    text = re.sub(r'section\[.*]', 'section', text)
    text = (open('assets/build/tex/superconspect_template.tex', encoding='utf8').read().
            replace('$conspects$', text).
            replace('$subject$', subject).
            replace('$teacher$', teacher))
    open(os.path.join(folder, supername), 'w', encoding='utf8').write(text)

    os.system("python linter.py " + os.path.join(".", folder, supername) + 
        (' -w' if warning_all else ''))

