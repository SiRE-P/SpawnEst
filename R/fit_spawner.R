#' Fit a spawner abundance model
#'
#' Fit the SpawnEst model to repeated spawner count surveys.
#'
#' The input data must contain a `date` column and a
#' `spawner_counts` column. An optional `stream` column may
#' be provided to fit multiple streams independently.
#'
#' @param data A data frame containing survey observations.
#' @param abundance Prior estimate of total spawner abundance.
#' @param assumed_residence Assumed mean residence time (days), also known as survey life.
#'   If supplied, this value is used to construct the residence-time
#'   prior and to calculate traditional trapezoidal area under the curve (TAUC) abundance estimates.
#'   If NULL, the default SpawnEst residence-time prior is used and
#'   TAUC estimates are not calculated.
#' @param arrival_peak Expected peak arrival date. If NULL,
#'   a default value is estimated using the survey-date
#'   quantile specified by `arrival_quantile`.
#' @param arrival_quantile Quantile of survey dates used to estimate
#'   a default arrival peak date when `arrival_peak` is NULL.
#'   Ignored when `arrival_peak` is supplied.
#' @param priors Additional model priors produced by
#'   [default_priors()].
#' 
#' @param chains Number of MCMC chains.
#' @param iter_warmup Number of warmup iterations per chain.
#' @param iter_sampling Number of post-warmup iterations per chain.
#' @param adapt_delta Stan adaptation target acceptance rate.
#'
#' @return A `spawnest_fit` object.
#'
#' @export
fit_spawner <- function(
    data,
    abundance = NULL,
    assumed_residence = NULL,
    arrival_peak = NULL,
    arrival_quantile = 0.4,
    priors = NULL,
    chains = 4,
    iter_warmup = 1000,
    iter_sampling = 1000,
    adapt_delta = 0.95
){
  
  if (!is.null(assumed_residence)) {
    
    if (!is.numeric(assumed_residence) ||
        length(assumed_residence) != 1 ||
        assumed_residence <= 1)
      stop(
        "assumed_residence must be a single numeric value greater than 1.",
        call. = FALSE
      )
  }
  
  data <- validate_data(data)
  
  TAUC <- compute_TAUC(
    data = data,
    assumed_residence = assumed_residence
  )
  
  if (is.null(priors))
    priors <- default_priors(
      data = data, 
      abundance = abundance,
      assumed_residence = assumed_residence,
      arrival_peak = arrival_peak,
      arrival_quantile = arrival_quantile
    )
  
  stan_inputs <- make_stan_data(
    data = data,
    priors = priors
  )
  
  stan_file <- system.file("stan", "spawnest.stan", package = "SpawnEst")
  
  mod <- cmdstanr::cmdstan_model(stan_file)
  
  fit <- mod$sample(
    data = stan_inputs$stan_data,
    init = function() make_inits(stan_inputs$stan_data),
    chains = chains,
    parallel_chains = chains,
    iter_warmup = iter_warmup,
    iter_sampling = iter_sampling,
    adapt_delta = adapt_delta
  )
  
  structure(
    list(
      fit = fit,
      data = data,
      priors = priors,
      stan_inputs = stan_inputs,
      assumed_residence = assumed_residence,
      TAUC = TAUC
    ),
    class = "spawnest_fit"
  )
}
