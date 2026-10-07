#' Construct Stan data for spawnBayes
#'
#' Convert validated survey data and prior specifications into
#' the data list required by the spawnBayes Stan model.
#'
#' @param data A validated data frame containing survey observations.
#' @param priors A prior specification object returned by
#'   [default_priors()].
#'
#' @return A list containing:
#' \describe{
#'   \item{stan_data}{Data list supplied to Stan.}
#'   \item{day_stand}{Reference day used for day standardization.}
#'   \item{year_lookup}{Mapping between Stan year indices and calendar years.}
#' }
#'
#' @keywords internal
make_stan_data <- function(data, priors) {
  
  if ("stream" %in% names(data))
    stop("Multi-stream fitting is not yet implemented.", call. = FALSE)
  
  dat <- data |>
    dplyr::mutate(year = lubridate::year(date),
                  yday = lubridate::yday(date)) |>
    dplyr::arrange(date)
  
  day_stand <- min(dat$yday)
  
  dat <- dat |>
    dplyr::mutate(year_ind = as.numeric(factor(year)),
                  day = yday - day_stand)
  
  year_lookup <- dat |>
    dplyr::distinct(year_ind, year) |>
    dplyr::arrange(year_ind)
  
  stan_priors <- data.frame(
    prior = c("log_runs_mu", "arrival_mu", "arrival_sigma",
              "spread", "spread_sigma", "residence",
              "count_dispersion"),
    v1 = c(log(priors$abundance$mean),
           priors$arrival_peak$mean - day_stand,
           priors$arrival_sigma$mean,
           priors$spread$mean,
           priors$spread_sigma$mean,
           priors$residence$mean,
           priors$count_dispersion$mean),
    v2 = c(priors$abundance$sdlog,
           priors$arrival_peak$sd,
           priors$arrival_sigma$sd,
           priors$spread$sd,
           priors$spread_sigma$sd,
           priors$residence$sd,
           priors$count_dispersion$sd)
  )
  
  stan_data <- list(
    n_priors = nrow(stan_priors),
    priors = data.matrix(stan_priors[, -1]),
    n_years = nrow(year_lookup),
    year = dat$year_ind,
    day = dat$day,
    n_obs = nrow(dat),
    live_counts = dat$spawner_counts,
    survey_error_group_id = as.integer(dat$survey_error_group),
    n_survey_error_groups = nlevels(dat$survey_error_group)
  )
  
  list(
    stan_data = stan_data,
    day_stand = day_stand,
    year_lookup = year_lookup
  )
  
}