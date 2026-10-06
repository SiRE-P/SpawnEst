# Construct Stan data for spawnBayes

Convert validated survey data and prior specifications into the data
list required by the spawnBayes Stan model.

## Usage

``` r
make_stan_data(data, priors)
```

## Arguments

- data:

  A validated data frame containing survey observations.

- priors:

  A prior specification object returned by
  [`default_priors()`](default_priors.md).

## Value

A list containing:

- stan_data:

  Data list supplied to Stan.

- day_stand:

  Reference day used for day standardization.

- year_lookup:

  Mapping between Stan year indices and calendar years.
