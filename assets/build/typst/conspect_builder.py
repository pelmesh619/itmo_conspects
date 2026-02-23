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
        print(f'Compiling {self.input_filename}...\n')

        start_time = time.time()

        exit_code = os.system(
            f"typst {'compile' if not args.watch else 'watch'} "
            f"{self.input_filename} "
            f"{self.conspect_filename} "
            f"--root . "
        )

        if not args.watch:
            if exit_code == 0:
                print(f'Compilation of {self.conspect_filename} completed in {round(time.time() - start_time, 2)} s!')
            else:
                print(f'Compilation of {self.conspect_filename} failed')
