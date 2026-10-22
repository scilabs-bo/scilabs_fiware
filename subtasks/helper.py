import platform
import shutil
import time
import os
from pathlib import Path
from enum import Enum


class ProjectPath(Enum):
    ROOT = Path(__file__).parent.parent
    DOCKER_COMPOSE_STACK = Path(ROOT, "docker-compose", "stack")


def rmDir(path):
    start_time = time.time()

    print(f"# Remove dir: {path}")
    if path.exists() and path.is_dir():
        shutil.rmtree(path)

    end_time = time.time()
    elapsed_time_seconds = end_time - start_time
    print(f"# Done: {elapsed_time_seconds:.1f}s\n")


def rmFile(path):
    start_time = time.time()

    print(f"# Remove file: {path}")
    try:
        os.remove(path)
    except FileNotFoundError:
        pass

    end_time = time.time()
    elapsed_time_seconds = end_time - start_time
    print(f"# Done: {elapsed_time_seconds:.1f}s\n")


def run(c, path, cmd, hideOutput=True):
    start_time = time.time()

    # always use double quotes for windows compatibility
    cmd = cmd.replace("'", '"')

    print(f"# cd {path} && {cmd}")

    with c.cd(path):
        c.run(cmd, pty=platform.system() != "Windows", hide=hideOutput)

    end_time = time.time()
    elapsed_time_seconds = end_time - start_time
    print(f"# Done: {elapsed_time_seconds:.1f}s\n")
