#' Summarize model diagnostics
#'
#' Summarize MCMC convergence diagnostics for a fitted
#' SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#'
#' @return A data frame containing convergence diagnostics and
#'   recommended actions if problems are detected.
#'
#' @export
diagnostics <- function(fit) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
  fit_summary <- fit$fit$summary()
  
  max_rhat <- max(
    fit_summary$rhat,
    na.rm = TRUE
  )
  
  min_ess_bulk <- min(
    fit_summary$ess_bulk,
    na.rm = TRUE
  )
  
  min_ess_tail <- min(
    fit_summary$ess_tail,
    na.rm = TRUE
  )
  
  sampler_diag <- fit$fit$sampler_diagnostics()
  
  divergences <- sum(
    sampler_diag[, , "divergent__"],
    na.rm = TRUE
  )
  
  treedepth_hits <- sum(
    sampler_diag[, , "treedepth__"] >= 10,
    na.rm = TRUE
  )
  
  quality <- dplyr::case_when(
    divergences > 0 ~ "poor",
    max_rhat >= 1.05 ~ "poor",
    min_ess_bulk < 100 ~ "poor",
    min_ess_tail < 100 ~ "poor",
    min_ess_bulk < 400 ~ "acceptable",
    min_ess_tail < 400 ~ "acceptable",
    TRUE ~ "good"
  )
  
  converged <- quality != "poor"
  
  recommendation <- character()
  
  if (divergences > 0)
    recommendation <- c(
      recommendation,
      "Increase adapt_delta (e.g., 0.99 or 0.999)."
    )
  
  if (max_rhat >= 1.05)
    recommendation <- c(
      recommendation,
      "Increase sampling iterations and inspect chain mixing."
    )
  
  if (min_ess_bulk < 100 || min_ess_tail < 100)
    recommendation <- c(
      recommendation,
      "Increase sampling iterations."
    )
  
  if (treedepth_hits > 0)
    recommendation <- c(
      recommendation,
      "Consider increasing max_treedepth."
    )
  
  if (length(recommendation) == 0)
    recommendation <- "No action required."
  
  recommendation <- paste(
    unique(recommendation),
    collapse = " "
  )
  
  if (quality == "poor")
    warning(
      "Model may not have converged. See diagnostics() recommendations.",
      call. = FALSE
    )
  
  data.frame(
    converged = converged,
    quality = quality,
    divergences = divergences,
    treedepth_hits = treedepth_hits,
    max_rhat = round(max_rhat, 3),
    min_ess_bulk = round(min_ess_bulk),
    min_ess_tail = round(min_ess_tail),
    recommendation = recommendation
  )
  
}