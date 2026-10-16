#!/usr/bin/env bash
# Builds the Feynman page for one breakdown and shows it in the browser.
#
# Reads the breakdown JSON on stdin and writes <tmp>/g-dev-feynman/<session>/<ROOT>.html,
# one page per breakdown per session, so running it again rewrites the same file.
# On macOS, a Safari or Chrome tab that already shows the page is reloaded in place;
# otherwise the page opens with the system default for .html files.
#
# Usage: render.sh <session-id> <root-prefix> < breakdown.json
set -euo pipefail

usage="usage: render.sh <session-id> <root-prefix> < breakdown.json"
session="${1:?$usage}"
root="${2:?$usage}"

case "$session" in *[!A-Za-z0-9-]*) echo "Invalid session id: $session" >&2; exit 2 ;; esac
case "$root" in *[!A-Z]*) echo "Invalid root prefix: $root (expected uppercase letters, such as H)" >&2; exit 2 ;; esac

here="$(cd "$(dirname "$0")" && pwd -P)"
template="$here/../template.html"
dir="${TMPDIR:-/tmp}"
dir="${dir%/}/g-dev-feynman/$session"
mkdir -p "$dir"
dir="$(cd "$dir" && pwd -P)"   # physical path, so it matches the URL the browser reports
json="$dir/$root.json"
page="$dir/$root.html"

cat > "$json"
if [ ! -s "$json" ]; then
  echo "No breakdown JSON on stdin." >&2
  exit 2
fi

check_json() {
  if command -v node >/dev/null 2>&1; then
    node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$1"
  elif [ "$(uname -s)" = Darwin ]; then
    osascript -l JavaScript -e 'function run(argv) {
      ObjC.import("Foundation");
      JSON.parse($.NSString.stringWithContentsOfFileEncodingError(argv[0], $.NSUTF8StringEncoding, null).js);
      return "";
    }' "$1" >/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json, sys; json.load(open(sys.argv[1], encoding="utf-8"))' "$1"
  fi
}
if ! check_json "$json"; then
  echo "The breakdown JSON is invalid. Fix it and run the script again." >&2
  exit 1
fi

# Inline the data. "<" becomes <, which is the same character inside a JSON string
# and can never close the <script> block it sits in.
sed 's/</\\u003c/g' "$json" > "$json.inline"
awk -v data="$json.inline" '
  /__FEYNMAN_DATA__/ { while ((getline line < data) > 0) print line; close(data); next }
  { print }
' "$template" > "$page.tmp"
mv "$page.tmp" "$page"
rm -f "$json.inline"

url="file://$page"

# A tab still counts as showing the page after a click on the diagram adds "#row-H2"
# to its address, so both scripts compare addresses without the part after "#".
reload_safari() {
  osascript - "$url" <<'APPLESCRIPT'
on withoutFragment(u)
  set o to offset of "#" in u
  if o > 0 then return text 1 thru (o - 1) of u
  return u
end withoutFragment

on run argv
  set target to item 1 of argv
  tell application "Safari"
    repeat with w in windows
      repeat with t in tabs of w
        if my withoutFragment(URL of t as text) is target then
          set URL of t to target
          set current tab of w to t
          return "Safari"
        end if
      end repeat
    end repeat
  end tell
  return ""
end run
APPLESCRIPT
}

reload_chrome() {
  osascript - "$url" <<'APPLESCRIPT'
on withoutFragment(u)
  set o to offset of "#" in u
  if o > 0 then return text 1 thru (o - 1) of u
  return u
end withoutFragment

on run argv
  set target to item 1 of argv
  tell application "Google Chrome"
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if my withoutFragment(URL of t as text) is target then
          tell t to reload
          set active tab index of w to i
          return "Google Chrome"
        end if
      end repeat
    end repeat
  end tell
  return ""
end run
APPLESCRIPT
}

case "$(uname -s)" in
  Darwin)
    # Ask a browser only when it is already running: a script that names an app
    # which is not running would start it, and one that is not installed would fail.
    where=""
    if pgrep -xq Safari; then where="$(reload_safari 2>/dev/null || true)"; fi
    if [ -z "$where" ] && pgrep -xq "Google Chrome"; then where="$(reload_chrome 2>/dev/null || true)"; fi
    if [ -n "$where" ]; then
      echo "Reloaded in $where: $page"
    else
      open "$page"
      echo "Opened: $page"
    fi
    ;;
  Linux)
    xdg-open "$page" >/dev/null 2>&1 &
    echo "Opened (reloading an open tab works on macOS only): $page"
    ;;
  MINGW* | MSYS* | CYGWIN*)
    start "" "$page"
    echo "Opened (reloading an open tab works on macOS only): $page"
    ;;
  *)
    echo "Page written, open it in your browser: $page"
    ;;
esac
