filter_jatos_start_date <- function(data) {
  start_date <- Sys.getenv('JATOS_START_DATE')
  if (!nzchar(start_date)) {
    if (Sys.getenv('GITHUB_ACTIONS') == 'true') {
      stop('Set the GitHub repository variable JATOS_START_DATE before rendering.')
    }
    return(data)
  }
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', start_date) ||
      is.na(as.Date(start_date, format = '%Y-%m-%d'))) {
    stop('JATOS_START_DATE must be a valid date in YYYY-MM-DD format.')
  }
  cutoff <- as.POSIXct(start_date, format = '%Y-%m-%d', tz = 'UTC')
  data[!is.na(startDate) & startDate > cutoff]
}
