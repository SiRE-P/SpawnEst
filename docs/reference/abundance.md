# Extract abundance estimates

Extract annual spawner abundance estimates from a fitted spawnBayes
model.

## Usage

``` r
abundance(fit, CI = c(66, 95))
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval widths to report.

## Value

A data frame containing annual abundance estimates. If an assumed
residence time was supplied when fitting the model, traditional TAUC
abundance estimates are also returned.
