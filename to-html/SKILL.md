---
name: to-html
description: Convert a markdown file — or documentation already in the conversation context — into one self-contained, styled HTML file. Output has inline CSS, a sticky table of contents, GitHub-style callouts, and optional premium layout blocks; zero external dependencies, no build step, opens directly in a browser. Use when the user wants to turn a guide, setup doc, reference, README, or technical notes into a polished HTML page, asks to "make this HTML" / "export to HTML", or invokes /to-html. Not for slide decks or presentations, and not for narrative re-authoring — this skill does structural conversion of general documentation, not a rewrite.
---

# to-html

Convert documentation into a single, self-contained, styled HTML file using the bundled house style.

## Input

One of:

- **A markdown file** — the user gives a path. Read it.
- **In-context content** — a document you drafted, notes, or material from the current conversation that the user wants captured as HTML.

## Output

**One `.html` file.** CSS inlined, zero external dependencies, no build step — it opens directly in a browser. You perform the conversion yourself (no `marked`, no `pandoc`): doing the standard conversion and the premium-element judgment in one pass is the whole point.

## Scope — read before converting

In scope: guides, setup docs, references, READMEs, technical documentation — content already shaped as a document.

Out of scope — stop and say so instead of converting:

- **Slide decks / presentations** — a different layout model entirely.
- **Narrative re-authoring** — reshaping content into a story or argument. That needs hand re-writing, not structural conversion. This skill preserves the document's structure; it does not rewrite it.

## Process

1. **Get the source.** A file path → Read it. Otherwise gather the in-context content the user pointed at.
2. **Read the bundled assets:** `assets/style.css` (the canonical stylesheet) and `REFERENCE.md` (page skeleton + exact component markup). Always read `REFERENCE.md` — do not reconstruct markup from memory.
3. **Strip non-document noise.** Drop conversational scaffolding that is not part of the document — e.g. a "Sure, here's the doc…" preamble, a trailing "want me to also…?". Convert the document, not the chat around it.
4. **Detect language** and set `<html lang="…">` (e.g. `ko`, `en`). The bundled font stack already covers Korean and Latin — no web fonts needed.
5. **Convert the standard markdown** — see Conversion rules.
6. **Decide on premium elements** — see Premium elements. This is judgment, not a mechanical mapping.
7. **Build the TOC** from the h2/h3 headings, nested.
8. **Assemble** the skeleton from `REFERENCE.md` and inline the entire stylesheet into one `<style>` block.
9. **Write** the `.html` file (next to the source file, or where the user asks) and tell the user the path.

## Conversion rules

| Markdown | HTML |
|---|---|
| H1 / frontmatter title (+ subtitle) | `.page-header` — `<h1>` plus optional `.subtitle` |
| h2, h3 | `<h2>` / `<h3>` with stable `id`s; also feed the TOC |
| paragraphs, lists, tables, code blocks, inline code, links, blockquotes | plain semantic HTML — the stylesheet does the styling |
| `> [!NOTE]` | `.callout.info` |
| `> [!TIP]` | `.callout.tip` |
| `> [!WARNING]` | `.callout.warn` |
| `> [!CAUTION]` | `.callout.danger` |

If the document has no H1, derive the page-header title from the first top-level heading or the filename, and omit the subtitle. Always escape `<`, `>`, `&` in code blocks and text — see `REFERENCE.md`.

## Premium elements — apply judgment

The stylesheet ships richer components. Use one **only when the content clearly calls for it**. Never force them, and never emit one just because some markdown syntax is present.

- `.step-block` (numbered circle) — a genuinely sequential procedure.
- `.badge` — short inline keyword / status tags.
- `.two-col` — two parallel, directly comparable blocks.
- `.overview` diagram — a two-side system/structure overview, when the document opens by describing one.

Hand-author these from `REFERENCE.md`. If nothing in the content calls for them, a clean document with callouts and a TOC is the correct result.

## Constraints

- Single file — inline the CSS, never `<link>` it.
- Keep the bundled light palette. Dark mode is out of scope for now.
- Do not edit `assets/style.css` to fit one document — it is the canonical house style.
