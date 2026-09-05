from pathlib import Path
from utils import config_class, run_cmd

base_dir = Path(__file__).parent.resolve() / ".."
config = config_class(base_dir)

latex_args = [config.output_engine, f"-jobname={config.output_name}", config.file_name]


def main():
    run_cmd(base_dir, latex_args)


if __name__ == "__main__":
    main()
