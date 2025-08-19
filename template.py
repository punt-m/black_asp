"""
Juno template
Authors: Karim Hajji, Roxanne Wolthuis
Organization: Rijksinstituut voor Volksgezondheid en Milieu (RIVM)
Department: Infektieziekteonderzoek, Diagnostiek en Laboratorium
            Surveillance (IDS), Bacteriologie (BPD)     
Date: 05-04-2023   
"""

from pathlib import Path
import pathlib
import yaml
import argparse
import sys
from dataclasses import dataclass, field
from juno_library import Pipeline
from typing import Optional
from version import __package_name__, __version__, __description__

def main() -> None:
    juno_template = JunoTemplate()
    juno_template.run()
    
@dataclass
class JunoTemplate(Pipeline):
    pipeline_name: str = __package_name__
    pipeline_version: str = __version__
    input_type: str = "fastq"

    def _add_args_to_parser(self) -> None:
        super()._add_args_to_parser()

        self.parser.description = "Template juno pipeline. If you see this message please change it to something appropriate"
        
        self.add_argument(
            "--db-dir",
            type=Path,
            nargs = "+",
            default="/mnt/scratch_dir/puntm/",
            metavar="DIR",
            help="Dirs to bind in singularity",
        )

        self.add_argument(
            "-mpt",
            "--mean-quality-threshold",
            type=int,
            metavar="INT",
            default=28,
            help="Phred score to be used as threshold for cleaning (filtering) fastq files.",
        )
        self.add_argument(
            "-ws",
            "--window-size",
            type=int,
            metavar="INT",
            default=5,
            help="Window size to use for cleaning (filtering) fastq files.",
        )
        self.add_argument(
            "-ml",
            "--minimum-length",
            type=int,
            metavar="INT",
            default=50,
            help="Minimum length for fastq reads to be kept after trimming.",
        )
        self.add_argument(
            "-c",
            "--conda",
            action = "store_true",
            default=False,
            help="Force conda use, default is off",
        )
        
    def _parse_args(self) -> argparse.Namespace:
        args = super()._parse_args()

        # Optional arguments are loaded into self here
        self.db_dir: Path = args.db_dir
        self.mean_quality_threshold: int = args.mean_quality_threshold
        self.window_size: int = args.window_size
        self.min_read_length: int = args.minimum_length
        self.conda: str = args.conda


        return args
    
    # Extra class methods for this pipeline can be defined here
    
    def setup(self) -> None:
        super().setup()
        
        if self.snakemake_args["use_singularity"]:
            self.snakemake_args["singularity_args"] = " ".join(
                [
                    self.snakemake_args["singularity_args"],
                    f"--bind {self.db_dir}:{self.db_dir}",
                    f"--nv",
                ] # paths that singularity should be able to read from can be bound by adding to the above list
            )
        if self.conda:
            self.snakemake_args["use_conda"] = True

        # Extra class methods for this pipeline can be invoked here
        with open(
            Path(__file__).parent.joinpath("config/pipeline_parameters.yaml")
        ) as f:
            parameters_dict = yaml.safe_load(f)
        self.snakemake_config.update(parameters_dict)
        
        #Read custom parameters as well: 
        with open(
            Path(__file__).parent.joinpath("config/config_params.yml")
        ) as f:
            params_dict = yaml.safe_load(f)
        self.snakemake_config.update(params_dict)

        self.user_parameters = {
            "input_dir": str(self.input_dir),
            "output_dir": str(self.output_dir),
            "db_dir": str(self.db_dir),
            "mean_quality_threshold": int(self.mean_quality_threshold),
            "window_size": int(self.window_size),
            "min_read_length": int(self.min_read_length),
            "exclusion_file": str(self.exclusion_file),
            "use_singularity": str(self.snakemake_args["use_singularity"]),
            'use_conda':str(self.conda),
        }
        print(self.snakemake_args)
        print(self.user_parameters)


if __name__ == "__main__":
    main()
