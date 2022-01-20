test_that(
  "Knit COS skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "cos_skeleton.Rmd"
      , "cos_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("cos_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "cos"))
  }
)

test_that(
  "Knit AsPredicted skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "aspredicted_skeleton.Rmd"
      , "aspredicted_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("aspredicted_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "aspredicted"))
  }
)

test_that(
  "Knit van 't Veer and Giner-Sorolla skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "vantveer_skeleton.Rmd"
      , "vantveer_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("vantveer_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "vantveer"))
  }
)

test_that(
  "Knit Brandt et al. skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "brandt_skeleton.Rmd"
      , "brandt_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("brandt_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "brandt"))
  }
)

test_that(
  "Knit PRP-QUANT skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "prp_quant_skeleton.Rmd"
      , "prp_quant_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("prp_quant_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "prp_quant"))
  }
)

test_that(
  "Knit Registered Report skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "rr_skeleton.Rmd"
      , "rr_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("rr_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "rr"))
  }
)

test_that(
  "Knit FMRI skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "fmri_skeleton.Rmd"
      , "fmri_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("fmri_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "fmri"))
  }
)

test_that(
  "Knit Crüwell & Evans skeleton"
  , {
    skip_on_cran()

    # Render skeleton
    rmarkdown::draft(
      "cruewell_skeleton.Rmd"
      , "cruewell_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("cruewell_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "cruewell"))
  }
)
