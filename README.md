# SpawnEst

`SpawnEst` implements the Bayesian spawner abundance estimation method described by Thompson et al. (2026) for estimating annual spawner abundance and run timing from repeated live-count surveys.

The package is designed to support salmon stock assessment and escapement monitoring programs. Users provide live-count observations and prior information and obtain estimates of annual spawner abundance, run timing, and associated uncertainty.

## Installation

```r
# install.packages("remotes")
remotes::install_github("SiRE-P/SpawnEst")
```

## Workflow

A typical analysis consists of:

1. Preparing live-count survey data.
2. Specifying prior distributions.
3. Fitting the model.
4. Evaluating model diagnostics.
5. Extracting abundance and run timing estimates.

```r
library(SpawnEst)

fit <- fit_spawner(
  data = counts
)

abundance(fit)

plot_run_timing(fit)
```

## Data Requirements

Input data should contain:

| Variable | Description |
|-----------|-------------|
| year | Survey year |
| day | Day of year |
| live_count | Number of live spawners observed |

Example:

```r
counts <- data.frame(
  year = c(2020, 2020, 2020),
  day = c(250, 260, 270),
  live_count = c(150, 320, 180)
)
```

## Development Status

This package is currently under active development.

## Citation

If you use `SpawnEst` in a publication, please cite:

Thompson, P.L., Akenhead, S.A., and Louie, C. 2026. Bayesian estimation of spawner abundance and run timing from repeated live-count surveys. *Canadian Journal of Fisheries and Aquatic Sciences* 83: 1-13.