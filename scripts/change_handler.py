import time
from utils import run_cmd
from watchdog.observers import Observer
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


def start_watching(path_to_watch, command):
    # Initialize the event handler and observer
    event_handler = LaTeXChangeHandler(command)
    observer = Observer()

    # recursive=True allows monitoring within subdirectories
    observer.schedule(event_handler, path_to_watch, recursive=True)
    observer.start()

    print(f"👀 Now monitoring all .md files in directory: '{path_to_watch}'")
    print(f"💡 Press Ctrl+C to stop monitoring...")

    try:
        # Keep the main thread alive
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print("\nMonitoring stopped.")

    # Wait until the thread terminates before exiting
    observer.join()
