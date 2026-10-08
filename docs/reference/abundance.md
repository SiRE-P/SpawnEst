# Extract abundance estimates

Extract annual spawner abundance estimates from a fitted spawnBayes
model.

## Usage

``` r
abundance(fit, CI = c(66, 95), outlier_p_thresh = 0.25)
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval widths to report.

- outlier_p_thresh:

  Probability threshold used to classify surveys as potential outliers
  when reporting annual outlier counts.

## Value

A data frame containing annual abundance estimates. If an outlier
observation model was fitted, the output also includes the number of
surveys within each year having posterior outlier probabilities
exceeding `outlier_p_thresh`.
