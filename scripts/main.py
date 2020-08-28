import time
import shlex
from watchdog.observers import Observer
from pathlib import Path
from change_handler import LaTeXChangeHandler
from utils import config_class, run_cmd

base_dir = Path(__file__).parent.resolve() / '..'
config = config_class(base_dir)

latex_args = [config.output_engine, f"-jobname={config.output_name}", config.file_name]

docker_cmd = ["docker", "compose", "run", "--rm", "converter", shlex.join(latex_args)]


def start_watching(path_to_watch, command):
    # Initialize the event handler and observer
    event_handler = LaTeXChangeHandler(base_dir, command)
    observer = Observer()

    # recursive=True allows monitoring within subdirectories
    observer.schedule(event_handler, path_to_watch, recursive=True)
    observer.start()

    print(f"Now monitoring all .tex files in directory: '{path_to_watch}'")
    print(f"Press Ctrl+C to stop monitoring...")

    try:
        # Keep the main thread alive
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print("\nMonitoring stopped.")

    # Wait until the thread terminates before exiting
    observer.join()


if __name__ == "__main__":
    start_watching(base_dir, docker_cmd)
