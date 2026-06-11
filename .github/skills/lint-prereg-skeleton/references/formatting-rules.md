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

## Rule 2 — No blank line between heading and comment

A `##` or `#` heading is immediately followed on the next line by `<!--`.
No empty line between them.

```
# ✗ Wrong
## Hypotheses and rationale

<!-- Provide all hypotheses... -->

# ✓ Correct
## Hypotheses and rationale
<!-- Provide all hypotheses... -->
```

---

## Rule 3 — No blank start inside a comment block

The comment opener `<!--` must be followed by content on the same line, or (for multi-line comments) content on the very next line if it is a list — never by a blank line.

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

## Rule 4 — Closing `-->` on the last content line

The HTML comment close `-->` appears at the end of the last content line inside the comment. It does **not** occupy its own line (unless the comment itself is a single `<!-- -->` structural comment with no content).

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

## Rule 5 — One blank line between comment close and prompt

After `-->`, there is **exactly one** blank line before `Enter your response here.`

```
# ✗ Wrong — no blank line
<!-- Describe the dataset. -->
Enter your response here.

# ✗ Wrong — two blank lines
<!-- Describe the dataset. -->


Enter your response here.

# ✓ Correct
<!-- Describe the dataset. -->

Enter your response here.
```

---

## Rule 6 — Two blank lines between prompt and next heading

After `Enter your response here.` (or any terminal section content), there are **exactly two** blank lines before the next `#` or `##` heading.

```
# ✗ Wrong — one blank line
Enter your response here.

## Next section

# ✗ Wrong — three blank lines
Enter your response here.



## Next section

# ✓ Correct
Enter your response here.


## Next section
```

This also applies when the section ends with a list rather than the prompt:

```
# ✓ Correct
1. No, data collection has not begun
2. Yes, data collection is underway.


## Project schedule
```

---

## Rule 7 — Numbered list style inside comments

First-level items use `N. ` (number + period + space) with **no leading whitespace**.
Nested items are indented with **4 spaces**.

List formatting problems inside comments **should be fixed** — comment content is editable
for the purpose of correcting list markers and indentation.

```
# ✗ Wrong — wrong markers, leading whitespace on first-level items
<!-- 1) First item
  (2) Second item
    a. Nested -->

# ✓ Correct
<!-- List variables:
1. Independent variables with all their levels
    1. Whether they are within- or between-participant
    2. The relationship between them (e.g., orthogonal, nested).
2. Dependent variables. -->
```

---

## Rule 8 — Bulleted list style inside comments

First-level items use `- ` (dash + space) with **no leading whitespace**.
Nested items are indented with **4 spaces**.

List formatting problems inside comments **should be fixed** — comment content is editable
for the purpose of correcting list markers and indentation.

```
# ✗ Wrong — wrong markers, leading whitespace on first-level items
<!-- Include:
  * type of data,
  * general content. -->

# ✓ Correct
<!-- Include:
- type of data (e.g., cross-sectional, longitudinal),
- general content and domains covered,
- key details about respondents (e.g., population, time frame). -->
```

Nested bullets:

```
# ✓ Correct
<!-- Specify:
- overall missingness,
    - variable-specific missingness,
    - any known patterns (e.g., attrition). -->
```

---

## Summary table

| Location | Rule |
|---|---|
| Line ending | No trailing whitespace |
| Heading → comment | No blank line |
| Comment open | Text on same or next line; no blank after `<!--` |
| Comment close | `-->` at end of last content line |
| Comment close → prompt | Exactly **1** blank line |
| Prompt → next heading | Exactly **2** blank lines |
| Numbered list | `1. ` prefix, no leading whitespace; nested = 4-space indent |
| Bulleted list | `- ` prefix, no leading whitespace; nested = 4-space indent |

---

## What NOT to change

- YAML front matter (`---` … `---`)
- The `# References` section and trailing LaTeX spacing commands
- R inline code (`` `r ...` ``)
- The *prose content* of comment blocks — only list markers, indentation, and whitespace within them may change
- Blank lines within a comment block that separate paragraphs — those are intentional
