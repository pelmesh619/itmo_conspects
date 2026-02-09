import re
import time
import shutil
import sys, os

# for making tex simple and *** fancier ***

template = open('assets/conspect_template.tex', encoding='utf8').read()

def make_full_doc(folder, content):
    global template
    t = template

    if os.path.exists(os.path.join(folder, '__preamble.sty')):
        specific_preamble = open(os.path.join(folder, '__preamble.sty'), encoding='utf8').read()
        t = t.replace('$topic_preamble$', specific_preamble, 1)
    else:
        t = t.replace('$topic_preamble$', '', 1)

    new_content = content
    for i in re.finditer(r'((\n)|(^))(\$\w+\$)\=(.*)', content):
        if i.group(4) in t:
            t = t.replace(i.group(4), i.group(5), 1)
            new_content = new_content.replace(i.group(0), '\n', 1)

    new_content = re.sub('(.+)\n', r'    \g<1>\n', new_content + '\n')

    new_content = t.replace('% content %', new_content, 1)

    return new_content


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        print('Enter source filename as command argument')
        exit(1)

    show_warnings = False
    if '--warning' in sys.argv or '-w' in sys.argv:
        show_warnings = True
    
    filename = sys.argv[1]
    folder = os.path.join(*os.path.split(filename)[:-1])

    new_text = make_full_doc(folder, open(filename, encoding='utf8').read())

    if not os.path.exists('linted'):
        os.mkdir('linted')

    new_filename = os.path.join('linted', os.path.split(filename)[-1])
    open(new_filename, 'w', encoding='utf8').write(new_text)

    os.system(f"python linter.py {new_filename} "
            f"{'-w' if show_warnings else ''} "
            f"-o {os.path.join('conspects', folder)}")
