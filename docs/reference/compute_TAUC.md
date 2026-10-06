# Compute traditional TAUC abundance estimates

Calculate annual abundance estimates using the traditional trapezoidal
area-under-the-curve (TAUC) method and an assumed mean residence time
(survey life).

## Usage

``` r
compute_TAUC(data, assumed_residence)
```

## Arguments

- data:

  A data frame containing survey observations.

- assumed_residence:

  Assumed mean residence time (days).

## Value

A `spawnBayes_fit` object containing:

- fit:

  CmdStanMCMC model fit.

- data:

  Input data used for fitting.

- priors:

  Prior specification used by the model.

- stan_inputs:

  Stan data supplied to the model.

- assumed_residence:

  User-supplied residence time assumption, if provided.

- TAUC:

  Traditional TAUC abundance estimates, if calculated.

## Details

The calculation follows the historical TAUC implementation used in
salmon escapement assessments, including half-life adjustments before
the first survey and after the final survey.
