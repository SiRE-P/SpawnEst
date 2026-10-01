#' Create Stan initial values
#'
#' @keywords internal
make_inits <- function(stan_data) {
  
  list(
    log_run = rnorm(stan_data$n_years,
                    stan_data$priors[1, 1],
                    0.5),
    timing_mu = c(
      rnorm(1, stan_data$priors[2, 1], 2),
      rnorm(1, stan_data$priors[4, 1], 0.2),
      rnorm(1, stan_data$priors[6, 1], 0.2),
      rnorm(1, stan_data$priors[4, 1], 0.2)
    ),
    timing_sigma = rlnorm(4, 0, 0.2),
    timing_raw = matrix(rnorm(stan_data$n_years * 4, 0, 0.1),
                        nrow = stan_data$n_years,
                        ncol = 4),
    live_phi = 50
  )
  
}