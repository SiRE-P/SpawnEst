# Fit a spawner abundance model

Fit the spawnBayes model to repeated spawner count surveys.

## Usage

``` r
fit_spawner(
  data,
  abundance = NULL,
  assumed_residence = NULL,
  arrival_peak = NULL,
  arrival_quantile = 0.4,
  trim_zeros = TRUE,
  priors = NULL,
  chains = 4,
  iter_warmup = 1000,
  iter_sampling = 1000,
  refresh = 100,
  adapt_delta = 0.95
)
```

## Arguments

- data:

  A data frame containing survey observations.

- abundance:

  Prior estimate of total spawner abundance.

- assumed_residence:

  Assumed mean residence time (days), also known as survey life. If
  supplied, this value is used to construct the residence-time prior and
  to calculate traditional trapezoidal area under the curve (TAUC)
  abundance estimates. If NULL, the default spawnBayes residence-time
  prior is used and TAUC estimates are not calculated.

- arrival_peak:

  Expected peak arrival date. If NULL, a default value is estimated
  using the survey-date quantile specified by `arrival_quantile`.

- arrival_quantile:

  Quantile of survey dates used to estimate a default arrival peak date
  when `arrival_peak` is NULL. Ignored when `arrival_peak` is supplied.

- trim_zeros:

  Logical. Remove repeated leading and trailing zero-count surveys
  within years while retaining a single zero on either side of the run.

- priors:

  Additional model priors produced by
  [`default_priors()`](default_priors.md).

- chains:

  Number of MCMC chains.

- iter_warmup:

  Number of warmup iterations per chain.

- iter_sampling:

  Number of post-warmup iterations per chain.

- refresh:

  refresh Frequency of CmdStan progress updates.

- adapt_delta:

  Stan adaptation target acceptance rate.

## Value

A `spawnBayes_fit` object.

## Details

The input data must contain a `date` column and a `spawner_counts`
column.

Optional `observer_efficiency` and `coverage` columns may also be
supplied. If omitted, both are assumed to equal 1.
