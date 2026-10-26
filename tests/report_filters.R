library(data.table)
library(apastats2)
library(Hmisc)
source('scripts/report_helpers.R')

local({
  env_names <- c('JATOS_START_DATE', 'GITHUB_ACTIONS', 'TZ')
  previous <- Sys.getenv(env_names, unset = NA_character_)
  on.exit({
    Sys.unsetenv(env_names[is.na(previous)])
    if (any(!is.na(previous))) {
      do.call(Sys.setenv, as.list(previous[!is.na(previous)]))
    }
  })
  Sys.setenv(JATOS_START_DATE = '2026-10-01', GITHUB_ACTIONS = 'true',
             TZ = 'Europe/Paris')
  data <- data.table(id = 1:5, startDate = as.POSIXct(c(
    '2026-09-30 23:59:59', '2026-10-01 00:00:00', '2026-10-01 00:00:01',
    '2026-10-02 12:00:00', NA), tz = 'UTC'))
  stopifnot(identical(filter_jatos_start_date(data)$id, 3:4))

  Sys.unsetenv('JATOS_START_DATE')
  stopifnot(inherits(try(filter_jatos_start_date(data), silent = TRUE), 'try-error'))
  Sys.setenv(GITHUB_ACTIONS = 'false')
  stopifnot(identical(filter_jatos_start_date(data), data))
  sapply(c('2026-02-30', '01/10/2026', 'invalid'), function(date) {
    Sys.setenv(JATOS_START_DATE = date)
    stopifnot(inherits(try(filter_jatos_start_date(data), silent = TRUE), 'try-error'))
  })
})

# Run the actual monsters cleanup on a one-participant data set.
monsters <- readLines('monsters/monsters.qmd')
cleanup <- monsters[seq(match('data <- drop_empty_cols(data)', monsters),
                       match('data[,log_rt:=log(rt)]', monsters))]
data <- data.table(participant = 1, expected_length = rep(5, 3),
                   trial_i_within_block = 1:3, lengthDiff = 0,
                   correct = c(1, 0, 1), rt = c(500, 700, 600))
eval(parse(text = cleanup))
stopifnot(nrow(data) == 3L, 'participant' %in% names(data),
          'lengthDiff' %in% names(data), all(data$participant == 1))

reports <- list.files('.', '\\.qmd$', recursive = TRUE)
reports <- reports[!startsWith(reports, 'renv/')]
invisible(lapply(reports, function(file) {
  lines <- readLines(file)
  if (any(grepl('filter_jatos_start_date', lines, fixed = TRUE))) {
    path <- if (dirname(file) == '.') 'scripts/report_helpers.R' else '../scripts/report_helpers.R'
    stopifnot(any(grepl(sprintf("source('%s')", path), lines, fixed = TRUE)))
  }
}))
cat('Report date filters and one-participant monsters cleanup passed.\n')

empty_report <- knitr::knit(text = c(
  '```{r, results="hide"}',
  'report_data_available(data.table(), "No eligible task data are available.")',
  '```', 'This analysis must not appear.',
  '```{r}', 'stop("Empty inputs reached the analysis.")', '```'
), quiet = TRUE, envir = environment())
stopifnot(grepl('No eligible task data are available.', empty_report, fixed = TRUE),
          !grepl('This analysis must not appear.', empty_report, fixed = TRUE))
cat('Empty reports show a data-availability notice and skip analyses.\n')
