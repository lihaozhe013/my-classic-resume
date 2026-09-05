from pathlib import Path
from utils import run_cmd


def format_tex_files():
    base_dir = Path(__file__).resolve().parent / ".."

    print("Finding and formatting all .tex files...")
    tex_files = []
    for filepath in base_dir.rglob("*.tex"):
        rel_path = f"./{filepath.relative_to(base_dir)}"
        tex_files.append(rel_path)

    if tex_files:
        cmds = ["latexindent", "-s", "-w"] + tex_files

        run_cmd(str(base_dir), cmds)

    for filepath in base_dir.rglob("*.bak0"):
        filepath.unlink()

    print("All .tex files formatted.")


if __name__ == "__main__":
    format_tex_files()
