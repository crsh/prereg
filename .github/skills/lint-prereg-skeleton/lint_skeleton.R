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
#  13. Paragraphs on single lines: join wrapped continuation lines within comment blocks
#  14. Blank lines between paragraphs and lists within comment blocks;
#      known section starters (Example:, More information:, Note:, etc.)
#      are always preceded by a blank line
#  15. No leading whitespace on non-list lines within comment blocks
#
# NOT automated (require judgment):
#   - Spelling/grammar fixes
#   - Adding missing prompts to Type A sections
#   - Encoding corruption fixes
#   - Adding missing list markers (-) to unlabeled bullet items in comment blocks
#     (Rules 13-15 will join unlabeled items into paragraphs; add markers manually)

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
  "AsPredicted", "MTurk", "COVID",
  "IDs", "ID",           # identifier abbreviation
  "iD",                  # ORCID stylisation "ORCID iD"
  "U", "N", "E"          # single-letter classification labels (Type U, Type N, Type E)
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
    # Handle hyphen-prefixed compounds (e.g., "Re-Referencing" -> "Re-referencing",
    # but "non-ESM" -> "non-ESM" because ESM is whitelisted)
    hm <- regexpr("^([A-Za-z]+-)(.*)", w, perl = TRUE)
    if (hm > 0 && nchar(w) > 2) {
      pfx_len <- attr(regexpr("^[A-Za-z]+-", w, perl = TRUE), "match.length")
      pfx  <- substr(w, 1, pfx_len)          # e.g. "Re-" or "non-"
      rest <- substr(w, pfx_len + 1, nchar(w))  # e.g. "Referencing" or "ESM"
      if (nchar(rest) > 0) {
        pfx_cased  <- if (is_first) paste0(toupper(substr(pfx, 1, 1)), substr(pfx, 2, nchar(pfx)))
                      else paste0(tolower(substr(pfx, 1, 1)), substr(pfx, 2, nchar(pfx)))
        rest_cased <- apply_case_to_token(rest, FALSE)  # respect whitelist on the rest
        return(paste0(pfx_cased, rest_cased))
      }
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
# Helpers for comment block internals (Rules 13–15)
# ---------------------------------------------------------------------------

# Regex for known section starters that open a new paragraph inside a comment.
# Matches at the START of stripped content.  Colon or period, followed by a
# space or end-of-string (handles "Example:" alone on a line as well as
# "Example: text here").
COMMENT_SECTION_RE <- paste0(
  "^(Examples?( [0-9]+)?[.:](\\s|$))",
  "|(^More information[.:](\\s|$))",
  "|(^More info[.:](\\s|$))",
  "|(^Note[.:](\\s|$))",
  "|(^N\\.B\\.[.:](\\s|$))",
  "|(^Warning[.:](\\s|$))"
)

# TRUE when a stripped line is a Markdown list item (numbered or bulleted)
is_inner_list <- function(s) {
  grepl("^\\s*\\d+\\.\\s", s, perl = TRUE) ||
  grepl("^\\s*-\\s",        s, perl = TRUE)
}

# TRUE when a stripped line is a known section starter inside a comment
is_section_start <- function(s) {
  grepl(COMMENT_SECTION_RE, s, perl = TRUE)
}

# TRUE when a line ends with sentence-ending punctuation (.!?)
ends_sentence <- function(s) {
  if (!grepl("[.!?]\\s*$", s, perl = TRUE)) return(FALSE)
  # Exclude common abbreviations ending with a period (not sentence enders)
  abbrev_re <- "\\b(vs|e\\.g|i\\.e|etc|cf|al|fig|ref|no|vol|pp|ed|eds|ch|approx|incl|excl|dept|est|min|max|avg|std)\\.$"
  !grepl(abbrev_re, trimws(s), ignore.case = TRUE, perl = TRUE)
}

# ---------------------------------------------------------------------------
# Rules 13–15: reformat comment block internals
#
#   Rule 13 – join wrapped paragraph continuation lines into single lines.
#             A line is a continuation when (a) the previous output line ends
#             without sentence-ending punctuation AND (b) the current line
#             starts with a lower-case letter.
#   Rule 14 – separate paragraphs and lists with blank lines:
#             • blank line before every known section starter
#             • blank line before a list that follows non-list content
#             • blank line before a new text paragraph that did not join
#   Rule 15 – strip leading whitespace from non-list lines inside comments
# ---------------------------------------------------------------------------

rule_reformat_comment_internals <- function(lines, yaml_end, refs_start) {
  body_start <- yaml_end + 1L
  body_end   <- refs_start - 1L

  out     <- lines[seq_len(yaml_end)]
  i       <- body_start
  in_cmt  <- FALSE
  in_code <- FALSE

  while (i <= body_end) {
    l      <- lines[i]
    l_trim <- trimws(l)

    # Code fences: pass through untouched
    if (startsWith(l, "```")) {
      in_code <- !in_code
      out <- c(out, l)
      i   <- i + 1L
      next
    }
    if (in_code) {
      out <- c(out, l)
      i   <- i + 1L
      next
    }

    # Detect comment open / close on this line
    opens  <- !in_cmt && grepl("<!--", l, fixed = TRUE)
    if (opens) in_cmt <- TRUE
    closes <- in_cmt && endsWith(l_trim, "-->")

    # Outside any comment: pass through unchanged
    if (!in_cmt) {
      out <- c(out, l)
      i   <- i + 1L
      next
    }

    is_opener <- opens   # this line opened the comment

    # Strip closing --> for content analysis (will be re-added)
    content_raw <- if (closes) sub("\\s*-->\\s*$", "", l) else l

    # Strip opening <!-- to isolate text content
    if (is_opener) {
      if (trimws(content_raw) %in% c("<!--", "")) {
        # Standalone opener with no content on this line
        out <- c(out, "<!--")
        if (closes) in_cmt <- FALSE
        i <- i + 1L
        next
      }
      content <- trimws(sub("^\\s*<!--\\s*", "", content_raw))
    } else {
      content <- trimws(content_raw)
    }

    # Blank line within comment: preserve as-is
    if (content == "") {
      if (closes) {
        # Safety: blank content before -->  →  attach --> to previous line
        if (length(out) > 0 && trimws(out[length(out)]) != "") {
          out[length(out)] <- paste0(out[length(out)], " -->")
        } else {
          out <- c(out, "-->")
        }
        in_cmt <- FALSE
      } else {
        out <- c(out, "")
      }
      i <- i + 1L
      next
    }

    is_list    <- is_inner_list(content)
    is_section <- !is_list && is_section_start(content)

    # Inspect the previous output line for join / spacing decisions
    prev          <- if (length(out) > 0) out[length(out)] else ""
    prev_trim     <- trimws(prev)
    prev_is_blank <- prev_trim == ""
    prev_is_only  <- prev_trim == "<!--"   # standalone opener, no content

    # Core content of previous line (strip delimiters for comparisons)
    prev_core    <- trimws(sub("\\s*-->\\s*$", "",
                               sub("^<!--\\s*", "", prev_trim)))
    prev_is_list <- is_inner_list(prev_core)

    # ---- Decide what to do with this line ----

    if (is_section) {
      # Rule 14: ensure a blank line precedes section starters
      if (!prev_is_blank && !prev_is_only) {
        out <- c(out, "")
      }
      line_out <- content
      if (is_opener) line_out <- paste0("<!-- ", line_out)
      if (closes)    line_out <- paste0(line_out, " -->")
      out <- c(out, line_out)

    } else {
      # Rule 13: can we join this line to the previous output line?
      # Conditions: not the opener, not a list item, previous is non-blank
      # and not a standalone <!--, previous content does NOT end with
      # sentence-ending punctuation, and this line starts with a lower-case
      # letter (unambiguous mid-sentence continuation).
      can_join <- !is_opener &&
                  !is_list &&
                  !prev_is_blank &&
                  !prev_is_only &&
                  !prev_is_list &&
                  !ends_sentence(prev_core) &&
                  grepl("^[a-z0-9(]", content, perl = TRUE)

      if (can_join) {
        # Attach content to the tail of the previous output line,
        # moving any existing --> suffix to the new end.
        prev_has_close <- endsWith(prev_trim, "-->")
        base <- if (prev_has_close) trimws(sub("\\s*-->\\s*$", "", prev))
                else prev
        joined <- paste0(base, " ", content)
        if (closes || prev_has_close) joined <- paste0(joined, " -->")
        out[length(out)] <- joined

      } else {
        # Rule 14: add blank separator before this new "chunk" if needed
        if (!prev_is_blank && !prev_is_only) {
          if (is_list) {
            # Blank before a list item that follows non-list content
            if (!prev_is_list) out <- c(out, "")
          } else if (!is_opener) {
            # Blank before a new text paragraph
            out <- c(out, "")
          }
        }
        # Rule 15: emit line without leading whitespace
        line_out <- content
        if (is_opener) line_out <- paste0("<!-- ", line_out)
        if (closes)    line_out <- paste0(line_out, " -->")
        out <- c(out, line_out)
      }
    }

    if (closes) in_cmt <- FALSE
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

  # Rules 13-15: reformat comment block internals
  lines <- rule_reformat_comment_internals(lines, yaml_end, refs_start)

  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  lines <- rule_section_spacing(lines, yaml_end, refs_start)

  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

  lines <- rule_newpage_spacing(lines, yaml_end, refs_start)
  lines <- rule_hash_to_hash(lines, yaml_end, refs_start)
  lines <- rule_bullet_style(lines, yaml_end, refs_start)
  lines <- rule_sentence_case(lines, yaml_end, refs_start)

  # Re-detect boundaries again (rule_hash_to_hash may remove lines)
  yaml_end   <- find_yaml_end(lines)
  refs_start <- find_refs_start(lines)

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
