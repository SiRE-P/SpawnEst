#' Extract abundance estimates
#'
#' Extract annual spawner abundance estimates from a fitted
#' spawnBayes model.
#'
#' @param fit A fitted spawnBayes model.
#' @param CI Credible interval widths to report.
#' @param outlier_p_thresh Probability threshold used to
#'   classify surveys as potential outliers when reporting
#'   annual outlier counts.
#'
#' @return A data frame containing annual abundance estimates.
#' If an outlier observation model was fitted, the output also
#' includes the number of surveys within each year having
#' posterior outlier probabilities exceeding `outlier_p_thresh`.
#'
#' @export
abundance <- function(fit, CI = c(66, 95), outlier_p_thresh = 0.25) {
  
  if (!inherits(fit, "spawnBayes_fit"))
    stop("fit must be a spawnBayes_fit object.", call. = FALSE)
  
 
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
  
  outlier_prob <- try(
    fit$fit$summary("p_is_outlier"),
    silent = TRUE
  )
  
  out <- summarize_draws(
    abundance_draws,
    fit$stan_inputs$year_lookup$year,
    CI
  )
  
  outlier_prob <- try(
    fit$fit$summary("p_is_outlier"),
    silent = TRUE
  )
  
  if (!inherits(outlier_prob, "try-error")) {
    
    outlier_years <-
      data.frame(
        year = lubridate::year(fit$data$date),
        p_is_outlier = outlier_prob$mean
      ) |>
      dplyr::group_by(year) |>
      dplyr::summarise(
        n_outliers = sum(
          p_is_outlier > outlier_p_thresh
        ),
        .groups = "drop"
      )
    
    out <-
      dplyr::left_join(
        out,
        outlier_years,
        by = "year"
      )
    
  } else {
    
    out$n_outliers <- NA_integer_
    
  }
    
  
  if (!is.null(fit$TAUC))
    out <- dplyr::left_join(
      out,
      fit$TAUC,
      by = "year"
    )
}