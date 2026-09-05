import shutil
import tempfile
import shlex
import subprocess
from pathlib import Path

def run_cmd(work_dir, command):
    print(f"Running Command: {shlex.join(str(arg) for arg in command)}")
    subprocess.run(command, cwd=work_dir, check=True)

def format_tex_files():
    base_dir = Path(__file__).resolve().parent

    print("Finding and formatting all .tex files...")
    tex_files = [
        f"./{filepath.relative_to(base_dir)}"
        for filepath in base_dir.rglob("*.tex")
    ]

    if tex_files:
        cruft_dir = tempfile.mkdtemp(prefix="latexindent-")
        cmds = [
            "latexindent",
            "-s",
            "-w",
            "-m",
            "-l", "indentconfig.yaml",
            "-c", cruft_dir,
        ] + tex_files

        run_cmd(str(base_dir), cmds)
        shutil.rmtree(cruft_dir, ignore_errors=True)

    print("All .tex files formatted.")

if __name__ == "__main__":
    format_tex_files()
