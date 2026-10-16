---
description: Feynman Technique breakdown. Splits a topic into 2-5 small pieces with stable IDs (H1, H1.2) and explains each in one simple sentence. Pass a new topic, or an ID from an earlier breakdown to zoom into it.
argument-hint: "[topic | ID]"
disable-model-invocation: true
allowed-tools: Read Grep Glob
---

# Feynman breakdown

Input: $ARGUMENTS

## Rules that always apply

- Never sacrifice correctness for simplicity. If a simple explanation loses something important, say so under ⚠️ Simplified.
- Existing IDs never change. Never renumber. Never invent an ID that is not in this conversation.
- Output only what "Output format" lists, in that order. No intro, no summary, no wall of text. This overrides any output style: add no closing table or status block after part 6.
- Diagrams are ASCII trees, max 80 characters wide. Use `├──`, `└──`, `│`. No boxes, no images.
- Answer in the language the user writes in.
- The breakdown lives in this conversation only. Write no files.

## Read the input

The input is one of:

1. **A new topic** (free text, e.g. `what is an agent harness`).
   - Pick a short uppercase prefix that fits the topic and is not already used in this conversation (e.g. `H` for harness, `A` for architecture).
   - The topic itself is the root ID (e.g. `H`). Produce its children `H1`, `H2`, …
2. **An existing ID** (something like `H1`, `H1.2`, `A3.1.2`).
   - Find that row in earlier output in this conversation. If it is not there, say so in one line and ask for the topic. Don't invent it.
   - Break only that row down into children (`H1.2` → `H1.2.1`, `H1.2.2`, …).
   - If that row is marked 🟢 (an atom), still break it down, but open with the atom warning from "Output format".

## Code topics

If the topic is about the current repository (e.g. `the architecture of this project`, `how auth works here`), read the actual code first and ground every row in it. Add a `Where` column with real file paths. Never guess a file path.

## Output format

Always the same six parts, in this order. Only when zooming into a 🟢 row, put this line before part 1:
`🟢 <ID> is an atom: going deeper adds detail, not understanding.`

1. **Breadcrumb:** e.g. `H > H1 > H1.2`
2. **One sentence:** what this node is, as if explained to a 10-year-old.
3. **ASCII tree:** the node and its direct children only, with IDs and short names.
4. **Table:** `ID | Piece | Simple explanation` (+ `Where` for code topics).
   - 2–5 children. Never more than 5.
   - Each explanation: one sentence, max ~20 words, no unexplained jargon. Use everyday analogies where they help.
   - Mark a row with 🟢 when it is an "atom": it can't be usefully split further.
5. **⚠️ Simplified:** one line (one short sentence) per row where the simple version loses something important, saying what is lost. Omit this part if nothing was simplified away.
6. **Next:** one line suggesting which ID to zoom into next (the least obvious piece). Never suggest a 🟢 row. If every row is 🟢, say this branch is fully understood.

## Example

Expected output for `/g-dev:feynman H1`, after an earlier harness breakdown:

````markdown
H > H1

A model is a brain that can only read text and write text.

```
H1 Model
├── H1.1 What it receives
├── H1.2 What it returns
├── H1.3 What happens inside
└── H1.4 What it can't do alone
```

| ID | Piece | Simple explanation |
|---|---|---|
| H1.1 | What it receives | Text: instructions, the conversation, and tool results |
| H1.2 | What it returns | Text: an answer for you, or a request to use a tool |
| H1.3 | What happens inside | It writes text one small piece at a time |
| H1.4 | What it can't do alone | It can't remember, open files or browse; the harness does that |

⚠️ Simplified: H1.3 — "one piece at a time" hides that each piece is a token, not a word.

Next: H1.3 — the least obvious part.
````
