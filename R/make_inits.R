#' Create Stan initial values
#'
#' @keywords internal
make_inits <- function(stan_data) {
  
  list(
    log_run = stats::rnorm(stan_data$n_years,
                    stan_data$priors[1, 1],
                    0.5),
    timing_mu = c(
      stats::rnorm(1, stan_data$priors[2, 1], 2),
      stats::rnorm(1, stan_data$priors[4, 1], 0.2),
      stats::rnorm(1, stan_data$priors[6, 1], 0.2),
      stats::rnorm(1, stan_data$priors[4, 1], 0.2)
    ),
    timing_sigma = stats::rlnorm(4, 0, 0.2),
    timing_raw = matrix(stats::rnorm(stan_data$n_years * 4, 0, 0.1),
                        nrow = stan_data$n_years,
                        ncol = 4),
    live_phi = rep(exp(stan_data$priors[7,1]), stan_data$n_survey_error_groups)
  )
  
}