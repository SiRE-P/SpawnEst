#' Extract abundance estimates
#'
#' Extract annual spawner abundance estimates from a fitted
#' SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#' @param probs Lower and upper quantiles used to construct
#'   credible intervals.
#'
#' @return A data frame containing annual abundance estimates.
#'
#' @export
abundance <- function(fit, probs = c(0.025, 0.975)) {
  
  log_run_draws <- fit$fit$draws("log_run", format = "matrix")
  abundance_draws <- exp(log_run_draws)
  
  qs <- t(apply(abundance_draws, 2, quantile,
                probs = c(probs[1], 0.5, probs[2])))
  
  interval <- round(100 * (probs[2] - probs[1]))
  
  out <- data.frame(
    year = fit$stan_inputs$year_lookup$year,
    median = round(qs[, 2]),
    lower = round(qs[, 1]),
    upper = round(qs[, 3])
  )
  
  names(out)[3:4] <- c(
    paste0("lower_", interval),
    paste0("upper_", interval)
  )
  
  rownames(out) <- NULL
  
  out
}
