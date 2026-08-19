# External theme tokens

These custom properties are injected at runtime by the host application, **not** by this
repo. `:root` holds the light values; the host adds `.dark` to an ancestor element to swap
in the dark values.

Because this repo may also be consumed where the host does *not* inject them, every usage
must carry a fallback, and that fallback must be the light value from the table below:

```scss
background-color: var(--background, rgba(255, 255, 255, 1));
```

Copy fallback values verbatim from the "Light" column, including the `rgba(...)` notation
and the spaces after commas — Prettier formats them that way and stylelint will not complain.

## Token reference

| Token | Light | Dark |
| --- | --- | --- |
| `--background` | `rgba(255, 255, 255, 1)` | `rgba(10, 10, 10, 1)` |
| `--foreground` | `rgba(10, 10, 10, 1)` | `rgba(250, 250, 250, 1)` |
| `--card` | `rgba(255, 255, 255, 1)` | `rgba(23, 23, 23, 1)` |
| `--card-foreground` | `rgba(10, 10, 10, 1)` | `rgba(250, 250, 250, 1)` |
| `--popover` | `rgba(255, 255, 255, 1)` | `rgba(38, 38, 38, 1)` |
| `--popover-foreground` | `rgba(10, 10, 10, 1)` | `rgba(250, 250, 250, 1)` |
| `--primary` | `rgba(13, 148, 136, 1)` | `rgba(13, 148, 136, 1)` |
| `--primary-foreground` | `rgba(255, 255, 255, 1)` | `rgba(39, 35, 29, 1)` |
| `--secondary` | `rgba(210, 255, 252, 1)` | `rgba(0, 56, 54, 1)` |
| `--secondary-foreground` | `rgba(23, 23, 23, 1)` | `rgba(250, 250, 250, 1)` |
| `--muted` | `rgba(236, 235, 233, 1)` | `rgba(38, 38, 38, 1)` |
| `--muted-foreground` | `rgba(115, 115, 115, 1)` | `rgba(163, 163, 163, 1)` |
| `--accent` | `rgba(219, 227, 231, 1)` | `rgba(45, 65, 74, 1)` |
| `--accent-foreground` | `rgba(23, 23, 23, 1)` | `rgba(250, 250, 250, 1)` |
| `--destructive` | `rgba(188, 47, 59, 1)` | `rgba(188, 47, 59, 1)` |
| `--destructive-foreground` | `rgba(252, 224, 222, 1)` | `rgba(252, 224, 222, 1)` |
| `--border` | `rgba(229, 229, 229, 1)` | `rgba(85, 85, 85, 1)` |
| `--input` | `rgba(229, 229, 229, 1)` | `rgba(255, 255, 255, 0.15)` |
| `--ring` | `rgba(163, 163, 163, 1)` | `rgba(115, 115, 115, 1)` |
| `--radius` | `0.625rem` | *(not overridden)* |
| `--sidebar` | `rgba(250, 250, 250, 1)` | `rgba(23, 23, 23, 1)` |
| `--sidebar-foreground` | `rgba(10, 10, 10, 1)` | `rgba(250, 250, 250, 1)` |
| `--sidebar-primary` | `rgba(23, 23, 23, 1)` | `rgba(29, 78, 216, 1)` |
| `--sidebar-primary-foreground` | `rgba(250, 250, 250, 1)` | `rgba(250, 250, 250, 1)` |
| `--sidebar-accent` | `rgba(245, 245, 245, 1)` | `rgba(38, 38, 38, 1)` |
| `--sidebar-accent-foreground` | `rgba(23, 23, 23, 1)` | `rgba(250, 250, 250, 1)` |
| `--sidebar-border` | `rgba(229, 229, 229, 1)` | `rgba(255, 255, 255, 0.1)` |
| `--sidebar-ring` | `rgba(163, 163, 163, 1)` | `rgba(82, 82, 82, 1)` |
| `--notification` | `rgba(235, 93, 42, 1)` | `rgba(235, 93, 42, 1)` |
| `--fill-primary` | `rgba(246, 245, 244, 1)` | `rgba(39, 35, 29, 1)` |
| `--fill-secondary` | `rgba(236, 235, 233, 1)` | `rgba(67, 62, 56, 1)` |
| `--fill-tertiary` | `rgba(225, 222, 219, 1)` | `rgba(81, 75, 67, 1)` |
| `--fill-quaternary` | `rgba(181, 175, 166, 1)` | `rgba(119, 111, 100, 1)` |
| `--fill-quinary` | `rgba(39, 35, 29, 1)` | `rgba(138, 133, 125, 1)` |
| `--brand-secondary` | `rgba(248, 186, 77, 1)` | `rgba(248, 186, 77, 1)` |
| `--brand-tertiary` | `rgba(235, 93, 42, 1)` | `rgba(235, 93, 42, 1)` |
| `--success-foreground` | `rgba(0, 104, 47, 1)` | `rgba(101, 235, 141, 1)` |
| `--success-primary` | `rgba(66, 205, 113, 1)` | `rgba(66, 205, 113, 1)` |
| `--success-secondary` | `rgba(86, 222, 129, 1)` | `rgba(4, 172, 83, 1)` |
| `--success-tertiary` | `rgba(101, 235, 141, 1)` | `rgba(0, 138, 64, 1)` |
| `--success-quarternary` | `rgba(226, 255, 231, 1)` | `rgba(0, 40, 14, 1)` |
| `--warning-primary` | `rgba(245, 196, 0, 1)` | `rgba(245, 196, 0, 1)` |
| `--warning-secondary` | `rgba(255, 206, 38, 1)` | `rgba(203, 162, 0, 1)` |
| `--warning-tertiary` | `rgba(255, 218, 114, 1)` | `rgba(163, 130, 0, 1)` |
| `--warning-quarternary` | `rgba(255, 245, 216, 1)` | `rgba(90, 70, 0, 1)` |
| `--info-primary` | `rgba(69, 134, 205, 1)` | `rgba(47, 113, 182, 1)` |
| `--info-secondary` | `rgba(91, 156, 228, 1)` | `rgba(27, 95, 162, 1)` |
| `--info-tertiary` | `rgba(106, 172, 245, 1)` | `rgba(0, 72, 134, 1)` |
| `--info-quarternary` | `rgba(227, 240, 255, 1)` | `rgba(0, 29, 60, 1)` |
| `--destructive-secondary` | `rgba(213, 71, 79, 1)` | `rgba(171, 26, 45, 1)` |
| `--destructive-tertiary` | `rgba(238, 95, 99, 1)` | `rgba(152, 0, 32, 1)` |
| `--destructive-quarternary` | `rgba(252, 224, 222, 1)` | `rgba(62, 0, 7, 1)` |
| `--chart-1` | `rgba(106, 172, 245, 1)` | `rgba(91, 156, 228, 1)` |
| `--chart-2` | `rgba(101, 235, 141, 1)` | `rgba(86, 222, 129, 1)` |
| `--chart-3` | `rgba(230, 142, 205, 1)` | `rgba(224, 117, 194, 1)` |
| `--chart-4` | `rgba(255, 170, 71, 1)` | `rgba(249, 158, 42, 1)` |
| `--chart-5` | `rgba(180, 145, 247, 1)` | `rgba(150, 114, 213, 1)` |
| `--chart-6` | `rgba(255, 132, 92, 1)` | `rgba(253, 109, 60, 1)` |
| `--chart-7` | `rgba(96, 196, 191, 1)` | `rgba(96, 196, 191, 1)` |
| `--chart-8` | `rgba(255, 218, 114, 1)` | `rgba(245, 196, 0, 1)` |
| `--chart-9` | `rgba(159, 179, 187, 1)` | `rgba(136, 160, 170, 1)` |
| `--chart-10` | `rgba(70, 206, 244, 1)` | `rgba(70, 206, 244, 1)` |
| `--table-highlight-1` | `rgba(227, 240, 255, 1)` | `rgba(0, 56, 107, 1)` |
| `--table-highlight-2` | `rgba(199, 225, 255, 1)` | `rgba(0, 72, 134, 1)` |
| `--table-highlight-hover-1` | `rgba(231, 237, 239, 1)` | `rgba(45, 65, 74, 1)` |
| `--table-highlight-hover-2` | `rgba(219, 227, 231, 1)` | `rgba(68, 92, 102, 1)` |
| `--table-header-highlight-1` | `rgba(231, 237, 239, 1)` | `rgba(45, 65, 74, 1)` |
| `--table-header-highlight-2` | `rgba(219, 227, 231, 1)` | `rgba(68, 92, 102, 1)` |
| `--scale-5-1` | `rgba(4, 172, 83, 1)` | `rgba(4, 172, 83, 1)` |
| `--scale-5-2` | `rgba(86, 222, 129, 1)` | `rgba(86, 222, 129, 1)` |
| `--scale-5-3` | `rgba(255, 206, 38, 1)` | `rgba(255, 206, 38, 1)` |
| `--scale-5-4` | `rgba(249, 158, 42, 1)` | `rgba(249, 158, 42, 1)` |
| `--scale-5-5` | `rgba(213, 71, 79, 1)` | `rgba(213, 71, 79, 1)` |
| `--background-item-hover` | `rgba(0, 0, 0, 0.04)` | `rgba(255, 255, 255, 0.08)` |
| `--background-secondary` | `rgba(252, 231, 198, 1)` | `rgba(106, 75, 13, 1)` |
| `--link-default` | `rgba(0, 130, 126, 1)` | `rgba(96, 196, 191, 1)` |
| `--link-hover` | `rgba(0, 92, 89, 1)` | `rgba(0, 130, 126, 1)` |

## Notes on the token set

- **`--success-quarternary`, `--warning-quarternary`, `--info-quarternary` and
  `--destructive-quarternary` are spelled "quarternary"** while `--fill-quaternary` uses
  the correct spelling. Use each name exactly as it appears above; a "corrected" spelling
  resolves to nothing and silently falls back.
- **`--fill-*` is a light-to-dark ramp that inverts between themes.** `--fill-primary` is
  near-white in light and near-black in dark; `--fill-quinary` is the reverse. That makes
  the ramp useful for surfaces that must invert (see "Inverted surfaces" in `mapping.md`),
  but it means `--fill-quinary` is *not* interchangeable with `--foreground`.
- **`--radius` has no `.dark` override**, which is correct — it is not a colour. It is
  also currently unused in this repo; adopting it is a separate piece of work.
- **There is no shadow token.** Translucent black shadows read acceptably on dark
  surfaces, so leave them alone rather than inventing a token.
- `--input` in dark is `rgba(255, 255, 255, 0.15)` — a translucent wash, not an opaque
  colour. Anything painted behind it shows through; do not use it as a fill.
