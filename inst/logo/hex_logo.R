library(ggplot2)
library(hexSticker)
library(png)
library(grid)
library(magick)

spawners <- read.csv("./data/Copy of Clemens_SIL_compilIation (D McHugh 250620)_mod.csv") |> 
  filter(Spc == "SK") |> 
  select(date = Date, spawner_counts = LiveAdults, observer_efficiency = ObsEfficiency, coverage = EstPctSeen) 

spawners <- validate_data(spawners)

fit <- fit_spawner(spawners, iter_warmup = 1000, iter_sampling = 1000, assumed_residence = 15.5, adapt_delta = 0.99)
diagnostics(fit)

get_logo_curve <- function(fit, year = 2019) {
  
  years <- fit$stan_inputs$year_lookup$year
  j <- which(years == year)
  
  if (length(j) != 1)
    stop("Year not found")
  
  day_stand <- fit$stan_inputs$day_stand
  max_day <- max(fit$stan_inputs$stan_data$day)
  
  arrival <- fit$fit$draws("arrival", format = "matrix")
  arrival_spread <- fit$fit$draws("arrival_spread", format = "matrix")
  exit_lag <- fit$fit$draws("exit_lag", format = "matrix")
  exit_spread <- fit$fit$draws("exit_spread", format = "matrix")
  log_run <- fit$fit$draws("log_run", format = "matrix")
  
  live <- sapply(-5:max_day, function(x) {
    
    entered <- pnorm(
      x,
      arrival[, j],
      arrival_spread[, j]
    )
    
    exited <- pnorm(
      x,
      arrival[, j] + exit_lag[, j],
      exit_spread[, j]
    )
    
    exp(
      log_run[, j] +
        log(pmax(entered * (1 - exited), 1e-8))
    )
  })
  
  curve <- data.frame(
    day = (-5:max_day) + day_stand,
    median = apply(live, 2, median),
    l66 = apply(live, 2, quantile, probs = 0.17),
    u66 = apply(live, 2, quantile, probs = 0.83),
    l95 = apply(live, 2, quantile, probs = 0.025),
    u95 = apply(live, 2, quantile, probs = 0.975)
  )
  
  obs <- fit$data |>
    dplyr::mutate(
      year = lubridate::year(date),
      day = lubridate::yday(date)
    ) |>
    dplyr::filter(year == !!year) |>
    dplyr::select(day, spawner_counts)
  
  peak <- max(curve$median)
  
  curve <- curve |>
    dplyr::mutate(
      dplyr::across(
        c(median, l66, u66, l95, u95),
        ~ .x / peak
      )
    )
  
  obs <- obs |>
    dplyr::mutate(
      spawner_counts = spawner_counts / peak
    )
  
  list(
    curve = curve,
    obs = obs
  )
}


# "#0B0405FF" "#382A54FF" "#395D9CFF" "#3497A9FF" "#60CEACFF" "#DEF5E5FF"

col95 <- "#bdd7e7"
col66 <- "#6baed6"
colmed <-"#2171b5"

fish <- image_read_svg("./inst/logo/sockeye.svg")

fish_grob <- rasterGrob(
  as.raster(fish),
  interpolate = TRUE
)


curve_2019 <- get_logo_curve(fit)

p <- ggplot(curve_2019$curve, aes(day, median)) +
  
  geom_ribbon(
    aes(ymin = l95, ymax = u95),
    fill = col95,
    alpha = 1
  ) +
  
  geom_ribbon(
    aes(ymin = l66, ymax = u66),
    fill = col66,
    alpha = 1
  ) +
  
  geom_line(
    linewidth = 1.8,
    colour = colmed,
  ) +
  
  geom_point(
    data = curve_2019$obs,
    aes(x = day, y = spawner_counts),
    inherit.aes = FALSE,
    size = 2.5,
    colour = "black"
  ) +
  
  coord_cartesian(
    ylim = c(0, 1.8)
  )+
  
  theme_void()

p <- p + annotation_custom(
  fish_grob,
  xmin = 130,
  xmax = 320,
  ymin = 0.5,
  ymax = 0.9
)

p

ggsave(
  "./inst/logo/curve7.png",
  p,
  width = 5,
  height = 3,
  bg = "transparent",
  dpi = 600
)


sticker(
  subplot = "./inst/logo/curve7.png",
  package = "spawnBayes",
  p_family = "sans",
  p_size = 20,
  p_color = "#102A43",
  
  s_x = 1,
  s_y = 1.05,
  s_width = 0.9,
  s_height = 0.8,
  
  sticker = "./inst/logo/fish.svg",
  sticker_x = 1,
  sticker_y = 0.75,
  sticker_width = 0.45,
  
  
  h_fill = "#eff3ff",
  h_color = "#102A43",
  h_size = 1.5,
    
  
  filename = "./man/figures/logo.png"
)

