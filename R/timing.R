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
  
  arrival <- fit$fit$draws("arrival", format = "matrix")
  
  arrival_peak <- arrival + fit$stan_inputs$day_stand
  
  arrival_spread <- fit$fit$draws("arrival_spread", format = "matrix")
  
  exit_lag <- fit$fit$draws("exit_lag", format = "matrix")
  
  exit_spread <- fit$fit$draws("exit_spread", format = "matrix")
  
  effective_residence <- matrix(
    NA,
    nrow = nrow(arrival),
    ncol = ncol(arrival)
  )
  
  max_day <- max(fit$stan_inputs$stan_data$day)
  
  for (j in seq_len(ncol(arrival))) {
    
    live <- sapply(seq_len(max_day), function(x) {
      
      entered <- stats::pnorm(
        x,
        arrival[, j],
        arrival_spread[, j]
      )
      
      exited <- stats::pnorm(
        x,
        arrival[, j] + exit_lag[, j],
        exit_spread[, j]
      )
      
      entered * (1 - exited)
      
    })
    
    effective_residence[, j] <- rowSums(live)
    
  }
  
  out <- list(
    arrival_peak = summarize_draws(arrival_peak, years, CI),
    arrival_spread = summarize_draws(arrival_spread, years, CI),
    effective_residence = summarize_draws(effective_residence, years, CI),
    exit_lag = summarize_draws(exit_lag, years, CI),
    exit_spread = summarize_draws(exit_spread, years, CI)
  )
  
  if (format == "date") {
    
    cols <- setdiff(names(out$arrival_peak), "year")
    
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