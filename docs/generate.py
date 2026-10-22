#!/usr/bin/python3

import shutil
import subprocess
from pathlib import Path

SRC_PATH = Path("docs")
DEST_PATH = Path("artifacts", "docs")


def run(cmd):
    completed_process = subprocess.run(cmd, shell=True)
    try:
        completed_process.check_returncode()
    except subprocess.CalledProcessError as e:
        exit(e)


def copyFolderContent(srcFolder):
    files = [path for path in srcFolder.rglob("*.*")]
    for file in files:
        destPath = Path(DEST_PATH, file.name).resolve()
        shutil.copyfile(file, destPath)
        print(f"Kopiere {file} nach {DEST_PATH}")


def convertFile(srcFile, outputExtension):
    pngPath = Path(DEST_PATH, srcFile.parent.name)
    pngFile = Path(pngPath, srcFile.name)

    if srcFile.name == "README.md":
        destFileName = f"{srcFile.parent.name}.{outputExtension}"
    else:
        destFileName = f"{srcFile.stem}.{outputExtension}"

    destPath = Path(DEST_PATH, destFileName).resolve()
    puppeteerConfigFile = Path("docs", "puppeteer.json")

    pngPath.mkdir(parents=True, exist_ok=True)
    copyFolderContent(Path(DEST_PATH, srcFile.parent.name))
    print(f"Verarbeite mit mmdc: {srcFile}")
    run(
        f'mmdc -i "{srcFile}" --outputFormat=png -o "{pngFile}" --puppeteerConfigFile "{puppeteerConfigFile}"'
    )
    print(f"Verarbeite mit pandoc in: {pngPath}")

    pandoc_cmd = f'cd "{pngPath}" && pandoc "{srcFile.name}" -o "{destPath}"'

    run(pandoc_cmd)
    # shutil.rmtree(pngPath)


shutil.rmtree(DEST_PATH, ignore_errors=True)
DEST_PATH.mkdir(parents=True, exist_ok=True)

markdownFiles = [path for path in SRC_PATH.rglob("*.md")]
pdfFiles = [path for path in SRC_PATH.rglob("*.pdf")]

for srcFile in markdownFiles:
    convertFile(srcFile, "docx")

for srcFile in pdfFiles:
    run(f'cp "{srcFile}" "{DEST_PATH}"/')
