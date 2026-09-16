#!/usr/bin/env python3
"""
search_cmds.py — Returns GUI-app commands via desktop file metadata.
Place in .config/quickshell/scripts/search_cmds.py
"""

import subprocess, json, os, sys, fnmatch

APP_DIRS = ["/usr/share/applications", "~/.local/share/applications"]

def desktop_files():
    for d in APP_DIRS:
        d = os.path.expanduser(d)
        if os.path.isdir(d):
            yield from os.scandir(d)

def has_gui_desktop(cmd):
    """Return True if `cmd` is known as a graphical app via desktop file."""
    for f in desktop_files():
        if not f.is_file() or not f.name.endswith(".desktop"):
            continue
        if f.name.lower().find(cmd.lower()) == -1:
            continue
        try:
            with open(f.path, "r", encoding="utf-8", errors="ignore") as fp:
                for line in fp:
                    line = line.strip()
                    if line.startswith("[") or line.startswith("#") or not line:
                        continue
                    if "=" not in line:
                        continue
                    key, _, val = line.partition("=")
                    key, val = key.strip(), val.strip()
                    if key == "NoDisplay" and val.lower() == "true":
                        return False
                    if key in ("Exec", "ExecTry", "Name") and val.lower() == cmd.lower():
                        return True
                    if key in ("Exec", "Name") and fnmatch.fnmatch(cmd.lower(), val.lower()):
                        return True
        except OSError:
            continue
    return False

def scan_commands():
    N = 500
    try:
        proc = subprocess.run(
            ["sh", "-c", f"compgen -c | head -N {N}"],
            capture_output=True, text=True, check=True
        )
        cmds = [line.strip() for line in proc.stdout.splitlines() if line.strip()]
    except subprocess.CalledProcessError:
        cmds = []
        for d in os.environ.get("PATH", "").split(os.pathsep):
            if not os.path.isdir(d):
                continue
            for f in os.listdir(d):
                fp = os.path.join(d, f)
                if os.path.isfile(fp) and os.access(fp, os.X_OK):
                    cmds.append(f)
    return cmds

def main():
    cmds = scan_commands()
    gui = [c for c in cmds if has_gui_desktop(c)]
    print(json.dumps(gui))

if __name__ == "__main__":
    main()
