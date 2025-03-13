import os
import sys

if len(sys.argv) <= 1:
    print('Enter source folder name as command argument')
    exit(1)

folder = sys.argv[1]
BLACKLIST = ['exam']

for i in os.listdir(folder):
    if i.endswith('tex') and all([j not in i for j in BLACKLIST]):
        text = open(os.path.join(".", folder, i), encoding='utf-8').read()
        if '\\begin{document}' in text:
            os.system("python linter.py " + os.path.join(".", folder, i))
        else:
            os.system("python simple_tex.py " + os.path.join(".", folder, i))


os.system(f'python superconspect.py {folder}')
