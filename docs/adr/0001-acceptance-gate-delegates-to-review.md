# Acceptance Gate delegates its review engine to the `review` skill

The Acceptance Gate does not analyse diffs itself. It drives the `review`
skill — feeding it the fixed point and the spec so `review` does not prompt —
and consumes `review`'s Standards and Spec reports as its input. The Gate adds
only the verdict and the routing/execution layer on top. We chose this over
giving the Gate its own review engine (duplicated logic) or adding an
AFK-specific third axis (more scope): delegation keeps the analysis in one
place, so when `review` improves, the Gate improves with it.

## Consequences

- The Acceptance Gate hard-depends on the `review` skill being installed.
  Installing the Gate alone — without `review` in `~/.claude/skills` — breaks
  it. This dependency is not visible from the Gate's own `SKILL.md`.
- The Gate's verdict accuracy is bounded by `review`'s reporting discipline.
  The Rework-vs-Respec split keys off whether `review`'s Spec sub-agent cited a
  spec line; if `review` omits a citation, the Gate can misroute. The spec
  handles this with an explicit fallback (treat malformed `review` output as
  Escalate).
