import os

class ConspectBuilder:
    def __init__(self, input_filename, output_filename=None):
        self.input_filename = input_filename
        self.output_filename = output_filename

    def build(args):
        raise NotImplementedError()
        
    def run(self, command):
        print(f"\033[92mRunning: {command}\033[0m")

        return os.system(command)
