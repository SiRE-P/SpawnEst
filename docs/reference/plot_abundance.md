# Plot abundance estimates

Plot abundance estimates

## Usage

``` r
plot_abundance(fit, CI = c(66, 95))
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval widths to show

## Value

A ggplot object. If traditional TAUC abundance estimates are available,
these are shown as red crosses.
