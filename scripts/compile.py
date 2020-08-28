from pathlib import Path
import shlex
from utils import config_class, run_cmd

base_dir = Path(__file__).parent.resolve() / ".."
config = config_class(base_dir)

latex_args = [config.output_engine, f"-jobname={config.output_name}", config.file_name]

docker_cmd = ["docker", "compose", "run", "--rm", "converter", shlex.join(latex_args)]


def main():
    run_cmd(base_dir, docker_cmd)


if __name__ == "__main__":
    main()
