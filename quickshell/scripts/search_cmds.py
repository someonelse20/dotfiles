#!/usr/bin/env python3
"""
search_cmds.py

Scans PATH and emits a JSON list of shell commands.
Useful as the backend for a QML search popup.
"""

import subprocess
import json
import os
import sys


def get_path_dirs():
    """Yield each directory in PATH."""
    path_dirs = os.environ.get("PATH", "")
    if not path_dirs:
        return
    for d in path_dirs.split(os.pathsep):
        d = d.strip()
        if d:
            yield d


def scan_commands():
    """
    Use compgen -c to get a list of valid shell commands.
    This reads from stdin and outputs each command on its own line.
    We pipe it through head -N to keep the list small enough for UI.
    """
    N = 500  # tweak to your taste
    try:
        # compgen -c outputs commands known to the shell
        proc = subprocess.run(
            ["sh", "-c", f"compgen -c | head -N {N}"],
            capture_output=True,
            text=True,
            check=True,
        )
        return [line.strip() for line in proc.stdout.splitlines() if line.strip()]
    except subprocess.CalledProcessError as e:
        # Fallback to listing binaries in PATH if compgen fails
        cmds = []
        for d in get_path_dirs():
            if not os.path.isdir(d):
                continue
            for f in os.listdir(d):
                fpath = os.path.join(d, f)
                if os.path.isfile(fpath) and os.access(fpath, os.X_OK):
                    cmds.append(f)
        return cmds[:N]


def main():
    cmds = scan_commands()
    print(json.dumps(cmds))
    sys.exit(0)


if __name__ == "__main__":
    main()
