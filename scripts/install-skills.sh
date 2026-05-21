#!/usr/bin/env bash
#
# Symlink every skill in this repo into ~/.claude/skills so Claude Code loads them.
#
# A "skill" is any top-level directory in this repo that contains a SKILL.md.
# For each one, a symlink is created at ~/.claude/skills/<skill-name> pointing
# back into this repo. The repo stays the single source of truth.
#
# Usage:  ./scripts/install-skills.sh

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(dirname "$script_dir")"
skills_home="$HOME/.claude/skills"

mkdir -p "$skills_home"

linked=0
found=0
for dir in "$repo_root"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    found=1
    name="$(basename "$dir")"
    link="$skills_home/$name"
    target="${dir%/}"

    if [ -L "$link" ]; then
        echo "  skip  $name - symlink already exists"
        continue
    fi
    if [ -e "$link" ]; then
        echo "  skip  $name - a real file/folder exists at $link; remove it first" >&2
        continue
    fi

    ln -s "$target" "$link"
    echo "  link  $name -> $target"
    linked=$((linked + 1))
done

if [ "$found" -eq 0 ]; then
    echo "No skills found (no top-level directory contains a SKILL.md)."
    exit 0
fi

echo
echo "Done. $linked skill(s) newly linked into $skills_home."
