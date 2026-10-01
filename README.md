# SpawnEst

`SpawnEst` implements the Bayesian spawner abundance estimation method described by Thompson et al. (2026) for estimating annual spawner abundance and run timing from repeated live-count surveys.

The package is designed to support salmon stock assessment and escapement monitoring programs. Users provide survey dates and observed spawner counts and obtain annual estimates of spawner abundance, run timing, and associated uncertainty.

## Installation

```r
# install.packages("remotes")
remotes::install_github("SiRE-P/SpawnEst")
```

## Workflow

A typical analysis consists of:

1. Preparing survey data.
2. Specifying prior information (optional).
3. Fitting the model.
4. Evaluating model diagnostics.
5. Extracting abundance and timing estimates.

```r
library(SpawnEst)

fit <- fit_spawner(counts)

abundance(fit)

timing(fit)
```

## Data Requirements

Input data must contain:

| Variable | Description |
|-----------|-------------|
| date | Survey date |
| spawner_counts | Number of live spawners observed |

An optional `reach` column may also be supplied for future multi-reach analyses.

Example:

```r
counts <- data.frame(
  date = as.Date(c(
    "2020-09-01",
    "2020-09-10",
    "2020-09-20",
    "2021-09-05",
    "2021-09-15",
    "2021-09-25"
  )),
  spawner_counts = c(
    150,
    320,
    180,
    175,
    340,
    210
  )
)
```

## Example

Fit the model using automatically generated priors:

```r
fit <- fit_spawner(counts)
```

Extract annual abundance estimates:

```r
abundance(fit)
```

Extract annual timing estimates:

```r
timing(fit)
```

Specify prior information:

```r
fit <- fit_spawner(
  counts,
  abundance = 50000,
  arrival_peak = 280
)
```

## Development Status

This package is currently under active development.

## Citation

If you use `SpawnEst` in a publication, please cite:

Thompson, P.L., Akenhead, S.A., and Louie, C. 2026. Bayesian estimation of spawner abundance and run timing from repeated live-count surveys. *Canadian Journal of Fisheries and Aquatic Sciences* 83: 1–13.