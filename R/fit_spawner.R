#' Fit a spawner abundance model
#'
#' Fit the SpawnEst model to repeated spawner count surveys.
#'
#' The input data must contain a `date` column and a
#' `spawner_counts` column. An optional `stream` column may
#' be provided to fit multiple streams independently.
#'
#' @param data A data frame containing survey observations.
#' @param abundance Prior estimate of total spawner abundance.
#' @param arrival_peak Expected peak arrival date. If NULL,
#'   a default value is estimated using the survey-date
#'   quantile specified by `arrival_quantile`.
#' @param arrival_quantile Quantile of survey dates used to estimate
#'   a default arrival peak date when `arrival_peak` is NULL.
#'   Ignored when `arrival_peak` is supplied.
#' @param priors Additional model priors produced by
#'   [default_priors()].
#'
#' @return A `spawnest_fit` object.
#'
#' @export
fit_spawner <- function(
    data,
    abundance = NULL,
    arrival_peak = NULL,
    arrival_quantile = 0.4,
    priors = NULL
) {
  
  if (!is.null(arrival_peak) & !missing(arrival_quantile))
    warning("arrival_peak supplied; arrival_quantile ignored.")
  
  data <- validate_data(data)
  
  if (is.null(priors))
    priors <- default_priors(
      data = data,
      abundance = abundance,
      arrival_peak = arrival_peak,
      arrival_quantile = arrival_quantile
    )
  
  stop("Not yet implemented.")
}
