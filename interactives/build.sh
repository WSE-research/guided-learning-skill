#!/usr/bin/env bash
# Injects interactive.css into all HTML files in this directory.
# Run after editing interactive.css to keep files self-contained for Obsidian.
#
# Usage: ./build.sh            (all HTML files)
#        ./build.sh foo.html   (specific file)

set -euo pipefail
cd "$(dirname "$0")"

CSS_FILE="interactive.css"
if [[ ! -f "$CSS_FILE" ]]; then
  echo "Error: $CSS_FILE not found" >&2; exit 1
fi

CSS_CONTENT=$(<"$CSS_FILE")

inject() {
  local f="$1"
  # Replace <link rel="stylesheet" href="interactive.css"> with inline <style>
  # Also handles existing inline blocks from previous builds (idempotent)
  python3 -c "
import re, sys

css = sys.argv[1]
html = open(sys.argv[2], 'r').read()

# Pattern: link tag OR previously injected style block
link_pat = r'<link\s+rel=\"stylesheet\"\s+href=\"interactive\.css\"\s*/?>'
injected_pat = r'<!-- interactive\.css:start -->.*?<!-- interactive\.css:end -->'

style_block = '<!-- interactive.css:start -->\n<style>\n' + css + '\n</style>\n<!-- interactive.css:end -->'

if re.search(injected_pat, html, re.DOTALL):
  html = re.sub(injected_pat, style_block, html, flags=re.DOTALL)
elif re.search(link_pat, html):
  html = re.sub(link_pat, style_block, html)
else:
  print(f'  skip: no link tag or injected block found in {sys.argv[2]}', file=sys.stderr)
  sys.exit(0)

open(sys.argv[2], 'w').write(html)
print(f'  done: {sys.argv[2]}')
" "$CSS_CONTENT" "$f"
}

if [[ $# -gt 0 ]]; then
  for f in "$@"; do inject "$f"; done
else
  for f in *.html; do inject "$f"; done
fi
