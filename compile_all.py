import os

folder = "specsec"

for i in os.listdir(folder):
    if i.endswith('tex'):
        os.system("python linter.py " + os.path.join(".", folder, i))
