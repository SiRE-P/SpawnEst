# Plot fitted run curves

Plot posterior estimates of spawners present through time against
observed survey counts for each year.

## Usage

``` r
plot_run_curve(fit, CI = c(66, 95))
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Numeric vector of credible interval widths to plot. Multiple intervals
  may be supplied (e.g., `c(66, 95)`).

## Value

A ggplot object showing fitted run curves and observed survey counts by
year. When available, observation colours indicate posterior
probabilities of belonging to the outlier observation component.

## Details

When an outlier observation model is used, point colours indicate the
posterior probability that a survey belongs to the outlier component.

Corrected survey counts used to fit the model are shown as filled
points. If observer-efficiency or coverage corrections were applied, the
original uncorrected survey counts are shown as open circles.
