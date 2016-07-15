test_that(
  "Knit COS skeleton"
  , {
    skip_on_cran()
      
    # Render skeleton
    rmarkdown::draft(
      "bare_skeleton.Rmd"
      , "cos_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("bare_skeleton.Rmd")

    # Clean up
    file.remove(list.files(pattern = "bare"))
  }
)

test_that(
  "Knit AsPredicted skeleton"
  , {
    skip_on_cran()
    
    # Render skeleton
    rmarkdown::draft(
      "bare_skeleton.Rmd"
      , "aspredicted_prereg"
      , package = "prereg"
      , create_dir = FALSE
      , edit = FALSE
    )
    rmarkdown::render("bare_skeleton.Rmd")
    
    # Clean up
    file.remove(list.files(pattern = "bare"))
  }
)
