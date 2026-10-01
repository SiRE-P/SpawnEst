#' Extract timing estimates
#'
#' Extract annual timing estimates from a fitted SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval widths to report.
#' @param format Either `"yday"` or `"date"`.
#'
#' @return A named list containing timing estimates.
#'
#' @export
timing <- function(fit, CI = c(66, 95), format = c("yday", "date")) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
  format <- match.arg(format)
  
  years <- fit$stan_inputs$year_lookup$year
  
  arrival_peak <- fit$fit$draws("arrival", format = "matrix") +
    fit$stan_inputs$day_stand
  
  arrival_spread <- fit$fit$draws("arrival_spread", format = "matrix")
  
  residence <- fit$fit$draws("exit_lag", format = "matrix")
  
  exit_spread <- fit$fit$draws("exit_spread", format = "matrix")
  
  out <- list(
    arrival_peak = summarize_draws(arrival_peak, years, CI),
    arrival_spread = summarize_draws(arrival_spread, years, CI),
    residence = summarize_draws(residence, years, CI),
    exit_spread = summarize_draws(exit_spread, years, CI)
  )
  
  if (format == "date") {
    
    cols <- names(out$arrival_peak)
    cols <- cols[cols != "year"]
    
    for (col in cols) {
      
      out$arrival_peak[[col]] <- mapply(
        function(year, yday)
          format(as.Date(yday - 1, origin = paste0(year, "-01-01")), "%b-%d"),
        out$arrival_peak$year,
        out$arrival_peak[[col]]
      )
      
    }
    
  }
  
  out
  
}