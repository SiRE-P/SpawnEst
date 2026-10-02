#' Plot timing estimates
#'
#' Plot annual timing estimates from a fitted SpawnEst model.
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval widths to report.
#' @param format Either `"yday"` or `"date"`.
#'
#' @return A ggplot object. If an assumed residence time was
#' supplied during fitting, it is shown as a dashed horizontal
#' line in the Effective Residence panel.
#'
#' @export
plot_timing <- function(fit, CI = c(66, 95), format = c("yday", "date")) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
  format <- match.arg(format)
  
  if (format == "date")
    stop(
      "format = 'date' is not supported by plot_timing(). Use timing(fit, format = 'date') for tabular output.",
      call. = FALSE
    )
  
  tm <- timing(fit, CI = CI, format = format)
  
  dat <- dplyr::bind_rows(
    dplyr::mutate(tm$arrival_peak, parameter = "Peak arrival date"),
    dplyr::mutate(tm$arrival_spread, parameter = "Arrival spread"),
    dplyr::mutate(tm$effective_residence, parameter = "Effective residence"),
    dplyr::mutate(tm$exit_lag, parameter = "Exit lag")
  )
  
  if (!is.null(fit$assumed_residence)) {
    residence_line <- data.frame(
      parameter = "Effective residence",
      yintercept = fit$assumed_residence
    )
  }
  
  dat$parameter <- factor(
    dat$parameter,
    levels = c(
      "Peak arrival date",
      "Arrival spread",
      "Effective residence",
      "Exit lag"
    )
  )
  
  CI <- sort(unique(round(CI)))
  
  p <- ggplot2::ggplot(
    dat,
    ggplot2::aes(x = year, y = median)
  )
  
  for (i in seq_along(CI)) {
    
    ci <- CI[length(CI) - i + 1]
    
    p <- p +
      ggplot2::geom_errorbar(
        ggplot2::aes(
          ymin = .data[[paste0("lower_", ci)]],
          ymax = .data[[paste0("upper_", ci)]]
        ),
        width = 0,
        linewidth = seq(0.4, 1.1, length.out = length(CI))[i]
      )
    
  }
  
  yrs <- unique(dat$year)
  
  p <- p +
    ggplot2::geom_point(size = 2) +
    ggplot2::facet_wrap(
      ~parameter,
      scales = "free_y",
      ncol = 2
    ) +
    ggplot2::theme_bw() +
    ggplot2::scale_x_continuous(
      breaks = seq(
        floor(min(yrs) / 4) * 4,
        ceiling(max(yrs) / 4) * 4,
        by = 4
      )
    ) +
    ggplot2::labs(
      x = NULL,
      y = NULL
    )
  
  if (!is.null(fit$assumed_residence)) {
    
    p <- p +
      ggplot2::geom_hline(
        data = residence_line,
        ggplot2::aes(yintercept = yintercept),
        linetype = 2,
        colour = "red",
        inherit.aes = FALSE
      )
  }
  
  p
  
}