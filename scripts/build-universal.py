#!/usr/bin/env python3
"""Generate universal/AGENTS.md from output-styles/ground-control.md.

The style file is the single source. This script strips the Claude Code front
matter, demotes every heading one level so the block nests under a host file,
makes the "edit me" comment visible, and appends the one rule that applies only
to shared instruction files. Run it after any change to the style file:

    python3 scripts/build-universal.py
"""
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
STYLE = ROOT / "output-styles" / "ground-control.md"
TARGET = ROOT / "universal" / "AGENTS.md"

HEADER = """## Reply style: ground-control

<!-- Paste this whole block into AGENTS.md, CLAUDE.md, .github/copilot-instructions.md, or a Cursor rule. Edit the three lines under "Who is reading" first. -->

Five problems, five sections, same numbers. Apply all five in every answer.

"""

FOOTER = """
### One rule only for shared instruction files

An agent writing a report for another agent, not for a person, leaves the WHERE WE STAND table out. The table exists so a human can catch up in ten seconds; a receiving agent reads the whole reply anyway, and the table costs it tokens for nothing. Every other rule in sections 1 to 5 still holds.
"""

EDIT_ME_COMMENT = (
    '<!-- EDIT ME. "Already knows" lists what the agent may use with no '
    'definition. "New to" lists stacks where every term gets one. "Runs" says '
    'how many agent sessions you juggle. -->'
)
EDIT_ME_VISIBLE = (
    '*Edit me: describe yourself as the reader. "Already knows" lists what the '
    'agent may use with no definition. "New to" lists stacks where every term '
    'gets one. "Runs" says how many agent sessions you juggle.*'
)


def main() -> None:
    body = STYLE.read_text().split("---\n", 2)[2]

    lines = body.splitlines()
    start = next(i for i, line in enumerate(lines) if line.startswith("## Which section"))
    body = "\n".join(lines[start:])

    out, in_fence = [], False
    for line in body.splitlines():
        if line.startswith("```"):
            in_fence = not in_fence
        if not in_fence and re.match(r"^#{2,4} ", line):
            line = "#" + line
        out.append(line)
    body = "\n".join(out).replace(EDIT_ME_COMMENT, EDIT_ME_VISIBLE)

    TARGET.write_text(HEADER + body.rstrip() + "\n" + FOOTER)
    print(f"wrote {TARGET.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
