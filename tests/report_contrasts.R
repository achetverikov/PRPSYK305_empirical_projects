library(data.table)
library(apastats2)

report_chunk <- function(file, label) {
  lines <- readLines(file)
  start <- match(paste0('#| label: ', label), lines)
  end <- which(seq_along(lines) > start & lines == '```')[1]
  lines[(start + 1):(end - 1)]
}

local({
  data <- CJ(participant = 1:8, cue_type = c('valid', 'neutral', 'invalid'), post_cue = 1:3)
  data[, abs_err := 20 + participant + post_cue +
    fifelse(cue_type == 'valid', -participant / 2, 0) +
    fifelse(cue_type == 'invalid', participant / 3 + post_cue, 0)]
  eval(parse(text = report_chunk('temporal_attention/temporal_attention.qmd',
    'temporal-cost-benefit-tests')))
  stopifnot(nrow(cb_tests) == 6L, all(cb_tests$n == 8L),
    all(cb_tests$mean_change > 0),
    identical(cb_tests$p_holm, p.adjust(cb_tests$p, 'holm')))
  paired <- dcast(data[post_cue == 1], participant ~ cue_type, value.var = 'abs_err')
  stopifnot(isTRUE(all.equal(cb_tests[post_cue == 1 & effect == 'benefit', p],
    t.test(paired$neutral, paired$valid, paired = TRUE)$p.value)))
})
cat('Temporal differences have the intended sign and match paired tests, with six-test adjustment.\n')

local({
  counts <- CJ(participant = 1:8, condition = c('numeric', 'perceptual'),
    decoy_on = c('target', 'competitor', 'no_decoy'))
  counts[, target := 55 + participant + (condition == 'numeric') * participant / 2 +
    (decoy_on == 'target') * participant - (decoy_on == 'competitor') * participant]
  counts[, competitor := 100 - target]
  # Diverting some choices to a decoy must not change the relative target share.
  counts[decoy_on == 'target', c('target', 'competitor') := .(target * .8, competitor * .8)]
  counts[, decoy := 100 - target - competitor]
  choice_props <- melt(counts, id.vars = c('participant', 'condition', 'decoy_on'),
    measure.vars = c('target', 'competitor', 'decoy'), variable.name = 'chosen_item', value.name = 'n')
  choice_props[, prop_choices := 100 * n / sum(n), by = .(participant, condition, decoy_on)]
  eval(parse(text = report_chunk('decoy_choices/decoy_choices_2026H.qmd', 'decoy-placement-tests')))
  eval(parse(text = report_chunk('decoy_choices/decoy_choices_2026H.qmd', 'decoy-relative-share-tests')))
  expected <- counts[, .(participant, condition, decoy_on,
    expected = 100 * target / (target + competitor))]
  stopifnot(nrow(placement_tests) == 3L, nrow(control_tests) == 4L,
    all(control_tests$n == 8L),
    identical(placement_tests$p_holm, p.adjust(placement_tests$p, 'holm')),
    identical(control_tests$p_holm, p.adjust(control_tests$p, 'holm')),
    all(abs(merge(relative_choices, expected)$relative_share - merge(relative_choices, expected)$expected) < 1e-10))
  expected_shift <- dcast(expected, participant + condition ~ decoy_on, value.var = 'expected')
  stopifnot(isTRUE(all.equal(control_tests[condition == 'numeric' & placement == 'target', p],
    expected_shift[condition == 'numeric', t.test(target, no_decoy, paired = TRUE)$p.value])))
})
cat('Decoy tests use paired placement effects and relative shares against observed controls.\n')

local({
  set.seed(20261110)
  data_color_accuracy <- CJ(participant = 1:12, target_noise = c('low', 'high'),
    distr_noise = c('low', 'high'), cue_n = factor(1:2))
  data_color_accuracy[, abs_be_c := 10 + participant + (as.integer(cue_n) - 1) *
    (participant / 2 + (target_noise == 'high')) + rnorm(.N, sd = .1)]
  eval(parse(text = report_chunk('colors_and_imagery/colors_and_imagery.qmd',
    'imagery-report-order-tests')))
  stopifnot(nrow(order_tests) == 5L, all(order_tests$n == 12L),
    all(order_tests$mean_change > 0), identical(order_tests$p_holm, p.adjust(order_tests$p, 'holm')))
  expected <- data_color_accuracy[, .(mae = mean(abs_be_c)), by = .(participant, cue_n)]
  expected <- dcast(expected, participant ~ cue_n, value.var = 'mae')
  stopifnot(isTRUE(all.equal(order_tests[comparison == 'All noise conditions', p],
    t.test(expected$`2`, expected$`1`, paired = TRUE)$p.value)))
})
cat('Imagery report-order tests cover four noise combinations and the overall comparison.\n')
