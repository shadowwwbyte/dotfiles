#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./tmux-print.sh
#   ./tmux-print.sh                # -> tmux-output.html
#   ./tmux-print.sh output.html    # HTML only
#   ./tmux-print.sh output.pdf     # HTML, then printed to PDF (no margins)
#
# Captures the current tmux pane's scrollback and converts ANSI escapes to
# HTML using the Gruvbox Dark palette directly (no aha). PDF output is only
# produced when the output name ends in .pdf.

OUT="${1:-tmux-output.html}"
WANT_PDF=0
case "${OUT,,}" in *.pdf) WANT_PDF=1 ;; esac
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

PYTHON="$(command -v python3 || command -v python || true)"
if [[ -z "$PYTHON" ]]; then
    echo "Error: required command not found: python3" >&2
    exit 1
fi

REQUIRED=(tmux)
(( WANT_PDF )) && REQUIRED+=(chromium)
for cmd in "${REQUIRED[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf 'Error: required command not found: %s\n' "$cmd" >&2
        exit 1
    fi
done

if [[ -z "${TMUX:-}" ]]; then
    echo "Error: run this script inside the tmux pane you want to capture." >&2
    exit 1
fi

# 1. Capture the current pane and its history, preserving ANSI escapes.
tmux capture-pane -p -e -S - > "$WORK/capture.ansi"

# 2. Convert ANSI -> HTML with the exact Gruvbox palette.
if (( WANT_PDF )); then HTML_OUT="$WORK/capture.html"; else HTML_OUT="$OUT"; fi
"$PYTHON" - "$WORK/capture.ansi" "$HTML_OUT" <<'PY'
import re
import sys
from html import escape
from pathlib import Path

src, dst = Path(sys.argv[1]), Path(sys.argv[2]).expanduser().resolve()
text = src.read_text(errors="replace").replace("\r", "")

BG = "#282828"
FG = "#ebdbb2"

PALETTE = [
    # normal
    "#282828", "#cc241d", "#98971a", "#d79921",
    "#458588", "#b16286", "#689d6a", "#a89984",
    # bright
    "#928374", "#fb4934", "#b8bb26", "#fabd2f",
    "#83a598", "#d3869b", "#8ec07c", "#ebdbb2",
]


def color256(n):
    if n < 16:
        return PALETTE[n]
    if n < 232:
        n -= 16
        lv = [0, 95, 135, 175, 215, 255]
        return "#%02x%02x%02x" % (lv[n // 36], lv[(n // 6) % 6], lv[n % 6])
    g = 8 + 10 * (n - 232)
    return "#%02x%02x%02x" % (g, g, g)


class State:
    def __init__(self):
        self.reset()

    def reset(self):
        self.fg = None
        self.bg = None
        self.bold = False
        self.dim = False
        self.italic = False
        self.underline = False
        self.strike = False
        self.reverse = False

    def style(self):
        fg, bg = self.fg, self.bg
        if self.reverse:
            fg, bg = (bg or BG), (fg or FG)
        css = []
        if fg:
            css.append(f"color:{fg}")
        if bg:
            css.append(f"background-color:{bg}")
        if self.bold:
            css.append("font-weight:bold")
        if self.dim:
            css.append("opacity:0.7")
        if self.italic:
            css.append("font-style:italic")
        deco = []
        if self.underline:
            deco.append("underline")
        if self.strike:
            deco.append("line-through")
        if deco:
            css.append("text-decoration:" + " ".join(deco))
        return ";".join(css)


def apply_sgr(st, params):
    codes = [int(p) if p.isdigit() else 0 for p in params.replace(":", ";").split(";")]
    if not codes:
        codes = [0]
    i = 0
    while i < len(codes):
        c = codes[i]
        if c == 0:
            st.reset()
        elif c == 1:
            st.bold = True
        elif c == 2:
            st.dim = True
        elif c == 3:
            st.italic = True
        elif c == 4:
            st.underline = True
        elif c == 7:
            st.reverse = True
        elif c == 9:
            st.strike = True
        elif c == 22:
            st.bold = st.dim = False
        elif c == 23:
            st.italic = False
        elif c == 24:
            st.underline = False
        elif c == 27:
            st.reverse = False
        elif c == 29:
            st.strike = False
        elif 30 <= c <= 37:
            st.fg = PALETTE[c - 30]
        elif c == 39:
            st.fg = None
        elif 40 <= c <= 47:
            st.bg = PALETTE[c - 40]
        elif c == 49:
            st.bg = None
        elif 90 <= c <= 97:
            st.fg = PALETTE[c - 90 + 8]
        elif 100 <= c <= 107:
            st.bg = PALETTE[c - 100 + 8]
        elif c in (38, 48):
            target = "fg" if c == 38 else "bg"
            if i + 1 < len(codes) and codes[i + 1] == 5 and i + 2 < len(codes):
                setattr(st, target, color256(codes[i + 2]))
                i += 2
            elif i + 1 < len(codes) and codes[i + 1] == 2 and i + 4 < len(codes):
                r, g, b = codes[i + 2:i + 5]
                setattr(st, target, "#%02x%02x%02x" % (r & 255, g & 255, b & 255))
                i += 4
        i += 1


TOKEN = re.compile(
    r"\x1b\[([0-9;:]*)m"                      # SGR
    r"|\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)"    # OSC
    r"|\x1b\[[0-9;?]*[A-Za-ln-z@`]"           # other CSI (non-SGR)
    r"|\x1b[()][A-Za-z0-9]"                   # charset selects
)

out = []
st = State()
pos = 0
for m in TOKEN.finditer(text):
    if m.start() > pos:
        chunk = escape(text[pos:m.start()])
        style = st.style()
        out.append(f'<span style="{style}">{chunk}</span>' if style else chunk)
    if m.group(1) is not None:
        apply_sgr(st, m.group(1))
    pos = m.end()
if pos < len(text):
    chunk = escape(text[pos:])
    style = st.style()
    out.append(f'<span style="{style}">{chunk}</span>' if style else chunk)

body = "".join(out).rstrip("\n ")

html = f"""<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
@page {{ size: A4 landscape; margin: 0; }}
* {{
  -webkit-print-color-adjust: exact;
  print-color-adjust: exact;
}}
html, body {{
  margin: 0;
  padding: 0;
  background: {BG};
  color: {FG};
}}
pre {{
  margin: 0;
  padding: 0;
  background: {BG};
  color: {FG};
  font-family: "Hack Nerd Font Mono", "Hack Nerd Font", monospace;
  font-size: 9pt;
  line-height: 1.25;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
}}
</style>
</head>
<body><pre>{body}</pre></body>
</html>
"""
dst.write_text(html)
PY

if (( ! WANT_PDF )); then
    printf 'HTML created: %s\n' "$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")"
    exit 0
fi

# 3. Print HTML to PDF with zero page margins.
OUT_ABS="$("$PYTHON" - "$OUT" <<'PY2'
from pathlib import Path
import sys
print(Path(sys.argv[1]).expanduser().resolve())
PY2
)"

chromium \
    --headless \
    --disable-gpu \
    --no-pdf-header-footer \
    --no-margins \
    --print-to-pdf="$OUT_ABS" \
    "file://$WORK/capture.html" >/dev/null 2>&1

printf 'PDF created: %s\n' "$OUT_ABS"
