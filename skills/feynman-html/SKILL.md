---
description: Feynman Technique page. Does what /g-dev:feynman does, then draws the whole breakdown as a gadomski.dev-branded HTML page, with a clickable tree diagram and one table per zoom-in, and opens it in the browser, or reloads the tab if the page is already open.
argument-hint: "[topic | ID]"
disable-model-invocation: true
allowed-tools: Read Grep Glob Bash(bash ${CLAUDE_SKILL_DIR}/scripts/render.sh *)
---

# Feynman page

Input: $ARGUMENTS

## Rules that always apply

- A breakdown made here follows the `feynman` skill exactly. Before you write one, read `${CLAUDE_PLUGIN_ROOT}/skills/feynman/SKILL.md` and follow it, using the input above.
- The page shows only what this conversation's breakdown output says. Copy names, sentences and explanations word for word. Never add, reword, re-explain or invent a piece.
- Write no files yourself. The script below writes the page.
- Your reply is the breakdown, if this run made one, then the one line the script prints. Nothing else. This overrides any output style: no closing table, no summary.

## What to do with the input

| Input | Breakdown to make first | Page focus |
|---|---|---|
| A new topic (free text) | The root breakdown, as `/g-dev:feynman <topic>` would make it | the root |
| An ID in this conversation that is not broken down yet | That ID's breakdown, as `/g-dev:feynman <ID>` would make it, atom warning included | that ID |
| An ID that is already broken down, or a root prefix such as `H` | None | that ID |
| Nothing | None | the ID broken down last |

- If the input is an ID that is not in this conversation, say so in one line. Don't invent it. Stop there.
- If there is no input and no breakdown in this conversation, say so in one line and suggest `/g-dev:feynman-html <topic>`. Stop there.

## Build the data

Collect every row of the breakdown with that root from this conversation: the root, and every zoom-in under it, including one you just made. Build one JSON object:

```json
{
  "title": "what is an agent harness",
  "focus": "H1",
  "nodes": [
    { "id": "H", "name": "Agent harness", "sentence": "…", "next": "H4, the least obvious piece." },
    { "id": "H1", "name": "Model", "explanation": "…", "sentence": "…", "next": "…" },
    { "id": "H1.1", "name": "What it receives", "explanation": "…", "atom": true, "simplified": "…" }
  ]
}
```

| Field | Include it | Copy from |
|---|---|---|
| `title` | always | the topic as the user typed it |
| `focus` | always | the page focus chosen above |
| `id` | every node | the ID, e.g. `H1.2` |
| `name` | every node | the short name from the tree or table; for the root, the root's tree label |
| `explanation` | every node except the root | its "Simple explanation" cell |
| `where` | code topics only | its "Where" cell |
| `atom` | rows marked 🟢 | `true` |
| `simplified` | rows with a ⚠️ Simplified line | that line's text, without the ID |
| `sentence` | nodes that were broken down | the one-sentence line of that breakdown |
| `next` | nodes that were broken down | the "Next:" line of that breakdown, without "Next:" |

List every parent before its children. Use plain text: no Markdown, no emoji.

## Render

Run this, with the root prefix in place of `H` and the JSON between the two marker lines:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/render.sh ${CLAUDE_SESSION_ID} H <<'FEYNMAN_JSON'
{ "title": "…", "focus": "…", "nodes": [ … ] }
FEYNMAN_JSON
```

If the script says the JSON is invalid, fix the JSON and run it again.
