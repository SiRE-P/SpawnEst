#' Plot fitted run curves
#'
#' Plot posterior estimates of spawners present through time
#' against observed survey counts for each year.
#'
#' Corrected survey counts used to fit the model are shown as
#' filled points. If observer-efficiency or coverage corrections
#' were applied, the original uncorrected survey counts are shown
#' as open circles.
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval width to report.
#'
#' @return A ggplot object showing fitted run curves and observed
#'   survey counts by year.
#'
#' @export
plot_run_curve <- function(fit, CI = 95) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
  if (!is.numeric(CI) || length(CI) != 1)
    stop("CI must be a single numeric value.", call. = FALSE)
  
  if (CI <= 0 || CI >= 100)
    stop("CI must be between 0 and 100.", call. = FALSE)
  
  alpha <- (1 - CI / 100) / 2
  
  years <- fit$stan_inputs$year_lookup$year
  day_stand <- fit$stan_inputs$day_stand
  max_day <- max(fit$stan_inputs$stan_data$day)
  
  arrival <- fit$fit$draws("arrival", format = "matrix")
  arrival_spread <- fit$fit$draws("arrival_spread", format = "matrix")
  exit_lag <- fit$fit$draws("exit_lag", format = "matrix")
  exit_spread <- fit$fit$draws("exit_spread", format = "matrix")
  log_run <- fit$fit$draws("log_run", format = "matrix")
  
  spawn_curves <- vector("list", ncol(log_run))
  
  for (j in seq_len(ncol(log_run))) {
    
    live <- sapply(-5:max_day, function(x) {
      
      entered <- stats::pnorm(
        x,
        arrival[, j],
        arrival_spread[, j]
      )
      
      exited <- stats::pnorm(
        x,
        arrival[, j] + exit_lag[, j],
        exit_spread[, j]
      )
      
      exp(
        log_run[, j] +
          log(pmax(entered * (1 - exited), 1e-8))
      )
      
    })
    
    spawn_curves[[j]] <- data.frame(
      year = years[j],
      day = (-5:max_day) + day_stand,
      fish = apply(live, 2, median),
      lower = apply(live, 2, quantile, probs = alpha),
      upper = apply(live, 2, quantile, probs = 1 - alpha)
    )
    
  }
  
  spawn_curves <- dplyr::bind_rows(spawn_curves)
  
  obs <- fit$data |>
    dplyr::mutate(
      year = lubridate::year(date),
      day = lubridate::yday(date)
    )
  
  show_uncorrected <- "spawner_counts_uncorrected" %in% names(obs) &&
    any(obs$spawner_counts_uncorrected != obs$spawner_counts)
  
  p <- ggplot2::ggplot(
    spawn_curves,
    ggplot2::aes(x = day, y = fish)
  ) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lower, ymax = upper),
      alpha = 0.2
    ) +
    ggplot2::geom_line() +
    ggplot2::geom_point(
      data = obs,
      ggplot2::aes(
        x = day,
        y = spawner_counts
      ),
      inherit.aes = FALSE,
      size = 1.2
    )
  
  if (show_uncorrected) {
    
    p <- p +
      ggplot2::geom_point(
        data = obs,
        ggplot2::aes(
          x = day,
          y = spawner_counts_uncorrected
        ),
        inherit.aes = FALSE,
        shape = 1,
        size = 2
      )+
      ggplot2::labs(
        caption = paste(
          "Open circles show uncorrected survey counts.",
          "Filled points show counts after observer-efficiency and coverage corrections."
        )
      )
    
  }
  
  p +
    ggplot2::facet_wrap(
      ~year,
      scales = "free_y"
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      strip.background = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        scale_cut = scales::cut_short_scale()
      ),
      name = "Spawners present"
    ) +
    ggplot2::scale_x_continuous(
      labels = function(x)
        format(
          as.Date(x, origin = "2023-12-31"),
          "%b"
        ),
      name = NULL
    )
  
}