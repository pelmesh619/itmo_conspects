import os
import sys

if len(sys.argv) <= 1:
    print('Enter source folder name as command argument')
    exit(1)

folder = sys.argv[1]
BLACKLIST = ['exam']

for i in os.listdir(folder):
    if i.endswith('tex') and all([j not in i for j in BLACKLIST]):
        os.system("python linter.py " + os.path.join(".", folder, i))

os.system(f'python superconspect.py {folder}')
