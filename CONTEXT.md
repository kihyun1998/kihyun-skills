# kihyun-skills

A personal collection of Claude Code skills. Each skill is one self-contained
unit of agent capability; this repo is their single source of truth.

## Language

**Skill**:
A self-contained unit of agent capability — a folder containing a `SKILL.md`,
symlinked into `~/.claude/skills` to become active.

**AFK agent**:
An autonomous agent that picks up an issue labelled `ready-for-agent` and
implements it with no human present.
_Avoid_: bot, worker

**Acceptance Gate**:
A skill that reviews an AFK agent's finished output, issues a verdict with a
recommended next action, and — once the user approves — executes that action
on the issue tracker.
_Avoid_: review agent (collides with the `review` skill)

**Verdict**:
The Acceptance Gate's judgement of an AFK agent's output — one of **Pass**
(work accepted), **Rework** (the AFK agent missed something fixable),
**Respec** (the issue itself was underspecified), or **Escalate** (the work
needs a human).

## Relationships

- An **AFK agent** produces work in response to one **issue**; the
  **Acceptance Gate** judges that work against the same issue.
- Each **Verdict** maps to a triage outcome: Pass → issue closed; Rework →
  `ready-for-agent` re-applied; Respec → `needs-info`; Escalate →
  `ready-for-human`.
- The **Acceptance Gate** is distinct from the **`review` skill**: `review`
  only produces a two-axis report; the Acceptance Gate adds the verdict, the
  next action, and — on approval — its execution.

## Example dialogue

> **Dev:** "The AFK agent finished issue #12 — do I just run the `review`
> skill on the branch?"
> **Maintainer:** "`review` tells you *what's wrong*, but it stops at a
> report. The **Acceptance Gate** reads that, decides pass or rework, and — if
> you approve — bounces the issue back to the AFK agent with fix notes or
> escalates it to `ready-for-human`."

## Flagged ambiguities

- "review agent" was used to mean both the existing **`review` skill** and the
  new **Acceptance Gate** — resolved: these are distinct. `review` reports;
  the Acceptance Gate judges and acts.
