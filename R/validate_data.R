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
  
  data
  
}