from pathlib import Path

import yaml

class SuperconspectBuilder:
    def __init__(self, input_folder, blacklist_words=[], output_filename=None):
        self.input_folder = input_folder
        self.output_filename = output_filename
        self.blacklist_words = blacklist_words
        self.subject_info = None

    @property
    def superconspect_filename(self):
        if self.output_filename is None:
            return Path("conspects") / Path(self.input_folder) / (Path(self.input_folder).name + "_superconspect" + self.OUTPUT_EXTENSION)

        return self.output_filename

    @property
    def source_filename(self):
        if self._source_filename is None:
            return Path(self.input_folder) / (Path(self.input_folder).name + "_superconspect" + self.FILE_EXTENSION)

        return self._source_filename

    def build(args):
        raise NotImplementedError()

    def read_subject_info(self):
        subject_info_file = None
        if (Path(self.input_folder) / "subject.yml").exists():
            subject_info_file = Path(self.input_folder) / "subject.yml"
        if (Path(self.input_folder) / "subject.yaml").exists():
            subject_info_file = Path(self.input_folder) / "subject.yaml"

        if subject_info_file is None:
            return
        if self.subject_info is not None:
            return self.subject_info

        with open(subject_info_file, "r", encoding="utf-8") as file:
            data = yaml.safe_load(file)

        self.subject_info = data

        return self.subject_info
