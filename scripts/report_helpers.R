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

report_data_available <- function(data, message) {
  if (!NROW(data)) {
    knitr::knit_exit(append = paste0('\n\n## Data availability\n\n', message, '\n'))
  }
  invisible(NROW(data) > 0)
}

read_jatos_export <- function(study_uid, results_dir) {
  # A private ZIP can pin a report to the exact snapshot used for an audit.
  archive <- Sys.getenv('JATOS_RESULTS_FILE')
  if (!nzchar(archive)) {
    archive <- tempfile(fileext = '.zip')
    on.exit(unlink(archive), add = TRUE)
    response <- httr::GET('https://jatos.mindprobe.eu/jatos/api/v1/results',
      query = list(studyUuid = study_uid),
      httr::add_headers(Authorization = paste('Bearer', Sys.getenv('JATOS_TOKEN'))),
      httr::write_disk(archive), handle = httr::handle(''), httr::timeout(180))
    httr::stop_for_status(response)
  }
  utils::unzip(archive, exdir = results_dir)
  metadata_file <- list.files(results_dir, 'metadata[.]json$', full.names = TRUE, recursive = TRUE)
  stopifnot(length(metadata_file) == 1L)
  export <- jsonlite::fromJSON(metadata_file)$data
  if (length(export$studyUuid) != 1L || export$studyUuid != study_uid) {
    stop('The result archive does not belong to the configured study.')
  }
  export$studyResults[[1]]
}
