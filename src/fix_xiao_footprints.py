#!/usr/bin/env python3
"""
fix_xiao_footprints.py

Restructures Seeed Studio's OPL_Kicad_Library "XIAO Series Library" folder
(which ships as loose .kicad_mod files) into a proper .pretty directory
that KiCad will actually recognize as a footprint library.

Usage:
    python3 fix_xiao_footprints.py /path/to/OPL_Kicad_Library

    # Or, if you're already inside the cloned repo:
    python3 fix_xiao_footprints.py .

What it does:
    1. Finds the "Seeed Studio XIAO Series Library" folder (or lets you
       point it at any folder containing loose .kicad_mod files).
    2. Creates a sibling folder named "XIAO_Series.pretty".
    3. Copies every .kicad_mod file into it (originals are left untouched).
    4. Prints the exact path to add in KiCad's
       Preferences -> Manage Footprint Libraries.

Safe to re-run: it will skip files that are already correctly copied
and won't touch anything outside the folders it creates.
"""

import argparse
import shutil
import sys
from pathlib import Path

DEFAULT_SOURCE_FOLDER_NAME = "Seeed Studio XIAO Series Library"
PRETTY_FOLDER_NAME = "XIAO_Series.pretty"


def find_source_folder(repo_root: Path) -> Path:
    """Locate the XIAO Series Library folder inside the cloned repo."""
    candidate = repo_root / DEFAULT_SOURCE_FOLDER_NAME
    if candidate.is_dir():
        return candidate

    # Fall back: maybe the user pointed us directly at the folder already.
    if repo_root.is_dir() and any(repo_root.glob("*.kicad_mod")):
        return repo_root

    # Last resort: search recursively for a folder with that name.
    matches = list(repo_root.rglob(DEFAULT_SOURCE_FOLDER_NAME))
    if matches:
        return matches[0]

    raise FileNotFoundError(
        f"Could not find '{DEFAULT_SOURCE_FOLDER_NAME}' under {repo_root}.\n"
        f"Point this script directly at the folder containing the .kicad_mod "
        f"files instead, e.g.:\n"
        f"  python3 {Path(__file__).name} \"/path/to/Seeed Studio XIAO Series Library\""
    )


def restructure(source_folder: Path, filter_keyword: str | None) -> Path:
    mod_files = sorted(source_folder.glob("*.kicad_mod"))

    if filter_keyword:
        mod_files = [
            f for f in mod_files if filter_keyword.lower() in f.name.lower()
        ]

    if not mod_files:
        raise FileNotFoundError(
            f"No .kicad_mod files found in {source_folder}"
            + (f" matching '{filter_keyword}'" if filter_keyword else "")
        )

    pretty_folder = source_folder.parent / PRETTY_FOLDER_NAME
    pretty_folder.mkdir(exist_ok=True)

    copied, skipped = [], []
    for mod_file in mod_files:
        dest = pretty_folder / mod_file.name
        if dest.exists() and dest.read_bytes() == mod_file.read_bytes():
            skipped.append(mod_file.name)
            continue
        shutil.copy2(mod_file, dest)
        copied.append(mod_file.name)

    print(f"\nSource folder : {source_folder}")
    print(f"Pretty folder : {pretty_folder}\n")

    if copied:
        print(f"Copied {len(copied)} footprint(s):")
        for name in copied:
            print(f"  + {name}")
    if skipped:
        print(f"\nSkipped {len(skipped)} already up-to-date file(s):")
        for name in skipped:
            print(f"  = {name}")

    print(
        "\nNext step in KiCad:\n"
        "  Preferences -> Manage Footprint Libraries -> Add existing library\n"
        f"  Point it at:\n    {pretty_folder}\n"
    )

    return pretty_folder


def main():
    parser = argparse.ArgumentParser(
        description="Restructure Seeed's loose XIAO .kicad_mod files into a .pretty directory."
    )
    parser.add_argument(
        "repo_path",
        type=Path,
        help="Path to the cloned OPL_Kicad_Library repo, or directly to the "
        "'Seeed Studio XIAO Series Library' folder.",
    )
    parser.add_argument(
        "--filter",
        type=str,
        default=None,
        help="Optional keyword to only copy matching footprints, "
        "e.g. --filter ESP32C6 or --filter ESP32S3",
    )
    args = parser.parse_args()

    repo_root = args.repo_path.expanduser().resolve()
    if not repo_root.exists():
        print(f"Error: path does not exist: {repo_root}", file=sys.stderr)
        sys.exit(1)

    try:
        source_folder = find_source_folder(repo_root)
        restructure(source_folder, args.filter)
    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
