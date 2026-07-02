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

### 2. Apply the lint script

Run `.github/skills/lint-prereg-skeleton/lint_skeleton.R` on the target file(s):

```bash
Rscript .github/skills/lint-prereg-skeleton/lint_skeleton.R <path/to/skeleton.Rmd>
```

The script automates Rules 1–11 (see [formatting-rules.md](./references/formatting-rules.md)):
trailing whitespace, comment delimiter spacing, blank-line removal between headings and comments,
prompt-text normalisation, section spacing, `\newpage` padding, bullet style, and sentence-case headings.

### 3. Verify script output

Review the diff produced by the script. Check that every automated rule has been applied correctly and consistently — the script may mis-classify edge cases (e.g. bold sub-labels inside `##` sections, slash-compound headings). If a rule was applied incorrectly:

- Evaluate whether the script can be improved to handle the case.
- If so, update `lint_skeleton.R` and re-run before continuing.
- Otherwise, revert the incorrect change manually.

### 4. Apply remaining rules manually

Work through the rules the script does **not** cover, and fix any edge cases the script missed:

- **Rule 12 — Spelling and grammar**: fix clear spelling errors and obvious grammar errors in headings and comment text. Preserve original wording and intent; do not paraphrase. Leave examples, R code, LaTeX, and YAML untouched.
- **Missing prompts**: add `Enter your response here.` to any Type A section that lacks one.
- **Encoding issues**: correct any garbled characters (e.g. `Í` → `'`).

### 5. Verify the YAML front matter and References section

Do **not** alter:
- The YAML front matter block (`---` ... `---`)
- The `# References` section and the LaTeX spacing commands that follow it
- R inline code (`` `r ...` ``)
- The *prose content* of comment blocks — only list markers, indentation, whitespace, question-number prefixes, and clear spelling/grammar errors within them may change
- Blank lines within a comment block that separate paragraphs — those are intentional
- Markdown tables and fenced code blocks

### 6. Final check

After writing, verify:
- No line has trailing whitespace.
- Every `<!--` adjacent to text has a space after it; every `-->` adjacent to text has a space before it.
- Every heading is immediately followed by a comment or content with no blank line between them.
- Type A sections: `-->` → 1 blank → prompt → 2 blank → next heading.
- Type B sections: choices → 2 blank → next heading (no prompt).
- Type C sections: `-->` → 2 blank → next heading (no prompt).
- Every `\newpage` has 2 blank lines before and after.
- All lists use `N. ` or `- ` markers with correct indentation, everywhere.
- All heading text (except `# References`) is in sentence case.
