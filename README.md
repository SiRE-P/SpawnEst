# SpawnEst

`SpawnEst` implements the Bayesian spawner abundance estimation method described by Thompson et al. (2026) for estimating annual spawner abundance and run timing from repeated live-count surveys.

The package is designed to support salmon stock assessment and escapement monitoring programs. Users provide survey dates and spawner counts and obtain estimates of annual abundance, run timing, effective residence time, and associated uncertainty.

## Installation

```r
# install.packages("remotes")
remotes::install_github("SiRE-P/SpawnEst")
```
## Prerequisites

SpawnEst uses `cmdstanr` and requires a local installation of CmdStan.

Install `cmdstanr`:

```r
install.packages(
  "cmdstanr",
  repos = c(
    "https://mc-stan.org/r-packages/",
    getOption("repos")
  )
)
```

Then follow the official CmdStan installation instructions:

[CmdStan Installation Guide](https://mc-stan.org/docs/cmdstan-guide/installation.html)

Verify the installation:

```r
cmdstanr::cmdstan_version()
```


## Workflow

A typical analysis consists of:

1. Preparing survey data.
2. Specifying prior information (optional).
3. Fitting the model.
4. Evaluating model diagnostics.
5. Extracting abundance and timing estimates.
6. Visualizing model outputs.

```r
library(SpawnEst)

fit <- fit_spawner(counts)

abundance(fit)

timing(fit)

plot_abundance(fit)

plot_timing(fit)

plot_run_curve(fit)
```

## Data Requirements

Input data must contain:

| Variable | Description |
|-----------|-------------|
| date | Survey date |
| spawner_counts | Number of live spawners observed |

Optional columns:

| Variable | Description |
|-----------|-------------|
| observer_efficiency | Proportion of fish detected during a survey (0-1) |
| coverage | Proportion of spawning habitat surveyed (0-1) |
| stream | Stream identifier for future multi-stream analyses |

If `observer_efficiency` or `coverage` are omitted, values of 1 are assumed.

## Example Data

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

## Basic Analysis

Fit the model using automatically generated priors:

```r
fit <- fit_spawner(counts)
```

Check model diagnostics
```r
diagnostics(fit)
```

Extract annual abundance estimates:

```r
abundance(fit)
```

Extract annual timing estimates:

```r
timing(fit)
```

Plot fitted run curves against observed survey counts:

```r
plot_run_curve(fit)
```

Plot annual abundance estimates:

```r
plot_abundance(fit)
```

Plot annual timing estimates:

```r
plot_timing(fit)
```

## Traditional TAUC Comparison

A traditional trapezoidal area-under-the-curve (TAUC) estimate can be calculated alongside SpawnEst estimates by specifying an assumed residence time (survey life).

```r
fit <- fit_spawner(
  counts,
  assumed_residence = 11
)
```

The resulting abundance estimates include a TAUC comparison column:

```r
abundance(fit)
```

In abundance plots, TAUC estimates are displayed as red crosses.

In timing plots, the assumed residence time is displayed as a dashed red line in the Effective Residence panel.

## Prior Information

Users may optionally specify prior information:

```r
fit <- fit_spawner(
  counts,
  abundance = 50000,
  arrival_peak = 280
)
```

or

```r
fit <- fit_spawner(
  counts,
  abundance = 50000,
  arrival_peak = 280,
  assumed_residence = 11
)
```

## Development Status

This package is currently under active development.

## Citation

If you use `SpawnEst` in a publication, please cite:

Thompson, P.L., Akenhead, S.A., and Louie, C. 2026. *Bayesian estimation of spawner abundance and run timing from repeated live-count surveys*. Canadian Journal of Fisheries and Aquatic Sciences 83: 1–13.