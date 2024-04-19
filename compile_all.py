import os

folder = "calculus"

for i in os.listdir(folder):
    if i.endswith('tex'):
        os.system("python linter.py " + os.path.join(".", folder, i))

os.system(f'python superconspect.py {folder}')
