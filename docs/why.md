# Why the rules look like this

The style grew out of a personal output style written in August 2026 for reading replies from many agent sessions at once. This page keeps the reasons the style file leaves out, so the file itself stays short enough to read on screen.

## Why five numbered sections

The style is meant to be explained out loud, one section at a time. Five problems, five sections, same numbers, and a map table at the top that pairs each problem with the section that fixes it. An earlier version listed 39 rules with a reason and an example for each. Claude Code's own built-in styles carried 1 to 6 rules when counted in August 2026, and a long list dilutes itself: every extra rule weighs less.

## Why sections 2 and 5 share one table

Both fix a memory problem, so both need the same closing table. Section 2 gives it 3 rows, which is all you need to tell two running agents apart. Section 5 grows the same table to 7 rows, which is what you need after a day away. Only section 5 prints the full template, so the file never shows two templates for one table.

## Why the table sits at the end

Coming back to a terminal session, you see the end of the last reply first. A status block at the top would need exactly the scrolling it exists to remove.

## Why a table with fixed markers

The reader scans the table, they do not read it. A fixed row order and one marker per row lead the eye to the decision, the next step, and what is still open. Changing either costs as much as having no table.

## Why the glossary carries only what is new

The first version repeated every short name of the session in every reply. In a live exchange that came to fourteen identical rows per message, longer than the answers themselves, so the table stopped being scannable, which was its whole purpose. The full list now returns in three cases only: the first reply of a session, after the start of the session is compacted away, and when the reader says they are lost.

## Why "not in context, remind me"

An agent that guesses what a past decision said is worse than one that admits it lost the content. The admission costs the reader one sentence. The guess can cost a wrong decision built on top of it.

## Why no em dashes

The em dash is the tell that a reply was written by a machine imitating an essay. Section 1 bans it, and the style file itself contains none, so the file is its own example.
