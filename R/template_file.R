#' Create a spawnBayes data template
#'
#' Create a csv template illustrating the expected
#' input data structure for spawnBayes.
#'
#' @param file Output file name.
#'
#' @return The path to the created file.
#'
#' @export
template_file <- function(file = "spawnBayes_template.csv") {
  
  template <- data.frame(
    date = c(
      "2024-09-01",
      "2024-09-10",
      "2024-09-20"
    ),
    spawner_counts = c(
      150,
      320,
      180
    ),
    observer_efficiency = 1,
    coverage = 1
  )
  
  utils::write.csv(
    template,
    file,
    row.names = FALSE
  )
  
  invisible(normalizePath(file))
}