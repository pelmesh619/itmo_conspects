import os

folder = "specsec"

for i in os.listdir(folder):
    if i.endswith('tex') and 'exam' not in i:
        os.system("python linter.py " + os.path.join(".", folder, i))

os.system(f'python superconspect.py {folder}')
