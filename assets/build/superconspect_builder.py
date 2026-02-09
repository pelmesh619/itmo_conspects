class SuperconspectBuilder:
    def __init__(self, input_folder, blacklist_words=[], output_filename=None):
        self.input_folder = input_folder
        self.output_filename = output_filename
        self.blacklist_words = blacklist_words

