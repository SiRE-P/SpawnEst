#' Validate SpawnEst input data
#'
#' @keywords internal
validate_data <- function(data) {
  
  if (!is.data.frame(data))
    stop("data must be a data.frame.", call. = FALSE)
  
  required_cols <- c("date", "spawner_counts")
  
  missing_cols <- setdiff(required_cols, names(data))
  
  if (length(missing_cols) > 0)
    stop(paste0("Missing required column(s): ", paste(missing_cols, collapse = ", ")), call. = FALSE)
  
  if (!inherits(data$date, "Date")) {
    data$date <- as.Date(as.character(data$date))
    
    if (any(is.na(data$date)))
      stop("date could not be converted to Date format.", call. = FALSE)
  }
  
  if (length(unique(data$date)) < 2)
    stop("At least two survey dates are required.", call. = FALSE)
  
  if (!is.numeric(data$spawner_counts))
    stop("spawner_counts must be numeric.", call. = FALSE)
  
  if (any(is.na(data$spawner_counts)))
    stop("spawner_counts contains missing values.", call. = FALSE)
  
  if (any(data$spawner_counts < 0))
    stop("spawner_counts cannot be negative.", call. = FALSE)
  
  if (all(data$spawner_counts == 0))
    stop("All spawner_counts are zero.", call. = FALSE)
  
  if (any(data$spawner_counts > 1e5))
    warning("Some spawner_counts exceed 100,000. Check that counts were entered correctly.", call. = FALSE)
  
  if (any(data$date > Sys.Date()))
    warning("Some survey dates occur in the future.", call. = FALSE)
  
  if (any(lubridate::year(data$date) < 1930))
    warning("Some survey dates occur before 1930. Check that dates were imported correctly.", call. = FALSE)
  
  year_counts <- data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::count(year)
  
  if (any(year_counts$n < 3))
    warning("Some years contain fewer than three surveys.", call. = FALSE)
  
  if (length(unique(lubridate::year(data$date))) < 2)
    warning("Only one year of data supplied. Data-derived priors may be unreliable.", call. = FALSE)
  
  if ("stream" %in% names(data) && all(is.na(data$stream)))
    warning("stream column contains only missing values.", call. = FALSE)
  
  if ("stream" %in% names(data)) {
    
    dup <- any(duplicated(data[c("stream", "date")]))
    
  } else {
    
    dup <- any(duplicated(data["date"]))
    
  }
  
  if (dup)
    warning("Duplicate survey dates detected.", call. = FALSE)
  
  if (!"observer_efficiency" %in% names(data))
    data$observer_efficiency <- 1
  
  if (!"coverage" %in% names(data))
    data$coverage <- 1
  
  if (any(is.na(data$observer_efficiency)))
    stop("observer_efficiency contains missing values.", call. = FALSE)
  
  if (any(data$observer_efficiency <= 0 |
          data$observer_efficiency > 1))
    stop(
      "observer_efficiency must be between 0 and 1.",
      call. = FALSE
    )
  
  if (any(is.na(data$coverage)))
    stop("coverage contains missing values.", call. = FALSE)
  
  if (any(data$coverage <= 0 |
          data$coverage > 1))
    stop(
      "coverage must be between 0 and 1.",
      call. = FALSE
    )
  
  year_modes <- data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::group_by(year) |>
    dplyr::group_modify(~{
      
      if (nrow(.x) < 5)
        return(data.frame(n_major_peaks = 1))
      
      sm <- stats::smooth.spline(
        lubridate::yday(.x$date),
        .x$spawner_counts
      )
      
      pred <- predict(
        sm,
        seq(
          min(lubridate::yday(.x$date)),
          max(lubridate::yday(.x$date)),
          by = 1
        )
      )$y
      
      peak_ind <- which(diff(sign(diff(pred))) < 0) + 1
      
      if (length(peak_ind) > 1) {
        
        peak_heights <- pred[peak_ind]
        
        major_peaks <- peak_ind[
          peak_heights > 0.5 * max(peak_heights)
        ]
        
        peak_days <- seq(
          min(lubridate::yday(.x$date)),
          max(lubridate::yday(.x$date)),
          by = 1
        )[major_peaks]
        
        n_major_peaks <- 1
        
        if (length(peak_days) > 1) {
          
          peak_sep <- diff(sort(peak_days))
          
          # Count only peaks separated by at least 10 days.
          # This avoids flagging small wiggles around a dominant peak.

          n_major_peaks <- 1 + sum(peak_sep >= 10)
          
        }
        
      } else {
        
        n_major_peaks <- 1
      }
      
      data.frame(n_major_peaks = n_major_peaks)
      
    })  
  n_multimodal <- sum(year_modes$n_major_peaks > 1)
  
  if (n_multimodal > 0)
    warning(
      paste0(
        "Potential multimodal run timing detected in ",
        n_multimodal,
        " of ",
        nrow(year_modes),
        " years. SpawnEst assumes a single run peak."
      ),
      call. = FALSE
    )
  
  data
}