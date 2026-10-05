#' Default prior specification
#'
#' Create a default prior specification for spawnBayes.
#'
#' @param data A data frame containing survey observations.
#' @param abundance Expected total spawner abundance. If NULL,
#'   a default value is estimated from the observed counts.
#'
#' @param arrival_peak Expected peak arrival date. If NULL,
#'   a default value is estimated using the survey-date
#'   quantile specified by `arrival_quantile`.
#' @param arrival_quantile Quantile of survey dates used to estimate
#'   a default arrival peak date when `arrival_peak` is NULL.
#'   Ignored when `arrival_peak` is supplied.
#' @param assumed_residence Assumed mean residence time (days).
#'   If supplied, this value is used to define the residence-time prior.
#'   If NULL, a default prior is used.
#'
#' @return A list containing prior specifications.
#'
#' @importFrom stats median sd quantile
#'
#' @export
#' 
default_priors <- function(data, abundance = NULL, assumed_residence = NULL, arrival_peak = NULL, arrival_quantile = 0.4) {
  
  arrival_dates <- data |>
    dplyr::mutate(year = lubridate::year(date), yday = lubridate::yday(date)) |>
    dplyr::group_by(year) |>
    dplyr::summarise(arrival_yday = stats::quantile(yday, probs = arrival_quantile), .groups = "drop")
  
  annual_peaks <- data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::group_by(year) |>
    dplyr::summarise(peak_count = max(spawner_counts, na.rm = TRUE), .groups = "drop")
  
  if (is.null(abundance))
    abundance <- median(annual_peaks$peak_count * 1.5, na.rm = TRUE)
  
  abundance_sdlog <- max(sd(log(pmax(annual_peaks$peak_count * 1.5, 1)), na.rm = TRUE), 0.5)
  
  if (is.null(arrival_peak))
    arrival_peak <- median(arrival_dates$arrival_yday, na.rm = TRUE)
  
  arrival_peak_sd <- max(sd(arrival_dates$arrival_yday, na.rm = TRUE), 5)

  residence_mean <- if (is.null(assumed_residence)) {
    log(11 - 1)
  } else {
    log(assumed_residence - 1)
  }

  
  list(
    abundance = list(mean = abundance, sdlog = abundance_sdlog),
    arrival_peak = list(mean = arrival_peak, sd = arrival_peak_sd),
    arrival_sigma = list(mean = 2, sd = 0.2),
    spread = list(mean = 2, sd = 0.2),
    spread_sigma = list(mean = 0.5, sd = 0.25),
    residence = list( mean = residence_mean, sd = 0.2),
    count_dispersion = list(mean = log(20), sd = 0.5)
  )
  
}