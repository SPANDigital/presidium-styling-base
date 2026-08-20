# Choosing a token, and the cases that are not a one-line substitution

## 1. Pick by role, not by hex value

Ask what the colour *does* before matching it to a swatch. The same `#fff` is
`--background` on the page shell, `--card` on a raised block and `--popover` on a floating
menu, and those three diverge in dark mode.

### Surfaces

| The colour is… | Token | Fallback |
| --- | --- | --- |
| the page / app shell background | `--background` | `rgba(255, 255, 255, 1)` |
| a raised block sitting on the shell (panel, well, card) | `--card` | `rgba(255, 255, 255, 1)` |
| a floating layer (dropdown, popover, tooltip, edit menu) | `--popover` | `rgba(255, 255, 255, 1)` |
| the left navigation chrome | `--sidebar` | `rgba(250, 250, 250, 1)` |
| a selected / active navigation item | `--sidebar-accent` | `rgba(245, 245, 245, 1)` |
| a subtle wash behind secondary content (code block, zebra stripe) | `--muted` | `rgba(236, 235, 233, 1)` |
| a neutral fill step (`#f6f5f4`, `#ecebe9`, `#e1dedb`) | `--fill-primary` / `--fill-secondary` / `--fill-tertiary` | see `tokens.md` |
| a hover wash over an existing background | `--background-item-hover` | `rgba(0, 0, 0, 0.04)` |
| an emphasis wash (highlighted row, current selection) | `--accent` | `rgba(219, 227, 231, 1)` |

### Text

| The colour is… | Token | Fallback |
| --- | --- | --- |
| primary body / heading text | `--foreground` | `rgba(10, 10, 10, 1)` |
| secondary, caption or de-emphasised text | `--muted-foreground` | `rgba(115, 115, 115, 1)` |
| text on a card | `--card-foreground` | `rgba(10, 10, 10, 1)` |
| text in a popover / tooltip | `--popover-foreground` | `rgba(10, 10, 10, 1)` |
| text on a sidebar-accent row | `--sidebar-accent-foreground` | `rgba(23, 23, 23, 1)` |
| a link | `--link-default` | `rgba(0, 130, 126, 1)` |
| a hovered link | `--link-hover` | `rgba(0, 92, 89, 1)` |

### Lines

| The colour is… | Token | Fallback |
| --- | --- | --- |
| a border, divider, rule or separator | `--border` | `rgba(229, 229, 229, 1)` |
| a form control border | `--input` | `rgba(229, 229, 229, 1)` |
| a focus ring / outline | `--ring` | `rgba(163, 163, 163, 1)` |
| a divider inside the left nav | `--sidebar-border` | `rgba(229, 229, 229, 1)` |

### Existing hardcoded values in this repo

Nearest-neighbour resolutions already worked out, so the same hex does not get argued
twice:

| Current | Token | Fallback |
| --- | --- | --- |
| `#fff`, `#ffffff`, `white` (shell) | `--background` | `rgba(255, 255, 255, 1)` |
| `#0a0a0a` (`$color-off-black`), `#111827` | `--foreground` | `rgba(10, 10, 10, 1)` |
| `#333` (`$color-grey`), `#3d3d3d` (`$color-dark-grey`) | `--foreground` | `rgba(10, 10, 10, 1)` |
| `#555` (`$color-grey-1`, `$gray-darker`), `#666` (`$gray`) | `--muted-foreground` | `rgba(115, 115, 115, 1)` |
| `#777` (`$color-grey-2`), `#374151`, `#999` | `--muted-foreground` | `rgba(115, 115, 115, 1)` |
| `#bbb` (`$color-grey-3`) as a line | `--border` | `rgba(229, 229, 229, 1)` |
| `#bbb` as a fill (`.global-footer`) | `--fill-quaternary` | `rgba(181, 175, 166, 1)` |
| `#dadada` (`$border`), `#e5e7eb`, `#d1d5db`, `#ddd` | `--border` | `rgba(229, 229, 229, 1)` |
| `#f3f3f3` (`$color-grey-4`), `#f5f5f5`, `#f9f9f9`, `#f9f8f8`, `#F6F5F4` (`$primary-fill-color`) | `--fill-primary` | `rgba(246, 245, 244, 1)` |
| `#eee` (`$navbar-default-bg`, `$gray-lighter`), `#ececec`, `#ECEBE9` (`$secondary-fill-color`) | `--fill-secondary` | `rgba(236, 235, 233, 1)` |
| `#e2e2e2` (button hover) | `--background-item-hover` | `rgba(0, 0, 0, 0.04)` |
| `#ababab` (button active) | `--fill-tertiary` | `rgba(225, 222, 219, 1)` |
| `#d14652` (editor error panel) | `--destructive-secondary` | `rgba(213, 71, 79, 1)` |

`$primary-fill-color` / `$secondary-fill-color` are exact matches for `--fill-primary` /
`--fill-secondary`; those two are pure renames with no visual change in light mode.

Everything else shifts light mode slightly. `#dadada → rgba(229, 229, 229, 1)` lightens
borders; `#333 → rgba(10, 10, 10, 1)` darkens body text. That is the intended trade — the
fallback tracks the light token — but it is a visual diff that needs review, so say so in
the PR description rather than presenting the change as purely mechanical.

## 2. Fallbacks that are currently Sass variables

Two shapes exist in the tree today:

```scss
border-bottom: 1px solid var(--border, $border);          // Sass variable as fallback
border-bottom: 1px solid var(--border, #e5e7eb);          // literal as fallback
```

Rule: **tokenise at the Sass variable definition when the variable has more than a couple
of call sites, and use a literal fallback at the call site when the colour was already
hardcoded there.** `$border` has 18 usages and `$color-grey` has 7; rewriting the
definition once in `assets/_sass/defaults/_default-variables.scss` covers all of them:

```scss
$border: var(--border, rgba(229, 229, 229, 1)) !default;
```

This only works if the variable is never passed to a Sass colour function — see §3. Run
`.claude/skills/dark-mode/scripts/audit-colors.sh` and cross-check the `BLOCKED` section
before converting any variable definition.

The `!default` flag stays. A consuming site that sets its own `$border` before this
partial is imported still wins, and the token then never applies to it — that is the
correct precedence (an explicit client override should not be overwritten by the host's
theme), but it does mean client-branded sites get less dark-mode coverage than the
default theme. Call it out rather than silently accepting it.

## 3. Sass colour functions cannot take `var()`

`darken()`, `lighten()`, `mix()`, `rgba($colour, …)`, `adjust-hue()`, `saturate()` and
friends run at compile time and need a real colour. Passing a `var()` is a build error,
not a silent fallback:

```scss
$border: var(--border, rgba(229, 229, 229, 1));
border-color: darken($border, 8%);   // Error: argument $color is not a color
```

Known blockers in this repo (the audit script lists them under `BLOCKED`):

- `assets/_sass/_structure.scss:1` — `@mixin callout($color, $text)` does
  `rgba($color, 0.1)` for the callout tint.
- `assets/_sass/components/left-nav/_structure.scss:1` — `$nav-item-border: darken($navbar-default-bg, 8%)`.
- `assets/_sass/components/left-nav/_structure.scss:11` — `@mixin bg-gradient($color)` uses
  `lighten()` / `darken()` three times.
- `assets/_sass/components/editor/_editor.scss` — `lighten($brand-primary, …)` and
  `darken($color-red, …)` on the dropdown and warning button.
- `assets/_sass/defaults/_default-variables.scss:36-39` — `$gray-dark`, `$gray-light` and
  `$gray-lighter` are all derived via `lighten($gray-base, …)`.

Three ways out, in order of preference:

1. **Leave the Sass variable alone and tokenise at the point of use.** If `$gray-lighter`
   is only a compile-time input to a few rules, replace those rules' output values with
   `var(...)` and leave the variable feeding the functions that need it.
2. **Move the maths to CSS** with `color-mix()`:
   ```scss
   background-color: color-mix(in srgb, var(--accent, rgba(219, 227, 231, 1)) 10%, transparent);
   ```
   `color-mix()` is supported in every evergreen browser from 2023 onward. Confirm the
   project's browser matrix before relying on it, and note this repo still ships
   Bootstrap 3 — a sign the matrix may be older than it looks.
3. **Introduce a paired token** where the derived colour is a real design decision rather
   than an arithmetic convenience (e.g. use `--fill-tertiary` instead of
   `darken($navbar-default-bg, 8%)`).

Do not "fix" this by keeping two copies of a colour, one Sass and one CSS. They drift.

## 4. Inverted surfaces

Some elements are deliberately the opposite of the page — the black `.presidium-chris-says`
callout, the dark editor toast panels. Tokenising only the background flips it to a dark
block on a dark page and it disappears.

Pair an inverting surface token with an inverting text token:

```scss
.presidium-chris-says {
  background-color: var(--fill-quinary, rgba(39, 35, 29, 1));
  color: var(--background, rgba(255, 255, 255, 1));
}
```

`--fill-quinary` is near-black in light mode and light-grey in dark; `--background` moves
the opposite way. The contrast is preserved in both themes.

## 5. Do not tokenise

- **Scrims and shadows.** `rgba(0, 0, 0, 50%)` modal overlays and
  `box-shadow: … rgba(0, 0, 0, 20%)` already work on both themes and there is no token for
  them. The audit script buckets these as `SCRIM`.
- **Fully transparent placeholders** such as `border-color: rgba(212, 212, 212, 0%)`.
- **Brand colours** — `$brand-primary`, `$brand-info`, `$color-orange`, `$color-green`,
  `$color-blue`, `$color-red`, `$color-yellow-green`. They are client identity, they are
  mid-saturation so they survive both themes, and the token set has no equivalent that
  preserves per-client branding. Flag any that fail contrast rather than replacing them.
- **`assets/_sass/bootstrap/**`.** Vendored third-party. See §6.

## 6. Vendored Bootstrap 3

`assets/_sass/bootstrap/` is an unmodified upstream copy. Editing it makes every future
upgrade a manual merge, and `_variables.scss` is dense with `darken(adjust-hue(...))`
expressions that cannot take `var()` at all.

Instead, override the Bootstrap-driven surfaces from a Presidium partial imported *after*
Bootstrap. The ones that actually surface in Presidium pages:

| Bootstrap variable | Default | Where it shows up |
| --- | --- | --- |
| `$well-bg` | `#f5f5f5` | `blockquote` — `_structure.scss` does `@extend .well` |
| `$table-bg-accent` | `#f9f9f9` | zebra striping — `@extend .table-striped` |
| `$table-bg-hover` | `#f5f5f5` | table row hover |
| `$table-border-color` | `#ddd` | `@extend .table-bordered` |
| `$popover-bg` | `#fff` | tooltips (`$tooltip-background: $popover-bg`) |
| `$pre-bg` / `$pre-border-color` | `#f5f5f5` / `#ccc` | code blocks |
| `$code-bg` | `#f9f2f4` | inline code |
| `$dropdown-bg` / `$dropdown-border` | `#fff` / `rgba(0,0,0,.15)` | nav dropdowns |
| `$input-bg` / `$input-border` / `$input-color-placeholder` | `#fff` / `#ccc` / `#999` | version selector, filters |
| `$panel-bg`, `$list-group-bg`, `$modal-content-bg`, `$breadcrumb-bg`, `$thumbnail-bg` | `#fff` / `#f5f5f5` | assorted components |
| `$body-bg` / `$text-color` | `#fff` / `$gray-dark` | page shell |

`blockquote` and `table` inherit their colours through `@extend`, so they are easy to miss
in a grep of the Presidium partials — they contain no colour declarations of their own.

## 7. Things CSS alone cannot fix

Record these as follow-up work rather than half-solving them:

- **Syntax highlighting** (`assets/_sass/components/article/_syntax.scss`, ~56 colours) is
  a complete light Rouge/Pygments theme. Swapping `.highlight { background: #fff }` for
  `--background` gives dark-on-dark unreadable code. It needs a matching dark palette
  under a `.dark` selector, as its own change.
- **Mermaid** (`assets/_sass/components/shortcodes/_mermaid.scss`). Diagram colours come
  from Mermaid's JS `theme` / `themeVariables` config (set in
  `presidium-layouts-base/layouts/partials/page/script.html`) and a diagram is drawn once,
  so making a diagram *follow* the theme needs a re-render in JS — CSS cannot do it.
  What CSS can do, and what `_mermaid.scss` now does, is hold the diagram still: the
  container redefines the theme tokens at their light values, restates `color` and an
  opaque `background-color` from them, and sets `color-scheme: light`. Without that,
  `#presidium-container … p` repaints every Mermaid HTML label (Mermaid wraps label text in
  `<p>`, and that declaration beats the colour inherited from `.nodeLabel` / `.edgeLabel`)
  and the dark page composites through Mermaid's translucent Gantt and pie fills.
  Note this only stops *token-resolved* colour: a rule written as `.dark <selector>` still
  reaches inside a diagram, so do not target elements a diagram contains (`p`, `span`,
  `svg`, `text`) from a `.dark` selector.
- **Icon and image assets.** `static/assets/svg/*.svg` and `static/images/status-*.png` are
  loaded via `background-image`, so `currentColor` does not reach them. Dark-on-transparent
  icons vanish on dark surfaces. Options: `filter: invert(1)` under `.dark`, a CSS `mask`
  plus `background-color: currentColor`, or swapping to the existing `-white` variants
  (`plus-white.svg`, `trash-white.svg` already exist and hint at the intended approach).
- **Author-supplied article images.** Screenshots with baked-in white backgrounds will
  glare on a dark page. `#presidium-modal img { background-color: white }` is arguably
  correct as-is; decide deliberately rather than tokenising it by reflex.

## 8. Print and PDF

`assets/_sass/outputs/_print.scss` has no colour handling. If `.dark` is on the document
when a user prints, text resolves to near-white and most browsers omit backgrounds by
default — the result is a blank page. Force light values inside `@media print`:

```scss
@media print {
  :root,
  .dark {
    --background: rgba(255, 255, 255, 1);
    --foreground: rgba(10, 10, 10, 1);
    // …remaining tokens used by printed content
  }
}
```

Redefining the tokens beats overriding every rule, and it also covers whatever the host
application injects.

## 9. `color-scheme`

The token set is class-driven (`.dark`), so nothing tells the browser the page is dark.
Native scrollbars, `<select>` popups, date pickers, form control chrome and the canvas
behind the page stay light. Add:

```scss
:root { color-scheme: light; }
.dark { color-scheme: dark; }
```

Separately, decide whether `prefers-color-scheme: dark` should apply on its own. As
specified, a user whose OS is dark sees light unless the host adds `.dark`. That may be
intentional (host owns the toggle) — confirm rather than assume.
