#' Extract abundance estimates
#'
#' Extract annual spawner abundance estimates from a fitted
#' SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval widths to report.
#'
#' @return A data frame containing annual abundance estimates.
#'
#' @export
abundance <- function(fit, CI = c(66, 95)) {
  
  log_run_draws <- fit$fit$draws("log_run", format = "matrix")
  abundance_draws <- exp(log_run_draws)
  
  out <- data.frame(
    year = fit$stan_inputs$year_lookup$year,
    median = apply(abundance_draws, 2, median)
  )
  
  for (ci in sort(unique(CI))) {
    
    alpha <- (1 - ci / 100) / 2
    
    qs <- t(apply(
      abundance_draws,
      2,
      quantile,
      probs = c(alpha, 1 - alpha)
    ))
    
    out[[paste0("lower_", ci)]] <- qs[, 1]
    out[[paste0("upper_", ci)]] <- qs[, 2]
    
  }
  
  lower_cols <- paste0("lower_", rev(sort(unique(CI))))
  upper_cols <- paste0("upper_", sort(unique(CI)))
  
  out <- out[, c("year", lower_cols, "median", upper_cols)]
  
  out[-1] <- round(out[-1])
  
  rownames(out) <- NULL
  
  out
}