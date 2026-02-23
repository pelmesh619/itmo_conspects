import os
import re
from pathlib import Path

from assets.build.superconspect_builder import SuperconspectBuilder


class TypstSuperconspectBuilder(SuperconspectBuilder):
    def __init__(self, input_folder, blacklist_words, output_filename=None):
        super().__init__(input_folder, blacklist_words, output_filename)

        self.level = len(list(i for i in os.path.split(input_folder) if i))

        self.subject_name = None
        self.lecturer_name = None
        self.top_level_header = None

    @property
    def superconspect_filename(self):
        if self.output_filename is None:
            return Path(self.input_folder) / (Path(self.input_folder).name + "_superconspect.typ")

        return self.output_filename

    def filter(self, file_text):
        return re.sub(r'(\t\r )*//+\s*ignore.*?((//+\s*noignore)|($))', '', file_text, flags=re.UNICODE | re.DOTALL).strip()

    def collect_variables(self, file_text):
        if self.subject_name is None:
            subject_match = re.search(r'#let subject-name = \[(.+)\]', file_text)
            if subject_match is not None:
                self.subject_name = subject_match.group(1)

        if self.lecturer_name is None:
            lecturer_name_match = re.search(r'#let lecturer-name = \[(.+)\]', file_text)
            if lecturer_name_match is not None:
                self.lecturer_name = lecturer_name_match.group(1)

        if self.top_level_header is None:
            top_level_header_match = re.search(r'^=\s+(.+)', file_text, re.M)
            if top_level_header_match is not None:
                self.top_level_header = top_level_header_match.group(1)
                file_text = re.sub(r'^=\s+(.+)', '', file_text, count=1, flags=re.M)

        return file_text

    def build(self):
        folder_files = [i for i in os.listdir(self.input_folder) if not i.startswith('__')]
        folder_files.sort()

        preamble_location = os.path.join(*(['..'] * self.level), 'preamble.typ')

        text = ''

        for i in folder_files:
            if not i.endswith('.typ') or any([j in i for j in self.blacklist_words]):
                continue

            t = open(os.path.join(self.input_folder, i), 'r', encoding='utf8').read()

            t = self.filter(t)

            if not t:
                print(f'File `{i}` ignored')
                continue

            t = self.collect_variables(t)

            while re.search(r'^\s*\#(let|show|import)[^\n]*?(\(.+?\))?\n+', t, re.S):
                t = re.sub(r'^\s*\#(let|show|import)[^\n]*?(\(.+?\))?\n+', '', t, count=1, flags=re.S)

            text += f'// begin {i}\n'
            text += t
            text += f'\n// end {i}\n'

        text = (
            open('assets/build/typst/superconspect_template.typ', encoding='utf8').read()
                .replace('$conspects$', text)
                .replace('$subject_name$', self.subject_name)
                .replace('$lecturer_name$', self.lecturer_name)
                .replace('$top_level_header$', self.top_level_header)
                .replace('$preamble_location$', preamble_location)
        )
        open(self.superconspect_filename, 'w', encoding='utf8').write(text)

        os.system("python build.py " + str(self.superconspect_filename))
