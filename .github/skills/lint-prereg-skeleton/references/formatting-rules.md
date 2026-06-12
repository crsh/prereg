# Prereg Skeleton Formatting Rules

Canonical examples: `inst/rmarkdown/templates/vantveer_prereg/skeleton/skeleton.Rmd`
and `inst/rmarkdown/templates/secondary_data_analysis_prereg/skeleton/skeleton.Rmd`.

---

## Rule 1 — No trailing whitespace

Every line must end immediately after the last visible character.

```
# ✗ Wrong
<!-- Describe the study.   
-->

# ✓ Correct
<!-- Describe the study.
-->
```

---

## Rule 2 — Comment delimiter spacing

When `<!--` or `-->` appears adjacent to text on the same line, exactly one space must
separate the delimiter from the text.

```
# ✗ Wrong — no space after <!--
<!--Describe the study. -->

# ✗ Wrong — no space before -->
<!-- Describe the study.-->

# ✗ Wrong — no space on either side
<!--Describe the study.-->

# ✓ Correct — single-line
<!-- Describe the study. -->

# ✓ Correct — multi-line (space after <!-- on first line; space before --> on last line)
<!-- List variables:
1. Independent variables.
2. Dependent variables. -->
```

When `<!--` is on its own line (multi-line comment opener), no trailing space is needed
on that line:

```
# ✓ Correct — opener on its own line
<!--
1. Independent variables.
2. Dependent variables. -->
```

This rule also applies to inline comments embedded in content lines:

```
# ✗ Wrong
**We plan to make the data available:** <!--select-->

# ✓ Correct
**We plan to make the data available:** <!-- select -->
```

---

## Rule 3 — No blank line between heading and comment

A heading is immediately followed on the next line by `<!--`. No empty line between them.
See Rule 8 for which heading levels take a comment.

```
# ✗ Wrong
## Hypotheses and rationale

<!-- Provide all hypotheses... -->

# ✓ Correct
## Hypotheses and rationale
<!-- Provide all hypotheses... -->
```

---

## Rule 4 — No blank start inside a comment block

The comment opener `<!--` must be followed by content on the same line, or (for multi-line
comments) content on the very next line — never by a blank line.

```
# ✗ Wrong (blank line at start of comment)
## Planned Sample
<!--

1. Describe pre-selection rules.
2. Justify planned sample size. -->

# ✓ Correct — text on same line as <!--
## Study title
<!-- Provide the working title of your study. -->

# ✓ Correct — multi-line, text on next line (no blank)
## Design
<!--
1. Independent variables with all their levels
2. Dependent variables. -->
```

---

## Rule 5 — Closing `-->` on the last content line

The HTML comment close `-->` appears at the end of the last content line inside the
comment. It does **not** occupy its own line.

```
# ✗ Wrong
<!-- Describe manipulations.
-->

# ✓ Correct
<!-- Describe manipulations. -->

# ✗ Wrong (multi-line)
<!-- List hypotheses:
1. Directional relationships.
2. Interaction shapes.
-->

# ✓ Correct (multi-line)
<!-- List hypotheses:
1. Directional relationships.
2. Interaction shapes. -->
```

---

## Rule 6 — Prompt text

The standard response prompt is always **`Enter your response here.`** — exactly this
wording, with a trailing period.

---

## Rule 7 — Section types and spacing

Every `##` (or `###`) question heading introduces one of three section types. The spacing
rules differ by type.

### Type A — Open-text section

An instructional comment is followed by the standard prompt.

```
## Heading
<!-- Instruction. -->

Enter your response here.


## Next heading
```

- Exactly **1** blank line between `-->` and `Enter your response here.`
- Exactly **2** blank lines between `Enter your response here.` and the next heading

### Type B — Multiple-choice section

A list of selectable options replaces the free-text prompt. The instructional comment is
optional. There is **no** `Enter your response here.` in these sections.

```
# ✓ Correct — with optional comment
## Heading
<!-- Select one. -->

- Option A
- Option B
- Option C


## Next heading

# ✓ Correct — no comment
## Heading

- Option A
- Option B


## Next heading
```

- Exactly **1** blank line between the heading (or `-->`) and the first option
- Exactly **2** blank lines between the last option and the next heading

### Type C — Instructional / standalone comment

`#` section headings and standalone comment blocks (e.g., a preamble before the first
heading) are followed by a comment that gives context for the whole section or document.
There is **no** prompt after these comments.

```
# ✓ Correct — # heading with instructional comment
# Section heading
<!-- Instructional note about this whole section. -->


## First question in section
<!-- Instruction. -->

Enter your response here.
```

```
# ✓ Correct — standalone preamble comment before first heading
<!-- General note for readers of this template. -->


## First question
```

- Exactly **2** blank lines between `-->` and the next heading
- No prompt follows the comment

### `\newpage` spacing

LaTeX `\newpage` commands always have exactly **2** blank lines before and **2** blank
lines after:

```
# ✗ Wrong
Enter your response here.

\newpage
# Next section

# ✓ Correct
Enter your response here.


\newpage


# Next section
```

---

## Rule 8 — Heading roles

- **`#` headings** are section headings. They are followed either by a Type C instructional
  comment or directly by the first `##` sub-heading (no blank line).
- **`##` headings** are question headings. They govern a Type A or Type B section.
- **`###` headings** are sub-question headings. When a `##`-heading is immediately followed
  by a `###`-heading (the `##` acts as a grouping label), the comment/prompt/spacing rules
  apply to the `###`-heading, not the `##`.

```
# ✓ Correct — ## acting as grouping label, rules apply to ###
## T1
### Title
<!-- Provide the working title. -->

Enter your response here.


## T2
### Next question
<!-- Instruction. -->

Enter your response here.
```

---

## Rule 9 — Numbered list style

First-level items use `N. ` (number + period + space) with **no leading whitespace**.
Nested items are indented with **4 spaces**.

This rule applies **both inside comments and in the main content area**.

Also remove leading question-number prefixes (e.g., `1)`, `2)`) from the opening of
comment text. These appear in some templates as inherited question numbering but are
handled automatically by the LaTeX template and should not appear in the comment itself.

```
# ✗ Wrong — wrong markers, question-number prefix in comment
<!-- 1) What is the main question?
  (2) Second item
    a. Nested -->

# ✓ Correct
<!-- What is the main question?
1. First sub-item.
    1. Nested sub-item. -->
```

---

## Rule 10 — Bulleted list style

`- ` (dash + space) is the **only** acceptable unordered list marker. This rule applies
**both inside comments and in the main content area**.

Replace all of the following with `- `:
- `* ` or `*` directly against text (asterisk markers)
- `-` directly against text without a following space

First-level items have **no leading whitespace**. Nested items are indented with **4 spaces**.

```
# ✗ Wrong — asterisk markers, leading whitespace
<!-- Include:
  * type of data,
  * general content. -->

# ✗ Wrong — asterisk directly against text (main content)
*Registration prior to creation of data
*Registration prior to any human observation of the data

# ✗ Wrong — dash directly against text, unnested sub-items
<!--
1. What are other constructs?
* These could be
-mediators,
-moderators. -->

# ✓ Correct — inside comment
<!-- Include:
- type of data (e.g., cross-sectional, longitudinal),
- general content and domains covered. -->

# ✓ Correct — in main content area
- Registration prior to creation of data
- Registration prior to any human observation of the data

# ✓ Correct — nested sub-items indented
<!--
1. What are other constructs?
- These could be
    - mediators,
    - moderators. -->
```

---

## Summary table

| Location | Rule |
|---|---|
| Line ending | No trailing whitespace |
| Comment delimiters | Space after `<!--` and before `-->` when adjacent to text |
| Heading → comment | No blank line between heading and `<!--` |
| Comment open | Content on same or next line; no blank after `<!--` |
| Comment close | `-->` at end of last content line |
| Prompt text | Always `Enter your response here.` (with trailing period) |
| Type A: `-->` → prompt | Exactly **1** blank line |
| Type A: prompt → next heading | Exactly **2** blank lines |
| Type B: multiple-choice → next heading | Exactly **2** blank lines (no prompt) |
| Type C: instructional `-->` → next heading | Exactly **2** blank lines (no prompt) |
| `\newpage` | Exactly **2** blank lines before and after |
| Numbered list | `N. ` prefix, no leading whitespace; nested = 4-space indent; applies everywhere |
| Bulleted list | `- ` only, no leading whitespace; nested = 4-space indent; applies everywhere |
| `#` heading | Section heading; Type C comment or direct `##` follows |
| `##` heading | Question heading; governs Type A or B section |
| `###` heading | Sub-question; when `##` → `###`, rules apply to `###` |

---

## What NOT to change

- YAML front matter (`---` … `---`)
- The `# References` section and trailing LaTeX spacing commands
- R inline code (`` `r ...` ``)
- The *prose content* of comment blocks — only list markers, indentation, whitespace,
  and question-number prefixes within them may change
- Blank lines within a comment block that separate paragraphs — those are intentional
- Markdown tables and fenced code blocks (`` ```{r} `` … ` ``` ``)
