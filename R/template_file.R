#' SpawnEst data template
#'
#' Returns the path to a csv template illustrating the
#' expected data structure for SpawnEst.
#'
#' @return A file path.
#'
#' @export
template_file <- function() {
  
  system.file(
    "extdata",
    "spawnest_template.csv",
    package = "SpawnEst"
  )
  
}