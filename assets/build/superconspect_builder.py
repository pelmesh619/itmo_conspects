from pathlib import Path

class SuperconspectBuilder:
    def __init__(self, input_folder, blacklist_words=[], output_filename=None):
        self.input_folder = input_folder
        self.output_filename = output_filename
        self.blacklist_words = blacklist_words

    @property
    def superconspect_filename(self):
        if self.output_filename is None:
            return Path(self.input_folder) / (Path(self.input_folder).name + "_superconspect" + self.FILE_EXTENSION)

        return self.output_filename

    def build(args):
        raise NotImplementedError()
