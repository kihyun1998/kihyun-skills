# to-html — HTML reference

Exact markup for the house style. Read this file every time you convert — do not reconstruct it from memory. Every class below is defined in `assets/style.css`; use the classes, never redefine styles inline.

## Page skeleton

```html
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DOCUMENT TITLE</title>
<style>
/* Inline the FULL contents of assets/style.css here, verbatim. */
</style>
</head>
<body>

<div class="layout">

<header class="page-header">
  <h1>DOCUMENT TITLE</h1>
  <p class="subtitle">One-line subtitle — omit this line if there is none.</p>
</header>

<aside class="toc">
  <h2>목차</h2>
  <ol><!-- TOC entries --></ol>
</aside>

<main>
  <!-- converted document body -->
</main>

<footer class="page-footer">
  Generated from SOURCE.md
</footer>

</div>

</body>
</html>
```

Notes:

- `<meta charset="UTF-8">` is mandatory — Korean text corrupts without it.
- `<html lang="…">` follows the document's language (`ko`, `en`, …).
- The 4-column grid (`.layout`) is created entirely by CSS. Emit exactly these four children: `header.page-header`, `aside.toc`, `main`, `footer.page-footer`. Below 1100px the TOC column collapses automatically.
- TOC heading label follows the document language: `목차` for Korean, `Contents` for English.
- The footer is optional — a short provenance line, or omit it.

## Page header

```html
<header class="page-header">
  <h1>SSH CA 인증서 설정 가이드</h1>
  <p class="subtitle">Short descriptive subtitle, inline <code>code</code> allowed.</p>
</header>
```

Optional nav-links row — include **only** if the source links to sibling documents or the user asks:

```html
<div class="nav-links">
  <a href="OTHER.html">← 개념 가이드</a>
  <a href="#overview">전체 그림 ↓</a>
</div>
```

## Table of contents

`h2` → a top-level `<li>`. `h3` → a nested `<li class="sub">`. Every `href` must match the `id` of its heading.

```html
<aside class="toc">
  <h2>목차</h2>
  <ol>
    <li><a href="#sec-1">1. First section</a>
      <ol>
        <li class="sub"><a href="#sec-1-1">1-1. Subsection</a></li>
        <li class="sub"><a href="#sec-1-2">1-2. Subsection</a></li>
      </ol>
    </li>
    <li><a href="#sec-2">2. Second section</a></li>
  </ol>
</aside>
```

## Sections and headings

Wrap each `h2` and its content in a `<section>` that carries the `id`. Give each `h3` its own `id`. Use short ASCII ids (`sec-1`, `sec-1-2`) — they stay stable and resolve reliably even for Korean headings.

```html
<section id="sec-1">
<h2>1. First section</h2>

<h3 id="sec-1-1">1-1. Subsection</h3>
<p>Body text. <code>inline code</code>, <strong>bold</strong>, <a href="...">links</a>.</p>

<h4>Minor heading</h4>
</section>
```

`<h4>` needs no `id` and does not appear in the TOC.

## Callouts

Maps from GitHub alert syntax. Four variants: `info`, `tip`, `warn`, `danger`.

Without a title — body goes straight inside:

```html
<div class="callout info">
  Plain body text, or wrap multiple paragraphs in <code>&lt;p&gt;</code>.
</div>
```

With a title — `.callout-title` is the bold header line; an emoji prefix is fine:

```html
<div class="callout warn">
  <div class="callout-title">⚠ Version pitfall</div>
  <p>First paragraph.</p>
  <p>Second paragraph.</p>
</div>
```

`pre`, `ul`, and `p` all nest cleanly inside a callout.

## Code blocks

Use `<pre><code>`. **Escape `<` → `&lt;`, `>` → `&gt;`, `&` → `&amp;`** inside code (and anywhere in body text).

```html
<pre><code>ssh-keygen -t ed25519 -f C:\ca\my-ca -N ""</code></pre>
```

Optional, light syntax tinting — wrap parts in spans. Use sparingly; plain code blocks are fine.

```html
<pre><code><span class="comment"># a comment line</span>
winrm quickconfig -q</code></pre>
```

Available span classes: `.comment` (muted), `.key` (blue), `.val` (amber), `.str` (green). Inline `<code>` needs no spans.

## Tables

Plain `<table>` with `<thead>` / `<tbody>` — the stylesheet handles borders, header shading, and row hover.

```html
<table>
<thead><tr><th>Column</th><th>Meaning</th></tr></thead>
<tbody>
<tr><td><code>-N ""</code></td><td>Empty passphrase</td></tr>
</tbody>
</table>
```

If a source markdown table row is malformed (e.g. an unescaped `|` inside a cell), reconstruct the intended row rather than copying the breakage.

---

# Premium elements

Hand-authored. Use only when the content clearly calls for it (see SKILL.md).

## Step block

For a sequential procedure. The numbered circle is `.step-num`; put the `id` on the `.step-block` so the TOC can link to it.

```html
<div class="step-block" id="sec-1-1">
  <h3 class="step-block-title"><span class="step-num">1</span>Create the working folder</h3>
  <p>Explanation.</p>
<pre><code>New-Item -ItemType Directory -Path C:\ca -Force</code></pre>
  <div class="callout info">A callout nests fine inside a step block.</div>
</div>
```

## Badge

Short inline tag. Three color slots — named for the reference doc's SSH domain, but treat them as a palette: `priv` = red, `pub` = green, `cert` = purple. Pick by meaning (critical → `priv`, safe/success → `pub`, special/identity → `cert`).

```html
<span class="badge priv">CA private key</span>
<span class="badge pub">public key</span>
<span class="badge cert">certificate</span>
```

## Two-column

Two parallel, directly comparable blocks. Collapses to one column on narrow screens.

```html
<div class="two-col">
  <div>
    <h4>Option A</h4>
    <p>…</p>
  </div>
  <div>
    <h4>Option B</h4>
    <p>…</p>
  </div>
</div>
```

## Overview diagram

Rarely applicable — only when the document opens by describing a two-side system/flow (e.g. client ↔ server). Two `.overview-card`s with a flow arrow between them, then an `.overview-caption`.

```html
<div class="overview">
  <div class="overview-card client">
    <div class="overview-card-title">CLIENT (Windows)</div>
    <div class="file-list">
      <div class="file-item priv">
        <span class="file-name">my-ca</span>
        <span></span>
        <span class="file-tag">CA private key</span>
      </div>
      <div class="file-item pub">
        <span class="file-name">my-ca.pub</span>
        <span></span>
        <span class="file-tag">CA public key</span>
      </div>
    </div>
  </div>

  <div class="overview-flow">
    <span class="overview-flow-label">copy<br>CA pubkey</span>
    <svg width="60" height="40" viewBox="0 0 60 40">
      <defs>
        <marker id="arrowR" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <polygon points="0 0, 10 3, 0 6" fill="#2563eb"/>
        </marker>
      </defs>
      <line x1="2" y1="20" x2="52" y2="20" stroke="#2563eb" stroke-width="2.5" marker-end="url(#arrowR)"/>
    </svg>
  </div>

  <div class="overview-card server">
    <div class="overview-card-title">SERVER (Linux)</div>
    <div class="file-list">
      <div class="file-item config">
        <span class="file-name">sshd_config</span>
        <span></span>
        <span class="file-tag">TrustedUserCAKeys</span>
      </div>
    </div>
  </div>
</div>

<div class="overview-caption">
  <strong>Key flow</strong> — one-line summary of what the diagram shows.
</div>
```

`.overview-card` color variants: `client` (blue), `server` (orange). `.file-item` color variants: `priv` (red), `pub` (green), `cert` (purple), `config` (grey). The middle `<span></span>` in a `.file-item` is an intentional empty grid cell — keep it.
