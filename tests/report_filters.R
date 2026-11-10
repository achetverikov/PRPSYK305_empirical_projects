library(data.table)
library(apastats2)
library(Hmisc)
library(stringr)
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
                   correct = c(1, 0, 1), rt = c(-100, 700, 600))
eval(parse(text = cleanup))
stopifnot(nrow(data) == 3L, 'participant' %in% names(data),
          'lengthDiff' %in% names(data), all(data$participant == 1),
          is.na(data$rt[1]), sum(data$correct) == 2)
eval(parse(text = monsters[grep('^data_rt <-', monsters)]))
stopifnot(nrow(data_rt) == 1L, data_rt$rt == 600)

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

# Run the temporal report's actual selectors on mixed old/new component metadata.
local({
  lines <- readLines('temporal_attention/temporal_attention.qmd')
  metadata <- data.frame(id = 1:2, studyState = c('FINISHED', 'STARTED'),
    startDate = 0, endDate = c(1, NA))
  selection <- grep('^finished_study_ids <- metadata', lines)
  eval(parse(text = lines[selection]))
  stopifnot(identical(finished_study_ids$id, 1L))
  comp_res_meta <- data.table(id = 11:15,
    componentUuid = c(rep('a17f07c4-4aeb-43f2-bc2a-cd17e122056b', 2),
      '83fe0c24-aa81-4968-8fc5-51ef7b0289a8',
      'a1bda501-c8ed-4919-8d22-2e326e65f953',
      'de4bf845-5725-4339-bd34-1da2887eb4d2'),
    componentState = c('FINISHED', 'RELOADED', rep('FINISHED', 3)))
  flist <- sprintf('study_result_1/comp-result_%s/data.txt', comp_res_meta$id)
  selection <- grep("^flist <- flist\\[str_extract\\(flist, 'comp-result_", lines)
  stopifnot(length(selection) == 1L)
  eval(parse(text = lines[selection + 0:2]))
  stopifnot(identical(flist, 'study_result_1/comp-result_11/data.txt'))
})
cat('Temporal attention selects finished main components, excluding reloads, practice, comments and feedback.\n')

# Run the monsters report's selectors on mixed session/component states and practice rows.
local({
  lines <- readLines('monsters/monsters.qmd')
  metadata <- data.frame(id = 1:2, studyState = c('FINISHED', 'STARTED'),
                         startDate = 0, endDate = c(1, NA))
  selection <- grep('^finished_study_ids <- metadata', lines)
  eval(parse(text = lines[selection]))
  stopifnot(identical(finished_study_ids$id, 1L))

  comp_res_meta <- data.table(id = 11:12, componentState = c('FINISHED', 'RELOADED'))
  flist <- sprintf('study_result_1/comp-result_%s/data.txt', comp_res_meta$id)
  selection <- grep("^flist <- flist\\[str_extract\\(flist, 'comp-result_", lines)
  stopifnot(length(selection) == 1L)
  eval(parse(text = lines[selection + 0:1]))
  stopifnot(identical(flist, 'study_result_1/comp-result_11/data.txt'))

  data <- data.table(block_i = c(NA, 1, 1),
                     trial_i_within_block = c(NA, 1, 2), rt = c(100, 500, 600))
  selection <- which(startsWith(lines, '  data <- data[!is.na(block_i)'))
  stopifnot(length(selection) == 1L)
  eval(parse(text = lines[selection]))
  stopifnot(identical(data$rt, c(500, 600)), nrow(data) == 2L)
})
cat('Monsters excludes unfinished sessions, reloaded components and practice trials.\n')

local({
  lines <- readLines('tomato_experience/tomatoes_experience_2026.qmd')
  metadata <- data.frame(id = 1:2, studyState = c('FINISHED', 'STARTED'),
                         startDate = 0, endDate = c(1, NA))
  eval(parse(text = lines[grep('^finished_study_ids <- metadata', lines)]))
  stopifnot(identical(finished_study_ids$id, 1L))
  comp_res_meta <- data.table(id = 11:13, componentId = c(39794, 39795, 39795),
    componentState = c('FINISHED', 'FINISHED', 'RELOADED'))
  flist <- sprintf('study_result_1/comp-result_%s/data.txt', comp_res_meta$id)
  selection <- grep("^flist <- flist\\[str_extract\\(flist, 'comp-result_", lines)
  eval(parse(text = lines[selection + 0:1]))
  stopifnot(identical(flist, 'study_result_1/comp-result_12/data.txt'))
})
cat('Tomatoes selects finished sessions and finished main components.\n')

local({
  lines <- readLines('temporal_attention/temporal_attention.qmd')
  data <- data.table(real_target_position = 1:3)
  eval(parse(text = lines[grep('data[, post_cue :=', lines, fixed = TRUE)]))
  stopifnot(is.factor(data$post_cue), identical(levels(data$post_cue), as.character(1:3)))
})
cat('Temporal positions are categorical.\n')


# Check participant-based inference, including missing response-category cells.
local({
  lines <- readLines('objects_states/objects_and_states.qmd')
  response_levels <- c('None correct', 'One correct', 'Both correct')
  none_same <- c(0, 1, 2, 3, 0, 4)
  one_same <- c(4, 3, 4, 2, 5, 3)
  none_diff <- c(2, 0, 3, 1, 2, 1)
  one_diff <- c(3, 4, 3, 4, 2, 5)
  counts <- data.table(participant = rep(1:6, 6),
    same_presented_state = rep(c(FALSE, TRUE), each = 18),
    response_type = rep(rep(response_levels, each = 6), 2),
    n = c(none_diff, one_diff, 10 - none_diff - one_diff,
          none_same, one_same, 10 - none_same - one_same))
  trials_grouped <- counts[rep(seq_len(.N), n)]
  trials_grouped[, same_presented_statef := factor(same_presented_state,
    labels = c('Different states', 'Same state'))]
  trials_grouped[, response_type := factor(response_type, levels = response_levels)]
  trials_grouped[, tot_correct := as.integer(response_type) - 1L]
  start <- grep('^response_counts <-', lines)
  end <- grep('^ggplot\\(response_distribution,', lines)
  eval(parse(text = lines[start:(end - 1)]))
  stopifnot(nrow(response_props) == 36L,
    all(abs(response_props[, sum(prop), by = .(participant, same_presented_statef)]$V1 - 1) < 1e-12),
    response_props[participant == 1 & same_presented_statef == 'Same state' &
      response_type == 'None correct', prop] == 0,
    isTRUE(all.equal(response_tests[response_type == 'None correct', p],
      t.test(none_same / 10, none_diff / 10, paired = TRUE)$p.value)),
    identical(response_tests$p_holm, p.adjust(response_tests$p, method = 'holm')))
  binding_start <- grep('^accuracy_by_participant <- trials_grouped', lines)
  binding_end <- which(seq_along(lines) > binding_start & lines == '```')[1]
  plot_start <- grep('^plot_pointrange\\(accuracy_by_participant,', lines)
  plot_end <- which(seq_along(lines) > plot_start & lines == '```')[1]
  binding <- lines[binding_start:(binding_end - 1)]
  plot_code <- lines[plot_start:(plot_end - 1)]
  eval(parse(text = binding))
  original <- eval(parse(text = plot_code))$data
  trials_grouped <- trials_grouped[rep(seq_len(.N), 5)]
  eval(parse(text = binding))
  duplicated <- eval(parse(text = plot_code))$data
  stopifnot(nrow(accuracy_by_participant) == 12L, isTRUE(all.equal(original, duplicated)))
})
cat('Object comparisons use paired within-condition proportions; binding intervals use participants.\n')
