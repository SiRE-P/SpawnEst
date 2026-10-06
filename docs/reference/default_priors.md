# Default prior specification

Create a default prior specification for spawnBayes.

## Usage

``` r
default_priors(
  data,
  abundance = NULL,
  assumed_residence = NULL,
  arrival_peak = NULL,
  arrival_quantile = 0.4
)
```

## Arguments

- data:

  A data frame containing survey observations.

- abundance:

  Expected total spawner abundance. If NULL, a default value is
  estimated from the observed counts.

- assumed_residence:

  Assumed mean residence time (days). If supplied, this value is used to
  define the residence-time prior. If NULL, a default prior is used.

- arrival_peak:

  Expected peak arrival date. If NULL, a default value is estimated
  using the survey-date quantile specified by `arrival_quantile`.

- arrival_quantile:

  Quantile of survey dates used to estimate a default arrival peak date
  when `arrival_peak` is NULL. Ignored when `arrival_peak` is supplied.

## Value

A list containing prior specifications.
