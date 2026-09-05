from utils import run_cmd
from watchdog.events import FileSystemEventHandler


class LaTeXChangeHandler(FileSystemEventHandler):
    def __init__(self, base_dir, command_to_run):
        self.command_to_run = command_to_run
        self.base_dir = base_dir

    def on_modified(self, event):
        # 1. Ignore directory modifications
        # 2. Check if the file path ends with .tex (case-insensitive)
        if not event.is_directory and event.src_path.lower().endswith(".tex"):
            print(f"\n[Change Detected] LaTeX file modified: {event.src_path}")
            print(f"[Executing Command] Running: {self.command_to_run}")

            # Execute the shell command
            run_cmd(self.base_dir, self.command_to_run)
