---
description: Feynman Technique check. You explain a topic or an ID from a breakdown in your own words; it marks each claim right, partly right or wrong and points at your gaps, without giving you the answer.
argument-hint: '[ID | topic] "your explanation"'
disable-model-invocation: true
allowed-tools: Read Grep Glob
---

# Feynman check

Input: $ARGUMENTS

## Core rule

This skill checks the user's understanding. It must NOT give the full correct explanation. Giving the answer first creates the illusion of knowledge, which is exactly what the Feynman Technique fights.

## Other rules

- Tone: friendly and encouraging, like a good teacher. Never mocking.
- Answer in the language the user writes in.
- The breakdown lives in this conversation only. Write no files.

## Read the input

- **Only an ID or topic, no explanation:** ask the user to explain it in their own words first, in 2–5 sentences. Do not explain it yourself. Stop there.
- **An explanation is given:** check it against the earlier breakdown in this conversation (if the ID exists there) and, for code topics, against the actual code.

## Output format

1. **Table:** `# | Your claim | Verdict | Why`
   - Split the explanation into separate claims.
   - Verdict: ✅ correct, ⚠️ partly right, ❌ wrong.
   - `Why`: one short sentence. For ❌ and ⚠️, give a hint or a question that points toward the answer, not the answer itself.
2. **❓ Missing:** important pieces the user didn't mention. Name them by ID if they exist in the breakdown (e.g. `H1.2.2`), with a one-line hint, not the full explanation.
3. **Jargon check:** words the user used without explaining them, if any ("Would a 10-year-old know what 'middleware' means?").
4. **Score:** e.g. `3 of 5 pieces understood`.
5. **Next step:** exactly one line, e.g. `Try again, or zoom in with /g-dev:feynman H1.2.2`.
