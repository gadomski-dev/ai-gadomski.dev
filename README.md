# ai-gadomski.dev

One Claude Code plugin, **g-dev**, with one output style and three skills:

- **ground-control**, an output style that stops your agent writing like an alien genius in a basement.
- **feynman**, **feynman-check** and **feynman-html**, three skills that apply the Feynman Technique to whatever your agent explains. See [Feynman skills](#feynman-skills).

By Krystian Gadomski, [gadomski.dev](https://gadomski.dev)

An [output style](https://code.claude.com/docs/en/output-styles) is a Markdown file of instructions that Claude Code sends with every request. It changes how the agent writes to you, not how it codes.

```shell
claude plugin marketplace add gadomski-dev/ai-gadomski.dev
claude plugin install g-dev@gadomski.dev
```

The same two commands work on macOS, Linux and Windows. Then type `/output-style g-dev:ground-control` in a new session, or try a skill with `/g-dev:feynman what is an agent harness`. Why the rules look the way they do: [docs/why.md](docs/why.md).

## Five problems, five sections

The style file is [`output-styles/ground-control.md`](output-styles/ground-control.md). It opens with this same map, so you can always see which section fixes which problem.

| # | The problem | Section | What changes in every reply |
|---|---|---|---|
| 1 | You read the reply twice and still do not follow it. Too long, too clever, not human | 1 Speak like a human | The first sentence is the answer. Sentences stay at 20 words or fewer. Terms you do not know get a definition of max 12 words. No flattery, no emoji, no em dashes |
| 2 | You run several agents and forget which one does what | 2 Don't get lost across agents | Every reply ends with a 3-row `WHERE WE STAND` table: the session goal, the task right now, and why it matters. The agent says so when the task drifts off the goal |
| 3 | The explanation is correct and still useless | 3 Explain it simply | Consequence before mechanism. Measured numbers instead of adjectives, with "estimate" marked when unmeasured. Data in tables, layouts with an everyday comparison and a text diagram. Mistakes open with "I was wrong" |
| 4 | The agent cites a decision, a requirement or a file you no longer remember | 4 No bare references | Every identifier carries one sentence of what it is, at every occurrence. When the content is gone, the agent writes `not in context, remind me` instead of guessing |
| 5 | You leave for a day, come back, and have no idea where to resume or what to do next | 5 Catch up in ten seconds | The same table grows to 7 rows: answer, recommendation, next step, what is still unanswered. One question per message, max 3 options, each with a cost, and one bold recommendation with a fallback |

Sections 2 and 5 build the same table. Section 2 gives it 3 rows, section 5 grows it to 7, and only section 5 prints the full template, so the file never carries two templates for one table.

## What a reply looks like

The question: *"Can we merge the price cache branch?"*

**Before**, the default:

> Great question! Let me take a look at where things stand. I checked the branch, re-ran the suite, and looked at the diff again. Per D12 and the approach we aligned on in FR-7, the load-bearing piece here is the invalidation layer, which now sits behind the adapter seam. There are a few edge cases worth flagging, and a couple of tests are a bit flaky. Overall it's in pretty good shape, but there are some trade-offs to consider. Let me know how you'd like to proceed!

**After**, with ground-control:

> Not yet: 2 of 148 tests fail, and both show an old price after an edit.
>
> Merging now means a shopper can see an old price for up to 10 minutes. The fix is one line in `invalidate()`, the function that clears cached prices after a write. Fixing it and re-running the tests takes about 5 minutes (estimate; the re-run settles it).
>
> **Recommendation: let me fix it and re-run before you merge.** If the re-run fails again, merge without the cache and fix it separately.
>
> ---
>
> | **WHERE WE STAND** | |
> |---|---|
> | 🧭 **Session goal** | make the product page load in under one second |
> | 🎯 **Doing** | checking whether the price cache is safe to merge |
> | ❓ **Why** | shoppers wait 2.4 seconds for prices on the product page today |
> | ✅ **Answer** | not yet, because two failing tests show old prices after an edit |
> | ⭐ **Recommendation** | fix the clearing step and re-run before merging, because shoppers would otherwise see old prices |
> | ➡️ **Next step** | me: fix and re-run once you say yes |
> | 🧩 **Unanswered** | none |
>
> | **New in this message** | |
> |---|---|
> | `invalidate()` | the function that clears cached prices after a write |

Both replies above are written for this README, not captured from a session.

## Feynman skills

Your agent explains a bug or an architecture, you read it, you nod, and you still could not explain it back. The Feynman Technique says you understand something only when you can explain it in plain words. These skills break a topic into pieces small enough for one simple sentence each, check your own explanation and show your gaps without handing you the answer, and draw the breakdown as a page.

The core idea: **Me first. AI second. Then compare.**

| Command | What it does | Example |
|---|---|---|
| `/g-dev:feynman <topic or ID>` | Splits a topic into 2 to 5 pieces with IDs such as `H1` and `H1.2`, each explained in one simple sentence. Pass an ID from an earlier breakdown to zoom into that piece only | `/g-dev:feynman what is an agent harness` |
| `/g-dev:feynman-check <ID or topic> "<your explanation>"` | Marks each claim in your explanation as right, partly right or wrong, and lists what you missed, with hints instead of the answer | `/g-dev:feynman-check H1.2 "the model returns code that the harness runs"` |
| `/g-dev:feynman-html <topic or ID>` | Does what `/g-dev:feynman` does, then draws the whole breakdown as an HTML page in the gadomski.dev colours: a clickable tree diagram and one table per zoom-in. Opens it in your browser, or reloads the tab when the page is already open (reloading needs macOS with Safari or Chrome). With no input, it redraws the page | `/g-dev:feynman-html what is an agent harness`, then `/g-dev:feynman-html H1` |

The breakdown lives in the current session only, so in a new session `/g-dev:feynman H1` has no `H1` to find and asks you for the topic. The only file written is the page from `/g-dev:feynman-html`, in your system's temporary folder.

## Install

The `claude` and `git` commands below are the same on macOS, Linux and Windows. Only copying the file by hand differs, so that part has a block per system.

On Windows, `~/.claude` in this README means `%USERPROFILE%\.claude`, for example `C:\Users\you\.claude`. Running Claude Code inside WSL, the Linux layer for Windows? Use the Linux commands inside WSL.

### As a plugin

```shell
claude plugin marketplace add gadomski-dev/ai-gadomski.dev
claude plugin install g-dev@gadomski.dev
```

Then start a new Claude Code session, or run `/reload-plugins` in one already open. Until then `/output-style` does not know the style and the `/g-dev:` skills do not exist. Check with `claude plugin list`, which lists `g-dev@gadomski.dev` as enabled.

To update later:

```shell
claude plugin marketplace update gadomski.dev
claude plugin update g-dev@gadomski.dev
```

### Try it without installing

```shell
git clone https://github.com/gadomski-dev/ai-gadomski.dev.git
claude --plugin-dir ./ai-gadomski.dev
```

The plugin is loaded for that one session only.

### Only the output style, by copying the file

For every project on your machine:

**macOS and Linux** (also Git Bash on Windows):

```bash
git clone https://github.com/gadomski-dev/ai-gadomski.dev.git ~/ai-gadomski.dev
mkdir -p ~/.claude/output-styles
cp ~/ai-gadomski.dev/output-styles/ground-control.md ~/.claude/output-styles/
```

**Windows** (PowerShell):

```powershell
git clone https://github.com/gadomski-dev/ai-gadomski.dev.git "$HOME\ai-gadomski.dev"
New-Item -ItemType Directory -Force "$HOME\.claude\output-styles" | Out-Null
Copy-Item "$HOME\ai-gadomski.dev\output-styles\ground-control.md" "$HOME\.claude\output-styles\"
```

For one project only, run the clone line above, then at the project root:

**macOS and Linux** (also Git Bash on Windows):

```bash
mkdir -p .claude/output-styles
cp ~/ai-gadomski.dev/output-styles/ground-control.md .claude/output-styles/
```

**Windows** (PowerShell):

```powershell
New-Item -ItemType Directory -Force .claude\output-styles | Out-Null
Copy-Item "$HOME\ai-gadomski.dev\output-styles\ground-control.md" .claude\output-styles\
```

Claude Code reads style files at start, so restart it after copying.

## Switch style

Run `/config` and pick it under **Output style**, or type the command below. It applies from your next message.

| Installed as | Command in a session | `outputStyle` value in a settings file |
|---|---|---|
| Plugin | `/output-style g-dev:ground-control` | `"g-dev:ground-control"` |
| Copied file | `/output-style ground-control` | `"ground-control"` |

The command ignores case. The settings value does not: a value that does not match the name exactly gives you the Default style with no error. To use it in every project, set `outputStyle` in `~/.claude/settings.json` (`%USERPROFILE%\.claude\settings.json` on Windows).

## Make it yours

The style opens with a **Who is reading** block. Edit its three lines before anything else:

- **Already knows:** what the agent may use with no definition. The default is general software engineering: git, HTTP, JSON, REST, webhooks, caching, async code, CI, SQL, DOM, CSS, tests.
- **New to:** stacks where every term should get a definition, such as Kubernetes or Rust.
- **Runs:** how many agent sessions you run at once. The default is 3 to 10.

To edit it, copy the file into `~/.claude/output-styles/` and change it there. A plugin's own files are replaced on every update. To keep only some of the fixes, delete the sections you do not want, remove their rows from the map table, and give the file a new `name:` in its header. If you drop section 5 but keep section 2, the 3-row table in section 2 still stands on its own.

## Not on Claude Code?

[`universal/AGENTS.md`](universal/AGENTS.md) holds the same five sections as a plain block with no Claude Code header. It adds one rule: an agent reporting to another agent, not to a person, leaves the `WHERE WE STAND` table out. The Feynman skills are not part of it: they are written and tested for Claude Code only.

| Tool | Where to paste it |
|---|---|
| Codex, Cursor and other tools that read `AGENTS.md` | `AGENTS.md` at the repository root |
| Claude Code without the plugin | `CLAUDE.md` in the project, or `~/.claude/CLAUDE.md` for every project |
| GitHub Copilot | `.github/copilot-instructions.md` |
| ChatGPT | Does not fit whole. The block runs about 14,000 characters, and section 5 alone about 5,500. Custom instructions were reported in July 2026 to hold 5,000 characters on paid plans and 1,500 on the free plan. On a paid plan, **Who is reading** (about 1,300) plus one or two of sections 1 to 4 fits. Check the limit ChatGPT shows you before pasting |

## Limits

- **An output style is an instruction, not a guarantee.** Built-in styles get a short reminder of their rules on every turn. A custom style gets only "Remember to follow the specific guidelines for this style" (checked in Claude Code 2.1.287), so in a long session the rules can fade. When the `WHERE WE STAND` table stops appearing, ask the agent to follow its output style, or start a new session.
- **Subagents do not see output styles, except forks.** The style shapes the main conversation and any fork of it, a subagent that copies the whole conversation. Other subagents run their own instructions, so their reports come back unstyled.
- **It costs input tokens.** The file is about 13,900 characters, roughly 3,500 tokens by the 4-characters-per-token rule of thumb, sent with every request. Prompt caching cuts that cost after the first request in a session.

## Maintainers

Raise `"version"` in [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) with every change under `output-styles/` or `skills/`. Claude Code caches an installed plugin by that string, so an unchanged version never reaches users who already installed it. The `Plugin version` check ([`scripts/check-version-bump.sh`](scripts/check-version-bump.sh)) fails a pull request that forgets. Tag each release with `claude plugin tag --push`.

`universal/AGENTS.md` is generated from the style file, so change the style first and regenerate, never the other way round. Regenerate from the repository root, then commit both files:

```bash
python3 scripts/build-universal.py
```

## License

[MIT](LICENSE)
