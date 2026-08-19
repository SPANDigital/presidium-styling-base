#!/usr/bin/env bash
#
# Audit hardcoded colours in the Presidium SCSS sources.
#
# Reports every literal colour that is NOT already wrapped in var(), split into:
#   PRIORITY  greyscale / near-white / near-black -> must be tokenised for dark mode
#   SCRIM     transparent black/white overlays    -> normally left alone
#   OTHER     saturated / brand colours           -> only tokenise if very light or very dark
#   BLOCKED   literal fed into a Sass colour function -> cannot take var(), needs a rewrite
#
# Vendored Bootstrap (assets/_sass/bootstrap/) is excluded: it is third-party and is
# overridden from a Presidium partial instead of being edited in place.
#
# Usage:
#   .claude/skills/dark-mode/scripts/audit-colors.sh              # audit assets/
#   .claude/skills/dark-mode/scripts/audit-colors.sh assets/_sass/components
#   .claude/skills/dark-mode/scripts/audit-colors.sh --include-vendor
#
set -euo pipefail

INCLUDE_VENDOR=0
ROOTS=()
for arg in "$@"; do
  case "$arg" in
    --include-vendor) INCLUDE_VENDOR=1 ;;
    -h|--help) awk 'NR>2 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "$0"; exit 0 ;;
    *) ROOTS+=("$arg") ;;
  esac
done
[ ${#ROOTS[@]} -eq 0 ] && ROOTS=("assets")

FILES=()
while IFS= read -r f; do
  FILES+=("$f")
done < <(
  if [ "$INCLUDE_VENDOR" -eq 1 ]; then
    find "${ROOTS[@]}" -name '*.scss' | sort
  else
    find "${ROOTS[@]}" -name '*.scss' -not -path '*/bootstrap/*' | sort
  fi
)

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No .scss files found under: ${ROOTS[*]}" >&2
  exit 1
fi

awk '
function hv(c,   i) { i = index("0123456789abcdef", tolower(c)); return i - 1 }
function h1(s)      { return hv(s) * 17 }
function h2(s)      { return hv(substr(s, 1, 1)) * 16 + hv(substr(s, 2, 1)) }
function mx(a,b,c)  { return (a > b ? (a > c ? a : c) : (b > c ? b : c)) }
function mn(a,b,c)  { return (a < b ? (a < c ? a : c) : (b < c ? b : c)) }

# Classify an r,g,b(,a) triple into a bucket.
function bucket(r, g, b, a,   hi, lo) {
  hi = mx(r, g, b); lo = mn(r, g, b)
  if (a < 1 && hi - lo <= 24) return "SCRIM"
  if (hi - lo <= 24)          return "PRIORITY"   # greyscale
  if (lo >= 230)              return "PRIORITY"   # tinted near-white
  if (hi <= 40)               return "PRIORITY"   # tinted near-black
  return "OTHER"
}

function record(kind, why, tok,   key, dedupe) {
  key = FILENAME ":" FNR
  dedupe = key SUBSEP tok
  if (dedupe in seen) return
  seen[dedupe] = 1
  out[++n] = kind SUBSEP key SUBSEP tok SUBSEP why SUBSEP trimmed
  count[kind]++
}

{
  raw = $0
  trimmed = raw
  sub(/^[ \t]+/, "", trimmed)

  # Ignore comment-only lines.
  if (trimmed ~ /^\/\// || trimmed ~ /^\*/ || trimmed ~ /^\/\*/) next

  line = raw
  sub(/\/\/.*$/, "", line)          # strip trailing line comments
  gsub(/\/\*[^*]*\*\//, "", line)   # strip inline block comments

  # A literal already used as a var() fallback is done; remove those spans first.
  while (match(line, /var\([^()]*\)/)) line = substr(line, 1, RSTART - 1) " " substr(line, RSTART + RLENGTH)

  # url() arguments are filenames (plus-white.svg), never colours.
  while (match(line, /url\([^()]*\)/)) line = substr(line, 1, RSTART - 1) " " substr(line, RSTART + RLENGTH)

  # Literals passed into a Sass colour function cannot become var() as-is.
  blocked = (line ~ /(darken|lighten|mix|adjust-hue|saturate|desaturate|transparentize|fade-out|fade-in|rgba)\([^)]*(\$|#)/)

  # --- rgb() / rgba() literals -------------------------------------------------
  work = line
  while (match(work, /rgba?\([^()]*\)/)) {
    tok = substr(work, RSTART, RLENGTH)
    work = substr(work, RSTART + RLENGTH)
    body = tok
    sub(/^rgba?\(/, "", body); sub(/\)$/, "", body)
    gsub(/[,\/]/, " ", body)
    nf = split(body, p, /[ \t]+/)
    if (nf < 3) continue
    if (p[1] ~ /\$/) continue                       # rgba($var, .1) -> handled as BLOCKED
    r = p[1] + 0; g = p[2] + 0; b = p[3] + 0
    a = 1
    if (nf >= 4) { a = p[4]; sub(/%$/, "", a); a = a + 0; if (p[4] ~ /%$/) a = a / 100 }
    record(bucket(r, g, b, a), sprintf("rgb(%d,%d,%d) a=%.2f", r, g, b, a), tok)
  }

  # --- hex literals ------------------------------------------------------------
  work = line
  while (match(work, /#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])?/)) {
    tok = substr(work, RSTART, RLENGTH)
    work = substr(work, RSTART + RLENGTH)
    hex = substr(tok, 2)
    if (length(hex) == 3) { r = h1(substr(hex,1,1)); g = h1(substr(hex,2,1)); b = h1(substr(hex,3,1)) }
    else                  { r = h2(substr(hex,1,2)); g = h2(substr(hex,3,2)); b = h2(substr(hex,5,2)) }
    record(bucket(r, g, b, 1), sprintf("rgb(%d,%d,%d)", r, g, b), tok)
  }

  # --- named colours -----------------------------------------------------------
  # Only the value side of a declaration, so property names (white-space, border-color)
  # and Sass variable names ($color-grey-2, $gray-lighter) are not mistaken for values.
  work = line
  if (index(work, ":") > 0) work = substr(work, index(work, ":") + 1)
  else work = ""
  gsub(/\$[A-Za-z0-9_-]+/, " ", work)
  work = tolower(work)
  gsub(/[^a-z]/, " ", work)
  nf = split(work, w, /[ \t]+/)
  for (i = 1; i <= nf; i++) {
    name = w[i]
    if (name == "white")      record("PRIORITY", "rgb(255,255,255)", "white")
    else if (name == "black") record("PRIORITY", "rgb(0,0,0)",       "black")
    else if (name == "grey" || name == "gray")           record("PRIORITY", "rgb(128,128,128)", name)
    else if (name == "whitesmoke")                       record("PRIORITY", "rgb(245,245,245)", name)
    else if (name == "gainsboro")                        record("PRIORITY", "rgb(220,220,220)", name)
    else if (name == "silver")                           record("PRIORITY", "rgb(192,192,192)", name)
    else if (name == "lightgray" || name == "lightgrey") record("PRIORITY", "rgb(211,211,211)", name)
    else if (name == "darkgray"  || name == "darkgrey")  record("PRIORITY", "rgb(169,169,169)", name)
    else if (name == "dimgray"   || name == "dimgrey")   record("PRIORITY", "rgb(105,105,105)", name)
  }

  if (blocked) record("BLOCKED", "literal inside a Sass colour function", "-")
}

END {
  order[1] = "PRIORITY"; order[2] = "BLOCKED"; order[3] = "SCRIM"; order[4] = "OTHER"
  desc["PRIORITY"] = "greyscale / near-white / near-black -- tokenise these"
  desc["BLOCKED"]  = "literal inside a Sass colour function -- var() will not compile here"
  desc["SCRIM"]    = "translucent black/white overlay -- normally leave as-is"
  desc["OTHER"]    = "saturated colour -- tokenise only if design asks"

  for (o = 1; o <= 4; o++) {
    k = order[o]
    printf "\n===== %s (%d) : %s\n", k, count[k] + 0, desc[k]
    for (i = 1; i <= n; i++) {
      split(out[i], f, SUBSEP)
      if (f[1] != k) continue
      printf "  %-58s %-24s %s\n", f[2], f[3] " [" f[4] "]", substr(f[5], 1, 70)
    }
  }
  printf "\nTotal: %d finding(s) across the scanned files.\n", n
}
' "${FILES[@]}"

# ---------------------------------------------------------------------------
# Sass variables holding a greyscale literal. Call sites reference the variable,
# not the literal, so they never show up above -- tokenise the definition and
# every usage follows. Usage counts include vendored Bootstrap, which consumes
# many of these.
# ---------------------------------------------------------------------------
printf "\n===== GREYSCALE SASS VARIABLES : tokenise the definition, not each call site\n"
{ grep -hoE '^\$[A-Za-z0-9_-]+:[^;]*#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})' "${FILES[@]}" 2>/dev/null || true; } \
  | while IFS= read -r def; do
      name="${def%%:*}"
      hexpart="${def##*#}"
      case "$hexpart" in
        ???) r="${hexpart:0:1}${hexpart:0:1}"; g="${hexpart:1:1}${hexpart:1:1}"; b="${hexpart:2:1}${hexpart:2:1}" ;;
        *)   r="${hexpart:0:2}"; g="${hexpart:2:2}"; b="${hexpart:4:2}" ;;
      esac
      rv=$((16#$r)); gv=$((16#$g)); bv=$((16#$b))
      hi=$rv; [ $gv -gt $hi ] && hi=$gv; [ $bv -gt $hi ] && hi=$bv
      lo=$rv; [ $gv -lt $lo ] && lo=$gv; [ $bv -lt $lo ] && lo=$bv
      [ $((hi - lo)) -gt 24 ] && continue
      # Word-boundary match so $gray does not also count $gray-light, $gray-lighter, ...
      esc=$(printf '%s' "$name" | sed 's/\$/\\$/g')
      uses=$(grep -rhoE --include='*.scss' "${esc}([^A-Za-z0-9_-]|\$)" assets | wc -l | tr -d ' ')
      printf "  %-28s #%-8s rgb(%d,%d,%d)  %s use(s)\n" "$name" "$hexpart" "$rv" "$gv" "$bv" "$uses"
    done
