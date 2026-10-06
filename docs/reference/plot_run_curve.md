# Plot fitted run curves

Plot posterior estimates of spawners present through time against
observed survey counts for each year.

## Usage

``` r
plot_run_curve(fit, CI = 95)
```

## Arguments

- fit:

  A fitted spawnBayes model.

- CI:

  Credible interval width to report.

## Value

A ggplot object showing fitted run curves and observed survey counts by
year.

## Details

Corrected survey counts used to fit the model are shown as filled
points. If observer-efficiency or coverage corrections were applied, the
original uncorrected survey counts are shown as open circles.
