# kihyun-skills

Personal collection of [Claude Code](https://claude.com/claude-code) skills.

Each top-level folder containing a `SKILL.md` is one skill. This repo is the
single source of truth; skills become active by symlinking them into
`~/.claude/skills`, where Claude Code discovers them.

## Skills

| Skill | What it does |
| --- | --- |
| [`to-html`](to-html/) | Convert a markdown file — or content already in the conversation — into a single self-contained, styled HTML file: inline CSS, sticky table of contents, callouts, premium layout blocks. No build step. |

## Install

Symlink every skill in this repo into `~/.claude/skills`:

```sh
# Windows (PowerShell) — needs Developer Mode or an elevated shell to create symlinks
powershell -File .\scripts\install-skills.ps1

# macOS / Linux / WSL / git-bash
./scripts/install-skills.sh
```

Both scripts scan the repo for every folder containing a `SKILL.md`, so new
skills are picked up automatically on re-run. Because they create symlinks
(not copies), edits made in this repo are live in Claude Code immediately.

## Adding a skill

1. Create a folder at the repo root containing a `SKILL.md`. Use the
   `write-a-skill` skill, or copy `to-html/` as a template.
2. Re-run the install script to symlink the new skill.

## Repo layout

```
.
├── scripts/        install scripts — symlink skills into ~/.claude/skills
├── docs/agents/    config the Matt Pocock engineering skills read for this repo
├── CLAUDE.md       guidance auto-loaded by Claude Code when working in this repo
└── <skill>/        one folder per skill, each with a SKILL.md
```
