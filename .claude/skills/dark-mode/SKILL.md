---
name: dark-mode
description: Migrate hardcoded colours in the Presidium SCSS to the host application's dark-mode CSS custom properties, using var(--token, light-fallback). Use when asked to add or extend dark mode support, tokenise colours, replace hardcoded hex/white/black/grey values with theme variables, or audit which colours still need migrating in assets/_sass.
---

# Dark mode migration

The host application injects a set of CSS custom properties at runtime and swaps them by
adding `.dark` to an ancestor element. This repo's job is to stop hardcoding colours and
start reading those tokens, with a light-theme literal as the fallback for consumers where
the host does not inject them.

```scss
background-color: #ffffff;                 →  background-color: var(--background, rgba(255, 255, 255, 1));
border-bottom: 1px solid #e5e7eb;          →  border-bottom: 1px solid var(--border, rgba(229, 229, 229, 1));
```

Two rules govern every edit:

1. **Always supply a fallback.** No bare `var(--background)`.
2. **The fallback is the light value of that token**, not the colour that was there before.
   Copy it verbatim from `references/tokens.md` — `#e5e7eb` becomes
   `rgba(229, 229, 229, 1)`, not `#e5e7eb`. This is a deliberate, small visual change to
   light mode.

## Scope

In scope: colours that are white, black or greyscale, and any strongly tinted colour that
is very light or very dark. Saturated brand colours are out of scope unless the request
says otherwise.

`assets/_sass/bootstrap/` is vendored third-party code and is never edited in place.

## Workflow

### 1. Establish the contract

Before editing, confirm with the user (unless already settled in this session):

- Which element carries `.dark` — `<html>` or `<body>`? Existing rules hedge with
  `&.dark, .dark &`, which works either way but is noise if the answer is known.
- Should `prefers-color-scheme: dark` apply on its own, or does the host own the toggle
  entirely? As the tokens are written, an OS-dark user sees light until the host acts.
- Which files or components are in this pass. The full tree is roughly 60 priority
  findings plus a vendored Bootstrap surface; a single PR covering all of it is hard to
  review.

### 2. Audit

```bash
.claude/skills/dark-mode/scripts/audit-colors.sh                    # whole tree
.claude/skills/dark-mode/scripts/audit-colors.sh assets/_sass/components/left-nav
```

Output buckets:

- `PRIORITY` — greyscale, near-white or near-black literals. These are the work.
- `BLOCKED` — a literal or Sass variable feeding a Sass colour function. `var()` will not
  compile there; see §3 of `references/mapping.md`.
- `SCRIM` — translucent black/white overlays and shadows. Leave them.
- `OTHER` — saturated colours. Skip unless asked.
- `GREYSCALE SASS VARIABLES` — variable definitions with usage counts. Tokenising the
  definition covers every call site at once; call sites referencing a variable never
  appear in `PRIORITY`.

### 3. Map each finding to a token

Read `references/mapping.md` §1 — it maps by *role* (surface, text, line) rather than by
hex, and includes a resolved table for every hardcoded value already in this repo.

Pull fallback values from `references/tokens.md`. Note the misspelled
`--success-quarternary` / `--warning-quarternary` / `--info-quarternary` /
`--destructive-quarternary`; use them exactly as written.

### 4. Apply

Match the existing style — `var(--token, fallback)` inline in the declaration, no new
wrapper mixins or intermediate Sass variables. Existing migrated code lives in
`assets/_sass/_structure.scss`, `assets/_sass/components/title-bar/_structure.scss` and
`assets/_sass/components/left-nav/_structure.scss`.

Where a migrated line already exists with a stale fallback, bring it in line at the same
time — e.g. `var(--background, black)` and `var(--border, $border)` in `_structure.scss`
predate this rule.

Handle the special cases from `references/mapping.md` as you meet them:

- §3 Sass colour functions — `var()` is a build error inside `darken()` / `rgba($c, .1)`.
- §4 Inverted surfaces — pair an inverting background token with an inverting text token.
- §5 Do-not-tokenise list.
- §6 Vendored Bootstrap — override after the import, never edit upstream files.

### 5. Flag what CSS cannot fix

`references/mapping.md` §7-§9 covers syntax highlighting, Mermaid, icon assets, print
output and `color-scheme`. Do not attempt these as part of a mechanical pass; list them in
the PR description as follow-up work. Syntax highlighting, print output, `color-scheme` and
Mermaid have since been handled — read §7-§9 for how, rather than reworking them.

### 6. Verify

```bash
yarn lint                                                   # stylelint + prettier
.claude/skills/dark-mode/scripts/audit-colors.sh            # confirm PRIORITY shrank as expected
```

There is no Sass compiler in this repo — it is a Hugo theme compiled by the consuming
site. `yarn lint` will not catch `var()` passed into a Sass colour function. Either check
those by eye against the `BLOCKED` list, or compile once with a standalone Sass:

```bash
npx --yes sass --load-path=assets assets/presidium.scss /dev/null
```

Then check both themes visually in a consuming site. Nothing in this repo renders on its
own.

### 7. Record the change

- `CHANGELOG.md`: append a `## YYYY-MM-DD` section with `### Feature` or `### Bugfix`, a
  one-line summary, `@handle` and the Jira link.
- PR titles are lint-enforced as conventional commits (`feat:`, `fix:`).

## Known traps

Worth re-reading before starting; each has bitten this codebase's shape specifically.

- **`@extend` hides colours.** `blockquote` (`@extend .well`) and `table`
  (`@extend .table-striped`, `.table-bordered`) in `_structure.scss` have no colour
  declarations of their own — they inherit `#f5f5f5`, `#f9f9f9` and `#ddd` from Bootstrap.
  Grep will not find them.
- **Client CSS wins the cascade.** `assets/_sass/client-custom/` imports last and consuming
  sites ship literal hex there. Those declarations override tokenised ones, so client sites
  will render half-dark until they migrate too. Also note `client-custom/_variables.scss`
  is imported *after* Bootstrap, so `!default` overrides placed there already have no
  effect — a pre-existing bug worth mentioning separately.
- **`!important` is everywhere** in the typography and Mermaid partials. A tokenised rule
  loses to an `!important` literal elsewhere.
- **Contrast is not automatic.** `--muted-foreground` on `--muted`, and the callout tints
  (`rgba($color, 0.1)` over a dark background collapses to nearly invisible), need checking
  against WCAG AA in both themes. `$link-color: #e49134` on white is already about 2.2:1.
- **The fallback change is a real light-mode diff.** Say so in the PR; do not present the
  migration as visually neutral.
