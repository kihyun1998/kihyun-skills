# CLAUDE.md

Guidance for AI agents working in this repository.

## Repository

This repo is a personal collection of Claude Code skills. Each top-level
directory containing a `SKILL.md` is one skill; `scripts/install-skills.ps1`
and `scripts/install-skills.sh` link them into `~/.claude/skills`. See
`README.md` for details.

## Agent skills

### Issue tracker

Issues and PRDs are tracked in this repo's GitHub Issues via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Triage uses the canonical label strings (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.
