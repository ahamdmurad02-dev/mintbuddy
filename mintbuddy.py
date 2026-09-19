#!/usr/bin/env python3
"""MintBuddy — a simple local helper app for Linux Mint."""

from __future__ import annotations

import json
import os
import platform
import shutil
import socket
import subprocess
import sys
import webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parent
WEB = ROOT / "web"
HOST = "127.0.0.1"
PORT = 8765


def _run(cmd: list[str]) -> str:
    try:
        out = subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)
        return out.strip()
    except Exception:
        return ""


def system_info() -> dict[str, str]:
    uname = platform.uname()
    pretty = ""
    os_release = Path("/etc/os-release")
    if os_release.exists():
        data = {}
        for line in os_release.read_text(errors="ignore").splitlines():
            if "=" in line:
                key, value = line.split("=", 1)
                data[key] = value.strip().strip('"')
        pretty = data.get("PRETTY_NAME", "")

    mem = ""
    meminfo = Path("/proc/meminfo")
    if meminfo.exists():
        kb = {}
        for line in meminfo.read_text().splitlines():
            parts = line.replace(":", " ").split()
            if len(parts) >= 2 and parts[1].isdigit():
                kb[parts[0]] = int(parts[1])
        if "MemTotal" in kb:
            total_gb = kb["MemTotal"] / 1024 / 1024
            avail_gb = kb.get("MemAvailable", 0) / 1024 / 1024
            mem = f"{avail_gb:.1f} GB free of {total_gb:.1f} GB"

    disk = shutil.disk_usage(Path.home())
    disk_txt = f"{disk.free / 2**30:.1f} GB free of {disk.total / 2**30:.1f} GB"

    desktop = os.environ.get("XDG_CURRENT_DESKTOP") or os.environ.get("DESKTOP_SESSION") or "Unknown"

    return {
        "Computer name": socket.gethostname(),
        "User": os.environ.get("USER", Path.home().name),
        "System": pretty or f"{uname.system} {uname.release}",
        "Desktop": desktop,
        "Processor": uname.processor or uname.machine,
        "Memory": mem or "Not available",
        "Home disk": disk_txt,
        "Home folder": str(Path.home()),
        "Python": platform.python_version(),
    }


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB), **kwargs)

    def log_message(self, format: str, *args) -> None:
        sys.stderr.write("[mintbuddy] " + (format % args) + "\n")

    def do_GET(self) -> None:
        if self.path == "/api/sysinfo":
            payload = json.dumps(system_info()).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
            return
        if self.path in ("/", "/index.html"):
            self.path = "/index.html"
        return super().do_GET()


def find_port(start: int = PORT) -> int:
    for port in range(start, start + 20):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                sock.bind((HOST, port))
                return port
            except OSError:
                continue
    raise RuntimeError("Could not find a free local port")


def main() -> int:
    if not (WEB / "index.html").exists():
        print("Missing web/index.html next to mintbuddy.py", file=sys.stderr)
        return 1

    port = find_port()
    url = f"http://{HOST}:{port}/"
    server = ThreadingHTTPServer((HOST, port), Handler)
    print(f"MintBuddy is running at {url}")
    print("Leave this window open. Press Ctrl+C to stop.")
    try:
        webbrowser.open(url)
    except Exception:
        pass
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nMintBuddy stopped.")
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
