# SCSS catalog — `presidium-styling-base`

> Auto-generated reference of the reusable SCSS surface: mixins, functions, and design-token variables. This is the styling equivalent of the layout `PARTIALS.md` — **check here before adding a new mixin or variable** so you reuse what exists instead of duplicating it.

- **5** Presidium mixins · **0** functions · vendored Bootstrap (73 files) is excluded from this surface.

Regenerate with `python3 gen_styles.py`.

## Directory map (non-Bootstrap)

- **(root)/** — _structure.scss
- **../** — presidium.scss
- **client-custom/** — _client-custom.scss, _custom-enterprise.scss, _custom.scss, _local.scss, _variables.scss
- **components/** — _components.scss
- **components/article/** — _article.scss, _image.scss, _lists.scss, _syntax.scss, _tooltips.scss
- **components/blog/** — _blog.scss
- **components/blog/archive/** — _archive.scss
- **components/blog/home-page/** — _home-page.scss
- **components/editor/** — _editor.scss
- **components/left-nav/** — _left-nav.scss, _structure.scss, _transition.scss
- **components/shortcodes/** — _mermaid.scss, _shortcodes.scss
- **components/title-bar/** — _structure.scss, _title-bar.scss
- **defaults/** — _default-colors.scss, _default-typography.scss, _default-variables.scss, _defaults.scss
- **enterprise/** — _enterprise.scss
- **outputs/** — _outputs.scss, _pdf.scss, _print.scss

## Mixins

| Mixin | Signature | Defined in |
|---|---|---|
| `bg-gradient` | `@include bg-gradient($color)` | `assets/_sass/components/left-nav/_structure.scss` |
| `callout` | `@include callout($color, $text)` | `assets/_sass/_structure.scss` |
| `collapse_transition` | `@include collapse_transition($transition...)` | `assets/_sass/components/left-nav/_transition.scss` |
| `headings` | `@include headings()` | `assets/_sass/_structure.scss` |
| `menu-levels-pad` | `@include menu-levels-pad($count, $darken)` | `assets/_sass/components/left-nav/_structure.scss` |

## Design-token variables (defaults / client-custom / enterprise)

Override these in `client-custom/` rather than hard-coding values.

### `assets/_sass/defaults/_default-typography.scss`

| Variable | Default |
|---|---|
| `$prsdm-typography-default-font-color` | `$color-grey-1` |
| `$prsdm-typography-secondary-font-color` | `$color-grey-2` |
| `$prsdm-typography-base-font-family` | `'Open Sans', sans-serif` |
| `$prsdm-typography-base-font-weight` | `400` |
| `$prsdm-typography-base-line-height` | `18px` |
| `$prsdm-typography-base-font-size` | `13px` |
| `$prsdm-typography-base-letter-spacing` | `0` |
| `$prsdm-typography-base-color` | `$prsdm-typography-default-font-color` |
| `$prsdm-typography-html-font-size` | `16px` |
| `$headings-font-family` | `$prsdm-typography-base-font-family` |
| `$prsdm-typography-heading-strong-font-weight` | `600` |
| `$prsdm-typography-heading-medium-font-weight` | `500` |
| `$prsdm-typography-heading-light-font-weight` | `450` |
| `$presidium-typography-h1-line-height` | `41px` |
| `$presidium-typography-h1-font-size` | `34px` |
| `$presidium-typography-h1-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$presidium-typography-h2-line-height` | `32px` |
| `$presidium-typography-h2-font-size` | `28px` |
| `$presidium-typography-h2-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$presidium-typography-h3-line-height` | `28px` |
| `$presidium-typography-h3-font-size` | `24px` |
| `$presidium-typography-h3-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$presidium-typography-h4-line-height` | `24px` |
| `$presidium-typography-h4-font-size` | `22px` |
| `$presidium-typography-h4-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$presidium-typography-h5-line-height` | `22px` |
| `$presidium-typography-h5-font-size` | `20px` |
| `$presidium-typography-h5-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$presidium-typography-h6-line-height` | `20px` |
| `$presidium-typography-h6-font-size` | `18px` |
| `$presidium-typography-h6-font-weight` | `$prsdm-typography-heading-medium-font-weight` |
| `$primary-font-color` | `$prsdm-typography-default-font-color` |
| `$secondary-font-color` | `$prsdm-typography-secondary-font-color` |
| `$primary-font-family` | `$prsdm-typography-base-font-family` |
| `$monospace-font-family` | `monospace` |
| `$font-size-base` | `$prsdm-typography-base-font-size` |
| `$line-height-base` | `1.428571429` |
| `$line-height-computed` | `floor(($font-size-base * $line-height-base))` |
| `$padding-base-vertical` | `8px` |
| `$padding-base-horizontal` | `12px` |
| `$input-height-base` | `($line-height-computed + ($padding-base-vertical * 2) + 2)` |

### `assets/_sass/defaults/_default-variables.scss`

| Variable | Default |
|---|---|
| `$font-weight-light` | `300` |
| `$font-weight-regular` | `400` |
| `$font-weight-medium` | `500` |
| `$font-weight-semibold` | `600` |
| `$font-weight-bold` | `700` |
| `$brand-primary` | `#e49134` |
| `$brand-info` | `#eb9110` |
| `$brand-tint` | `rgba(254, 178, 70, 1)` |
| `$navbar-default-link-hover-color` | `$brand-info` |
| `$navbar-default-link-hover-bg` | `white` |
| `$link-color` | `#e49134` |
| `$primary-fill-color` | `#F6F5F4` |
| `$secondary-fill-color` | `#ECEBE9` |
| `$color-grey` | `#333` |
| `$color-grey-1` | `#555` |
| `$color-grey-2` | `#777` |
| `$color-grey-3` | `#bbb` |
| `$color-grey-4` | `#f3f3f3` |
| `$color-orange` | `#eb9110` |
| `$color-yellow-green` | `#beb239` |
| `$color-green` | `#84a93f` |
| `$color-blue` | `#4586cd` |
| `$color-red` | `#e52213` |
| `$color-dark-grey` | `#3d3d3d` |
| `$gray-base` | `#000` |
| `$gray-darker` | `#555` |
| `$gray-dark` | `lighten($gray-base, 20%)` |
| `$gray` | `#666` |
| `$gray-light` | `lighten($gray-base, 60%)` |
| `$gray-lighter` | `lighten($gray-base, 93.5%)` |
| `$navbar-default-bg` | `#eee` |
| `$border` | `#dadada` |

## Component CSS classes (138 distinct)

Presidium-specific classes defined in `components/` and `_structure.scss` (Bootstrap's own classes excluded). Reuse these in layouts before inventing new ones.

- **`assets/_sass/_structure.scss`** — `.archive`, `.article`, `.article-author`, `.article-edit-menu`, `.article-header`, `.article-iframe`, `.article-role`, `.article-status`, `.article-title`, `.category`, `.content-wrapper`, `.dark`, `.dropdown-item`, `.edit-icon`, `.global-footer`, `.label`, `.link-icon`, `.permalink`, `.popup-text`, `.presidium-article-wrapper`, `.presidium-best-practice`, `.presidium-chris-says`, `.presidium-enterprise`, `.presidium-for-example`, `.presidium-prerequisite`, `.presidium-pro-tip`, `.presidium-suggested-courses`, `.presidium-suggested-reading`, `.presidium-warning`, `.row`, `.show`, `.side-by-side`, `.side-by-side-left`, `.side-by-side-right`, `.status-draft`, `.status-published`, `.status-retired`, `.status-review`, `.toast`, `.toggle`, `.toolbar-wrapper`
- **`assets/_sass/components/article/_image.scss`** — `.modal-caption`, `.modal-close`, `.scalable`
- **`assets/_sass/components/article/_syntax.scss`** — `.highlight`, `.highlighter-rouge`
- **`assets/_sass/components/article/_tooltips.scss`** — `.tooltips-term`, `.tooltips-text`
- **`assets/_sass/components/blog/home-page/_home-page.scss`** — `.archive`, `.article-card`, `.article-frontmatter`, `.article-thumbnail`, `.author`, `.date`, `.featured-grid`, `.gridfiller`, `.hero`, `.hero-content`, `.hero-image`, `.homepage`, `.image-thumbnail`, `.link`, `.menu-row`, `.menu-title`, `.offendingHr`, `.presidium-article-wrapper`, `.section`, `.single`, `.single-hero`, `.single-image`, `.single-minimal`, `.tag`, `.title`
- **`assets/_sass/components/editor/_editor.scss`** — `.cdx-quote`, `.ce-popover`, `.ce-toolbar__actions`, `.ce-toolbar__settings-btn--hidden`, `.codex-editor--narrow`, `.codex-editor__redactor`, `.dropdown`, `.dropdown__control`, `.dropdown__control--is-focused`, `.dropdown__control--is-selected`, `.dropdown__indicator--is-focused`, `.dropdown__indicator--is-selected`, `.dropdown__indicator-separator`, `.dropdown__menu`, `.dropdown__option--is-focused`, `.dropdown__option--is-selected`, `.editor-button`, `.editor-modal`, `.editor-modal-overlay`, `.editor-popup-panel`, `.editor-popup-panel-copy`, `.editor-popup-panel-error`, `.editor-popup-panel-loading`, `.editor-spinner`, `.front-matter`, `.ok-button`, `.options`, `.popup-alert`, `.popup-alert-spacer`, `.popup-copy-text`, `.popup-copy-tick`, `.popup-spinner`, `.popup-text`, `.popup-tick`, `.title`, `.warning-button`
- **`assets/_sass/components/left-nav/_structure.scss`** — `.active`, `.add-icon`, `.article-navbar-options`, `.brand`, `.brand-name`, `.brand-name-grid`, `.child`, `.closed`, `.container`, `.delete-icon`, `.dropdown`, `.expanded`, `.hidden`, `.level-`, `.level-1`, `.link`, `.menu-expander`, `.menu-expander-icon`, `.menu-row`, `.menu-title`, `.navbar`, `.navbar-footer`, `.navbar-header`, `.navbar-items`, `.navbar-nav`, `.open`, `.option-button`, `.quality-category-labels`, `.versions-filter`
- **`assets/_sass/components/left-nav/_transition.scss`** — `.collapse`, `.collapse-horizontal`, `.collapsing`, `.show`
- **`assets/_sass/components/shortcodes/_mermaid.scss`** — `.edgeLabel`, `.nodeLabel`
- **`assets/_sass/components/title-bar/_structure.scss`** — `.brand`, `.brand-name`, `.module-title-bar`, `.module-title-bar-brand`, `.module-title-bar-logo`, `.quality-category-labels`
