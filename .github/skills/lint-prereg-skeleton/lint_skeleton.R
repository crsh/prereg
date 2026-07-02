#!/usr/bin/env Rscript
# tools/lint_skeleton.R
#
# Applies mechanical formatting fixes to prereg skeleton.Rmd files.
#
# Usage:
#   Rscript tools/lint_skeleton.R                        # all skeletons
#   Rscript tools/lint_skeleton.R path/to/skeleton.Rmd   # single file
#
# Rules implemented (see .github/skills/lint-prereg-skeleton/references/formatting-rules.md):
#   1. No trailing whitespace
#   2. Comment delimiter spacing: <!-- text -->
#   3. No blank line between heading and comment
#   4. No blank line at start of comment block
#   5. Closing --> on last content line (not its own line)
#   6. Prompt text: ensure "Enter your response here."
#   7. Section spacing (after -->, after prompt)
#   8. \newpage: exactly 2 blank lines before and after
#   9. # heading directly followed by ## (no intervening blank)
#  10. Bullet style: * -> - everywhere
#  11. Sentence case headings (with acronym/proper-noun whitelist)
#      + collapse 3+ consecutive blank lines to 2
#
# NOT automated (require judgment):
#   - Spelling/grammar fixes
#   - Adding missing prompts to Type A sections
#   - Encoding corruption fixes

# ---------------------------------------------------------------------------
# Acronyms and proper nouns to preserve in headings (sentence-case pass)
# ---------------------------------------------------------------------------
KEEP_UPPER <- c(
  "IRB", "EEG", "ERP", "ERPs", "ESM", "ORCID", "NHST", "APA", "ROI", "ROIs",
  "CRediT", "BPS", "DGPs", "COS", "ZPID", "SIPS", "OSF", "DOI", "PDF", "fMRI",
  "MRI", "ICA", "PCA", "IIR", "FIR", "ECG", "EMG", "EOG", "BOLD", "RESEL",
  "FWE", "FDR", "TFCE", "ANOVA", "MANOVA", "RMANOVA", "SEM", "FIML", "MAR",
  "MCAR", "MNAR", "AIC", "BF", "Hz", "ASL", "CASL", "PCASL", "PASL", "VSASL",
  "VENC", "N/A", "NA", "IQ", "PRP", "GPA", "SD", "IQR", "AR", "DCT", "FLOBS",
  "MCFLIRT", "AMICA", "ICLabel", "BEAPP", "HAPPE", "PREP", "EEGLAB", "MATLAB",
  "Python", "FSL", "SPM", "FieldTrip", "MNE", "Brainstorm", "ERPLAB", "MMN",
  "H0", "H1", "H2", "H3", "E1", "E2", "IV", "DV", "IVs", "DVs",
  "AsPredicted", "MTurk", "COVID"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

find_yaml_end <- function(lines) {
  if (length(lines) == 0 || trimws(lines[1]) != "---") return(0L)
  for (i in seq(2, length(lines))) {
    if (trimws(lines[i]) == "---") return(i)
  }
  0L
}

find_refs_start <- function(lines) {
  for (i in seq_along(lines)) {
    if (trimws(lines[i]) == "# References") return(i)
  }
  length(lines) + 1L
}

sentence_case_heading <- function(text) {
  # Split on spaces, lowercase non-first words unless whitelisted or all-caps
  words <- strsplit(text, " ", fixed = TRUE)[[1]]
  if (length(words) == 0) return(text)
  result <- character(length(words))

  apply_case_to_token <- function(w, is_first) {
    # Handle slash-separated compounds (e.g., ESM/time-variant)
    parts <- strsplit(w, "/", fixed = TRUE)[[1]]
    if (length(parts) > 1) {
      processed <- vapply(seq_along(parts), function(k) {
        apply_case_to_token(parts[k], is_first && k == 1)
      }, character(1))
      return(paste(processed, collapse = "/"))
    }
    core <- gsub("[^A-Za-z0-9]", "", w)
    if (is_first) {
      paste0(toupper(substr(w, 1, 1)), substr(w, 2, nchar(w)))
    } else if (core %in% KEEP_UPPER) {
      w  # keep as-is
    } else if (grepl("^[A-Z]{1,4}[0-9]+[a-z]?$", core)) {
      w  # alphanumeric section code, e.g. T1, AP6
    } else if (nchar(core) >= 2 && core == toupper(core) && grepl("^[A-Z]+$", core)) {
      w  # all-caps acronym
    } else {
      paste0(tolower(substr(w, 1, 1)), substr(w, 2, nchar(w)))
    }
  }

  for (j in seq_along(words)) {
    result[j] <- apply_case_to_token(words[j], j == 1)
  }
  paste(result, collapse = " ")
}

# ---------------------------------------------------------------------------
# Rule implementations (each takes lines vector, returns modified lines vector)
# ---------------------------------------------------------------------------

# Rule 1: strip trailing whitespace (outside YAML and References)
rule_trailing_whitespace <- function(lines, yaml_end, refs_start) {
  protected <- seq_len(yaml_end)
  body <- seq(yaml_end + 1L, refs_start - 1L)
  lines[body] <- sub("\\s+$", "", lines[body])
  lines
}

# Rule 2: comment delimiter spacing
rule_comment_spacing <- function(lines, yaml_end, refs_start) {
  body <- seq(yaml_end + 1L, refs_start - 1L)
  # <!--text -> <!-- text  (<!-- not followed by space, -, or end)
  lines[body] <- gsub("<!--([^\\s\\-])", "<!-- \\1", lines[body], perl = TRUE)
  # text--> -> text -->  (non-space/- directly before -->)
  lines[body] <- gsub("([^\\s\\-])-->", "\\1 -->", lines[body], perl = TRUE)
  lines
}

# Rule 3: remove blank line(s) between heading and following <!--
rule_heading_comment_gap <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  i <- body_start
  out <- lines[seq_len(yaml_end)]
  while (i <= body_end) {
    out <- c(out, lines[i])
    if (grepl("^#{1,3} ", lines[i])) {
      j <- i + 1L
      # Collect blank lines
      blanks <- 0L
      while (j <= body_end && trimws(lines[j]) == "") { j <- j + 1L; blanks <- blanks + 1L }
      if (blanks > 0 && j <= body_end && startsWith(trimws(lines[j]), "<!--")) {
        # Skip the blanks; do NOT append them
        i <- j
        next
      }
    }
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 4: remove blank line at start of comment block
rule_comment_blank_start <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  out <- lines[seq_len(yaml_end)]
  i <- body_start
  while (i <= body_end) {
    out <- c(out, lines[i])
    if (trimws(lines[i]) == "<!--") {
      # Skip blank lines immediately following
      j <- i + 1L
      while (j <= body_end && trimws(lines[j]) == "") j <- j + 1L
      i <- j
      next
    }
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 5: standalone --> on its own line -> attach to preceding content line
rule_attach_close <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  out <- lines[seq_len(yaml_end)]
  i <- body_start
  while (i <= body_end) {
    if (trimws(lines[i]) == "-->" && i > body_start) {
      # Find the last non-empty line in out
      j <- length(out)
      while (j >= 1 && trimws(out[j]) == "") j <- j - 1L
      if (j >= 1 && trimws(out[j]) != "<!--") {
        out[j] <- paste0(out[j], " -->")
        i <- i + 1L
        next
      }
    }
    out <- c(out, lines[i])
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 6: normalise prompt text
rule_prompt_text <- function(lines, yaml_end, refs_start) {
  body <- seq(yaml_end + 1L, refs_start - 1L)
  # "Enter your response here" without period
  lines[body] <- gsub("^Enter your response here\\.?$",
                      "Enter your response here.", lines[body])
  lines
}

# Rule 7 spacing: blank lines after --> and after prompt
#   After --> :
#     - Type C (# heading or preamble): 2 blank lines
#     - Type A (## heading + comment, followed by prompt or another heading): 1 blank
#     - Type B (## heading + comment, followed by list/bold options): 1 blank
#   After prompt: 2 blank lines before next heading / newpage
rule_section_spacing <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L

  classify_heading_level <- function(out_so_far) {
    # Walk backward through the comment block (we're just after a -->),
    # then find the enclosing heading.
    j <- length(out_so_far)

    # Phase 1: skip backward through comment content to find the opening <!--
    # (handles both single-line <!-- ... --> and multi-line blocks)
    while (j >= 1) {
      l <- trimws(out_so_far[j])
      if (l == "") { j <- j - 1L; next }
      if (startsWith(l, "<!--")) {
        j <- j - 1L  # step past the opening <!--
        break
      }
      j <- j - 1L
    }

    # Phase 2: scan backward from before the comment opening for the heading.
    # Continue past any non-heading content (bold labels, table rows, etc.)
    # until a heading line is found or the start of the body is reached.
    while (j >= 1) {
      l <- trimws(out_so_far[j])
      if (l == "") { j <- j - 1L; next }
      m <- regexpr("^(#+) ", l, perl = TRUE)
      if (m > 0) return(nchar(regmatches(l, m)) - 1L)
      j <- j - 1L  # non-heading content: keep scanning backward
    }
    0L  # preamble / no heading found -> Type C
  }

  out <- lines[seq_len(yaml_end)]
  i <- body_start
  while (i <= body_end) {
    line <- lines[i]
    out <- c(out, line)

    # After closing -->
    if (endsWith(trimws(line), "-->") && !trimws(line) %in% c("<!--", "-->")) {
      # consume existing blank lines
      j <- i + 1L
      while (j <= body_end && trimws(lines[j]) == "") j <- j + 1L
      if (j > body_end) { i <- i + 1L; next }

      next_line <- lines[j]
      is_heading  <- grepl("^#{1,3} ", next_line)
      is_newpage  <- trimws(next_line) == "\\newpage"
      is_prompt   <- trimws(next_line) == "Enter your response here."
      is_list     <- grepl("^\\s*[\\-\\*]\\s", next_line, perl = TRUE) ||
                     grepl("^\\s*\\*\\*", next_line, perl = TRUE)

      hlevel <- classify_heading_level(out)
      is_type_c <- hlevel <= 1  # preamble or # heading

      needed <- if (is_type_c || is_heading || is_newpage) 2L
                else if (is_prompt || is_list) 1L
                else { i <- i + 1L; next }

      for (k in seq_len(needed)) out <- c(out, "")
      i <- j - 1L  # will be incremented to j

    # After prompt
    } else if (trimws(line) == "Enter your response here.") {
      j <- i + 1L
      while (j <= body_end && trimws(lines[j]) == "") j <- j + 1L
      if (j > body_end) { i <- i + 1L; next }
      if (grepl("^#{1,3} ", lines[j]) || trimws(lines[j]) == "\\newpage") {
        for (k in 1:2) out <- c(out, "")
        i <- j - 1L
      }
    }

    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 8: \newpage spacing (2 blank before and after)
rule_newpage_spacing <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  out <- lines[seq_len(yaml_end)]
  i <- body_start
  while (i <= body_end) {
    if (trimws(lines[i]) == "\\newpage") {
      # Ensure 2 blank lines before
      while (length(out) > 0 && trimws(out[length(out)]) == "") out <- out[-length(out)]
      out <- c(out, "", "", lines[i])
      # Skip blank lines after
      j <- i + 1L
      while (j <= body_end && trimws(lines[j]) == "") j <- j + 1L
      out <- c(out, "", "")
      i <- j
      next
    }
    out <- c(out, lines[i])
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 9: # heading directly followed by ## (remove any blank lines between them)
rule_hash_to_hash <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  out <- lines[seq_len(yaml_end)]
  i <- body_start
  while (i <= body_end) {
    out <- c(out, lines[i])
    # # heading (not # References) with no comment follows
    if (grepl("^# [^#]", lines[i]) && !startsWith(lines[i], "# References")) {
      j <- i + 1L
      blanks <- 0L
      while (j <= body_end && trimws(lines[j]) == "") { j <- j + 1L; blanks <- blanks + 1L }
      # Only remove blank if immediately followed by ##, not by a comment
      if (blanks > 0 && j <= body_end && grepl("^## ", lines[j])) {
        i <- j - 1L
      }
    }
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# Rule 10: bullet style: * -> - (outside YAML, tables, code fences)
rule_bullet_style <- function(lines, yaml_end, refs_start) {
  body <- seq(yaml_end + 1L, refs_start - 1L)
  in_code <- FALSE
  for (i in body) {
    l <- lines[i]
    if (startsWith(l, "```")) in_code <- !in_code
    if (!in_code && !startsWith(l, "|")) {
      # "* text" (asterisk + space, with optional leading whitespace) -> "- text"
      # This safely catches list items using * as the marker.
      l <- gsub("^(\\s*)\\* (.)", "\\1- \\2", l, perl = TRUE)
      # "-\ttext" (dash + tab) -> "- text"
      l <- gsub("^(\\s*)-\t", "\\1- ", l, perl = TRUE)
    }
    lines[i] <- l
  }
  lines
}

# Rule 11: sentence case headings
rule_sentence_case <- function(lines, yaml_end, refs_start) {
  body <- seq(yaml_end + 1L, refs_start - 1L)
  in_code <- FALSE
  for (i in body) {
    l <- lines[i]
    if (startsWith(l, "```")) in_code <- !in_code
    if (!in_code) {
      m <- regexpr("^(#{1,3} )(.+)$", l, perl = TRUE)
      if (m > 0 && !startsWith(l, "# References")) {
        prefix_len <- attr(regexpr("^#{1,3} ", l, perl = TRUE), "match.length")
        prefix <- substr(l, 1, prefix_len)
        text   <- substr(l, prefix_len + 1, nchar(l))
        lines[i] <- paste0(prefix, sentence_case_heading(text))
      }
    }
  }
  lines
}

# Collapse 3+ consecutive blank lines to 2 (outside YAML and References)
rule_collapse_blanks <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L
  out <- lines[seq_len(yaml_end)]
  i <- body_start
  blank_run <- 0L
  while (i <= body_end) {
    if (trimws(lines[i]) == "") {
      blank_run <- blank_run + 1L
      if (blank_run <= 2L) out <- c(out, lines[i])
    } else {
      blank_run <- 0L
      out <- c(out, lines[i])
    }
    i <- i + 1L
  }
  c(out, lines[refs_start:length(lines)])
}

# ---------------------------------------------------------------------------
# Main processing pipeline
# ---------------------------------------------------------------------------

process_file <- function(path) {
  lines <- readLines(path, warn = FALSE)

  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  # Guard: nothing to process
  if (yaml_end == 0L || refs_start <= yaml_end + 1L) {
    message("  Skipping (no processable body): ", path)
    return(invisible(NULL))
  }

  original <- lines

  lines <- rule_trailing_whitespace(lines, yaml_end, refs_start)
  lines <- rule_comment_spacing(lines, yaml_end, refs_start)
  lines <- rule_attach_close(lines, yaml_end, refs_start)
  lines <- rule_comment_blank_start(lines, yaml_end, refs_start)

  # Re-detect boundaries (line count may have changed)
  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  lines <- rule_heading_comment_gap(lines, yaml_end, refs_start)

  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  lines <- rule_prompt_text(lines, yaml_end, refs_start)
  lines <- rule_section_spacing(lines, yaml_end, refs_start)

  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  lines <- rule_newpage_spacing(lines, yaml_end, refs_start)
  lines <- rule_hash_to_hash(lines, yaml_end, refs_start)
  lines <- rule_bullet_style(lines, yaml_end, refs_start)
  lines <- rule_sentence_case(lines, yaml_end, refs_start)
  lines <- rule_collapse_blanks(lines, yaml_end, refs_start)

  if (identical(original, lines)) {
    message("  No changes: ", path)
    return(invisible(NULL))
  }

  writeLines(lines, path)
  message("  Updated: ", path)
  invisible(NULL)
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  files <- Sys.glob("inst/rmarkdown/templates/*/skeleton/skeleton.Rmd")
  if (length(files) == 0) {
    stop("No skeleton files found. Run from the package root directory.")
  }
} else {
  files <- args
}

for (f in files) {
  if (!file.exists(f)) {
    message("File not found: ", f)
    next
  }
  process_file(f)
}
