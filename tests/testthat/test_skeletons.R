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
