#' Extract abundance estimates
#'
#' Extract annual spawner abundance estimates from a fitted
#' SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval widths to report.
#'
#' @return A data frame containing annual abundance estimates.
#' If an assumed residence time was supplied when fitting the
#' model, traditional TAUC abundance estimates are also returned.
#'
#' @export
abundance <- function(fit, CI = c(66, 95)) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
 
    log_run_draws <- fit$fit$draws("log_run", format = "matrix")
  abundance_draws <- exp(log_run_draws)
  
  summarize_draws(
    draws = abundance_draws,
    years = fit$stan_inputs$year_lookup$year,
    CI = CI
  )
  
  out <- summarize_draws(
    abundance_draws,
    fit$stan_inputs$year_lookup$year,
    CI
  )
  
  if (!is.null(fit$TAUC))
    out <- dplyr::left_join(
      out,
      fit$TAUC,
      by = "year"
    )
}