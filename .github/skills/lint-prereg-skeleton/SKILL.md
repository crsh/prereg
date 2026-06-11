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

Skip the two reference templates (`vantveer_prereg`, `secondary_data_analysis_prereg`) if they are already correctly formatted — they are the source of truth.

### 2. Read the file and apply all rules in order

Work through each rule from [formatting-rules.md](./references/formatting-rules.md):

1. **No trailing whitespace** — strip trailing spaces/tabs from every line.
2. **No blank line between heading and comment** — remove any blank lines that appear between an `##`/`#` heading and the immediately following `<!--`.
3. **No blank start inside comment** — if a comment opens as `<!--` followed only by whitespace on the same line (e.g., `<!-- \n` or `<!--\n\n`), replace with `<!--` immediately followed by the first line of content.
4. **Closing `-->` on the last content line** — ensure `-->` appears at the end of the final content line of each comment, not on its own line (unless the comment is a standalone single-word or structural comment).
5. **One blank line between comment close and prompt** — after `-->`, there must be exactly one blank line before `Enter your response here.`
6. **Two blank lines between prompt and next heading** — after `Enter your response here.` (or the last non-blank line of section content), there must be exactly two blank lines before the next `#` or `##` heading.
7. **Numbered list style** — inside comments, numbered items use `1.` format (number + period + space). Nested items are indented with 4 spaces.
8. **Bulleted list style** — inside comments, bullet items use `- ` (dash + space). Nested items are indented with 4 spaces.

### 3. Verify the YAML front matter and References section

Do **not** alter:
- The YAML front matter block (`---` ... `---`)
- The `# References` section and the LaTeX spacing commands that follow it
- Any R inline code (`` `r ...` ``)
- Content inside `<!-- ... -->` blocks other than fixing trailing whitespace and the comment-open style

### 4. Show a diff and confirm before writing

Present the proposed changes as a unified diff. Apply only after the user confirms (or immediately if instructed to apply without confirmation).

### 5. Check the result

After writing, verify:
- No line has trailing whitespace.
- Every `##`/`#` heading is immediately followed by a comment or content (no blank line in between, unless the section has no comment).
- Every comment close (`-->`) is followed by exactly one blank line, then the prompt.
- Every prompt is followed by exactly two blank lines, then the next heading.
