library(data.table)
library(jsonlite)
library(stringr)

lines <- readLines('colors_and_imagery/colors_and_imagery.qmd')
selection <- function(first, last) {
  start <- which(startsWith(lines, first))
  end <- which(startsWith(lines, last))
  stopifnot(length(start) == 1L, length(end) == 1L, end > start)
  lines[seq.int(start, end - 1L)]
}

local({
  fixture_dir <- tempfile('imagery-fixtures-')
  dir.create(fixture_dir)
  on.exit(unlink(fixture_dir, recursive = TRUE))
  flist_vviq <- flist_afterimage <- character()
  for (i in 1:4) {
    folder <- file.path(fixture_dir, paste0('study_result_', 100 + i))
    dir.create(folder)
    questionnaire <- if (i == 3L) list(list(trial_type = 'browser-check')) else
      rep(list(list(trial_type = 'survey-likert', response = as.list(setNames(rep(i - 1L, 4), paste0('Q', 0:3))))), 4)
    flist_vviq[i] <- file.path(folder, paste0('comp-result_', 200 + i, '.txt'))
    write_json(questionnaire, flist_vviq[i], auto_unbox = TRUE)
    flist_afterimage[i] <- file.path(folder, paste0('comp-result_', 300 + i, '.txt'))
    write_json(list(list(ai_run = 1, ai_page = 'relative_rating', ai_code = -2),
                    list(ai_run = 2, ai_page = 'relative_rating', ai_code = c(-1, 3, 1, 2)[i])),
               flist_afterimage[i], auto_unbox = TRUE)
  }
  finished_study_ids <- data.table(id = as.character(101:104))
  eval(parse(text = selection('data_vviq <- rbindlist', 'data_color <- suppressWarnings')))
  stopifnot(nrow(data_vviq) == 4L, is.na(data_vviq[participant == '103', vviq]),
            data_vviq[participant == '101', vviq] == 0,
            is.na(data_vviq[participant == '102', afterimage_relative]),
            identical(data_vviq[participant == '104', afterimage_relative], 2))

  data_color <- data.table(participant = rep(c('104', '101', '102'), each = 3),
    abs_be_c = c(6, 8, 100, 1, 3, 100, 2, 4, 100), is_outlier = rep(c(FALSE, FALSE, TRUE), 3))
  eval(parse(text = selection('data_color <- merge(data_color, data_vviq', "data_color[,c('startDate'")))
  # Identity must agree after pseudonymization, even when the source rows were reordered.
  stopifnot(all(data_color[, unique(vviq), by = participant][data_vviq, on = 'participant',
    nomatch = 0, V1 == vviq]), !anyDuplicated(data_vviq$participant))

  old_wd <- setwd(fixture_dir)
  on.exit(setwd(old_wd), add = TRUE, after = FALSE)
  start <- which(startsWith(lines, 'memory_metrics <- data_color'))
  end <- which(lines == '```' & seq_along(lines) > start)[1]
  eval(parse(text = lines[seq.int(start, end - 1L)]))
  stopifnot(nrow(imagery_metrics) == 4L,
            imagery_metrics[vviq == 0, memory_mae] == 2,
            imagery_metrics[vviq == 16, memory_mae] == 3,
            imagery_metrics[vviq == 48, memory_mae] == 7,
            is.na(imagery_metrics[is.na(vviq), memory_mae]),
            identical(imagery_correlations$n, c(2L, 3L, 2L)),
            all(is.na(imagery_correlations$estimate[c(1, 3)])),
            is.finite(imagery_correlations$estimate[2]))
})
cat('Imagery identity joins, missing scores, main-run ratings, MAE and pairwise samples passed.\n')
