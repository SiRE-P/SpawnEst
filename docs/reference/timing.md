# Extract timing estimates

Extract annual timing estimates from a fitted spawnBayes model.

## Usage

``` r
timing(fit, CI = c(66, 95), format = c("yday", "date"))
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval widths to report.

- format:

  Either `"yday"` or `"date"`.

## Value

A named list containing timing estimates.
