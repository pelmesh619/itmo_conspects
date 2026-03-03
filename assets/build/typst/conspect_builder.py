import os
import re
import time
from pathlib import Path

from assets.build.conspect_builder import ConspectBuilder


class TypstConspectBuilder(ConspectBuilder):
    def __init__(self, input_filename, output_filename):
        super().__init__(input_filename, output_filename)

    @property
    def conspect_filename(self):
        if self.output_filename is None:
            return Path("conspects") / Path(self.input_filename).parent / (Path(self.input_filename).stem + ".pdf")

        return self.output_filename


    def build(self, args):
        print(f'\n\033[96mCompiling {self.input_filename}...\033[0m')

        start_time = time.time()

        command = (
            f"typst {'compile' if not getattr(args, "watch", False) else 'watch'} "
            f"{self.input_filename} "
            f"{self.conspect_filename} "
            f"--root . "
        )

        exit_code = self.run(command)

        if not getattr(args, "watch", False):
            if exit_code == 0:
                print(f'\033[92mCompilation of {self.conspect_filename} completed in {round(time.time() - start_time, 2)} s!\033[0m')
            else:
                print(f'\033[91mCompilation of {self.conspect_filename} failed\033[0m')
            return exit_code
