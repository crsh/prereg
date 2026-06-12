---
name: lint-prereg-skeleton
description: "Lint and format prereg skeleton.Rmd files. Use when applying consistent Markdown formatting to R Markdown preregistration templates in inst/rmarkdown/templates/*/skeleton/skeleton.Rmd. Fixes spacing between headings, HTML comments, and prompts; normalises list styles; removes trailing whitespace."
argument-hint: "path to skeleton.Rmd (or omit to format all templates)"
---

# Lint Prereg Skeleton

Applies consistent Markdown formatting to `skeleton.Rmd` preregistration templates.
The canonical references are `vantveer_prereg` and `secondary_data_analysis_prereg`.

See [detailed rules with examples](./references/formatting-rules.md).

## When to Use

- Adding a new template to `inst/rmarkdown/templates/`
- Editing an existing skeleton and wanting to restore consistent style
- Auditing all templates for formatting consistency

## Procedure

### 1. Identify the target file(s)

If an argument is given, format that file. Otherwise format every file matching:

```
inst/rmarkdown/templates/*/skeleton/skeleton.Rmd
```

### 2. Read the file and apply all rules in order

Work through each rule from [formatting-rules.md](./references/formatting-rules.md):

1. **No trailing whitespace** — strip trailing spaces/tabs from every line.
2. **Comment delimiter spacing** — ensure exactly one space after `<!--` and before `-->` when adjacent to text on the same line. Fix `<!--text` → `<!-- text` and `text-->` → `text -->`.
3. **No blank line between heading and comment** — remove any blank lines between a heading and the immediately following `<!--`.
4. **No blank start inside comment** — if a comment opens with `<!--` followed by a blank line, remove the blank line so content begins on the next line.
5. **Closing `-->` on the last content line** — move any standalone `-->` on its own line to the end of the preceding content line.
6. **Prompt text** — the standard prompt is always `Enter your response here.` (with a trailing period).
7. **Section type spacing** — apply spacing based on section type:
   - *Type A (open-text)*: `-->` → 1 blank line → `Enter your response here.` → 2 blank lines → next heading.
   - *Type B (multiple-choice)*: heading or `-->` → 1 blank line → options (no prompt) → 2 blank lines → next heading.
   - *Type C (instructional/standalone)*: `-->` → 2 blank lines → next heading (no prompt).
8. **`\newpage` spacing** — ensure exactly 2 blank lines before and after every `\newpage`.
9. **Heading roles** — `#` headings take only a Type C instructional comment or are followed directly by a `##`. When a `##` is immediately followed by a `###`, rules apply to the `###`. See formatting-rules.md Rule 8.
10. **Numbered list style** — everywhere (in comments and main content), numbered items use `N. ` (number + period + space), no leading whitespace, nested items indented 4 spaces. Remove leading question-number prefixes like `1)` from comment openers.
11. **Bulleted list style** — everywhere, `- ` (dash + space) is the only acceptable unordered marker. Replace `* `, `*text`, and `-text` with `- `. No leading whitespace on first-level items; nested items indented 4 spaces.

### 3. Verify the YAML front matter and References section

Do **not** alter:
- The YAML front matter block (`---` ... `---`)
- The `# References` section and the LaTeX spacing commands that follow it
- R inline code (`` `r ...` ``)
- The *prose content* of comment blocks — only list markers, indentation, whitespace, and question-number prefixes within them may change
- Blank lines within a comment block that separate paragraphs — those are intentional
- Markdown tables and fenced code blocks

### 4. Show a diff and confirm before writing

Present the proposed changes as a unified diff. Apply only after the user confirms (or immediately if instructed to apply without confirmation).

### 5. Check the result

After writing, verify:
- No line has trailing whitespace.
- Every `<!--` adjacent to text has a space after it; every `-->` adjacent to text has a space before it.
- Every heading is immediately followed by a comment or content with no blank line between them.
- Type A sections: `-->` → 1 blank → prompt → 2 blank → next heading.
- Type B sections: choices → 2 blank → next heading (no prompt).
- Type C sections: `-->` → 2 blank → next heading (no prompt).
- Every `\newpage` has 2 blank lines before and after.
- All lists use `N. ` or `- ` markers with correct indentation, everywhere.
