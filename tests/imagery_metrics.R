library(data.table)
library(jsonlite)
library(stringr)
library(circhelp)
library(apastats2)
library(ez)

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
  eval(parse(text = lines[startsWith(lines, 'data_color_accuracy <-')]))
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

local({
  # A hue-dependent bias must be removed even when similarity labels change.
  set.seed(20261110)
  hue <- seq(-179, 179, length.out = 240)
  fixture <- data.table(participant = 'S1', cue_n = rep(1:2, each = 240),
    target_color = rep(hue, 2), similarity_bin = rep(c(20, 45, 135), 160))
  fixture[, error := 20 * sin(4 * target_color * pi / 180) + rnorm(.N, sd = 3)]
  correction <- selection('db_res <- lapply', 'data_color[is_outlier==F')
  data_color <- copy(fixture)
  eval(parse(text = correction))
  corrected <- data_color$be_c
  stopifnot(all(is.finite(corrected)), sd(corrected) < sd(fixture$error) / 2)
  data_color <- copy(fixture)
  data_color[, similarity_bin := rev(similarity_bin)]
  eval(parse(text = correction))
  stopifnot(isTRUE(all.equal(data_color$be_c, corrected, tolerance = 1e-10)))
})
cat('Hue-dependent correction removes synthetic hue bias and is invariant to similarity labels.\n')

local({
  # Extra trials in one condition must not change equally weighted contrasts.
  fixture_dir <- tempfile('imagery-effects-')
  dir.create(fixture_dir)
  old_wd <- setwd(fixture_dir)
  on.exit({setwd(old_wd); unlink(fixture_dir, recursive = TRUE)})
  fixture <- CJ(participant = paste0('S', 1:6), target_noise = c('low', 'high'),
    distr_noise = c('low', 'high'), similarity_bin = c(20, 45, 135), cue_n = 1:2)
  fixture[, observer := match(participant, paste0('S', 1:6))]
  fixture[, abs_be_c := 10 + observer + (target_noise == 'high') * observer +
    (distr_noise == 'high') * observer / 2 + (cue_n - 1) * observer * 2]
  data_color_accuracy <- rbind(fixture, fixture[target_noise == 'high' & cue_n == 2])
  imagery_metrics <- unique(fixture[, .(participant, observer)])[, .(participant,
    vviq = ifelse(observer == 6, NA_real_, observer * 8),
    afterimage_relative = c(NA, -2, -1, 0, 1, 2)[observer])]
  start <- which(startsWith(lines, 'condition_accuracy <-'))
  end <- which(lines == '```' & seq_along(lines) > start)[1]
  analysis <- lines[seq.int(start, end - 1L)]
  eval(parse(text = analysis))
  stopifnot(nrow(condition_effects) == 12L,
    all(condition_effects[effect == 'target_noise', change] == 1:6),
    all(condition_effects[effect == 'report_order', change] == (1:6) * 2),
    !'distr_noise' %in% condition_effects$effect,
    nrow(effect_correlations) == 4L,
    all(c('target_noise_cost', 'report_order_cost') %in% names(imagery_metrics)),
    all(effect_correlations$n == 5L),
    all(effect_correlations[measure == 'vviq', method] == 'pearson'),
    all(effect_correlations[measure == 'afterimage_relative', method] == 'spearman'),
    isTRUE(all.equal(effect_correlations$p_holm, p.adjust(effect_correlations$p, 'holm'))))
  data_color_accuracy <- fixture[!(participant == 'S1' & target_noise == 'low' &
    distr_noise == 'low' & similarity_bin == 20 & cue_n == 1)]
  stopifnot(inherits(try(eval(parse(text = analysis)), silent = TRUE), 'try-error'))
})
cat('Imagery noise/order contrasts balance conditions, retain pairwise samples and adjust four tests.\n')

local({
  set.seed(20261110)
  data_color_accuracy <- CJ(participant = factor(1:12),
    target_noise = factor(c('low', 'high'), levels = c('low', 'high')),
    distr_noise = factor(c('low', 'high'), levels = c('low', 'high')),
    cue_n = factor(1:2))
  data_color_accuracy[, abs_be_c := 10 + match(participant, levels(participant)) +
    4 * (target_noise == 'high') + 3 * (cue_n == '2') +
    2 * (target_noise == 'high') * (cue_n == '2') + rnorm(.N)]
  start <- which(startsWith(lines, 'ez_res_abs_err <-'))
  end <- which(lines == ')' & seq_along(lines) > start)[1]
  eval(parse(text = lines[seq.int(start, end)]))
  stopifnot(nrow(ez_res_abs_err$ANOVA) == 7L,
    all(c('cue_n', 'target_noise:cue_n', 'distr_noise:cue_n',
      'target_noise:distr_noise:cue_n') %in% ez_res_abs_err$ANOVA$Effect))
  noise_plot <- eval(parse(text = selection('plot_pointrange(data_color_accuracy', '# Run ANOVA')))
  stopifnot(nrow(noise_plot$data) == 8L, uniqueN(noise_plot$data$cue_n) == 2L,
    nrow(ggplot_build(noise_plot)$layout$layout) == 2L)
})
cat('Imagery ANOVA includes report order and all interactions; Figure 2 preserves both report facets.\n')
