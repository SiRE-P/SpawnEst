#' Plot abundance estimates
#'
#' @param fit A fitted SpawnEst model.
#' @param CI Credible interval widths to show
#'
#' @return A ggplot object. If traditional TAUC abundance
#' estimates are available, these are shown as red crosses.
#'
#' @export
plot_abundance <- function(fit, CI = c(66, 95)) {
  
  if (!inherits(fit, "spawnest_fit"))
    stop("fit must be a spawnest_fit object.", call. = FALSE)
  
  abund <- abundance(fit, CI = CI)
  
  CI <- sort(unique(round(CI)))
  
  p <- ggplot2::ggplot(
    abund,
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
        linewidth = seq(0.4, 1.2, length.out = length(CI))[i]
      )
  }
  
  yrs <- abund$year
  
  p <- p +
    ggplot2::geom_point(size = 2) +
    ggplot2::theme_bw() +
    ggplot2::scale_x_continuous(
      breaks = seq(
        floor(min(yrs) / 4) * 4,
        ceiling(max(yrs) / 4) * 4,
        by = 4
      )
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        scale_cut = scales::cut_short_scale()
      )
    ) +
    ggplot2::labs(
      x = NULL,
      y = "Spawners"
    )
  
  if ("TAUC" %in% names(abund)) {
    
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(y = TAUC),
        colour = "red",
        shape = 4,
        size = 2
      ) +
      ggplot2::labs(
        caption = "Red X = traditional TAUC estimate"
      )
    
  }
  
  p
  
}