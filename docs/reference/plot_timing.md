# Plot timing estimates

Plot annual timing estimates from a fitted spawnBayes model.

## Usage

``` r
plot_timing(fit, CI = c(66, 95), format = c("yday", "date"))
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval widths to report.

- format:

  Either `"yday"` or `"date"`.

## Value

A ggplot object. If an assumed residence time was supplied during
fitting, it is shown as a dashed horizontal line in the Effective
Residence panel.
