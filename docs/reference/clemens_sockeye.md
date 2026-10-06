# Clemens Creek sockeye survey data

Repeated live-count surveys of sockeye salmon conducted at Clemens
Creek.

## Usage

``` r
clemens_sockeye
```

## Format

A data frame with 140 rows and 4 variables:

- date:

  Survey date

- spawner_counts:

  Observed live spawner count

- observer_efficiency:

  Observer efficiency correction

- coverage:

  Survey coverage correction

## Source

Fisheries and Oceans Canada. Data provided by Diana McHugh.

## Examples

``` r
data(clemens_sockeye)
head(clemens_sockeye)
#>        date spawner_counts observer_efficiency coverage
#> 1 16-Sep-11           1827             100.00%  100.00%
#> 2  6-Oct-11          17541              95.44%   90.00%
#> 3 14-Oct-11          11464              96.50%   85.00%
#> 4 24-Oct-11           2329              94.98%   95.00%
#> 5 27-Oct-11           7064              95.25%   90.00%
#> 6  1-Oct-12             27             100.00%  100.00%
```
