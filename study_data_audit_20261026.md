# Teaching study data audit, 26 October 2026

## Follow-up: every component in every available session

A later fresh check covers all sessions in the same 11 configured study IDs,
including all historical finished sessions. Fresh metadata were compared with
the previous exports; changed studies were exported again. The counts in this
section supersede the earlier snapshot below.

Across the eight available studies, **548 sessions are marked `FINISHED`**.
**534 have complete required component data; 14 have a gap**. Four of those 14
are the autumn-imagery cases already diagnosed. The other ten are listed by
study below. These are saved session records, not an assertion about distinct
human participants across studies.

| Study | FINISHED sessions | Complete required component data | Confirmed gaps |
|---|---:|---:|---|
| Temporal attention | 110 | 110 | None; includes all four newer feedback/comment sequences |
| Autumn decoy | 10 | 10 | None; nine current 240-trial sessions and one older 288-trial session |
| Spring decoy | 40 | 40 | None; all have 288 main trials |
| Tomatoes / subset averaging | 52 | 51 | One older session has only a browser check in practice; its 288 main responses are present |
| Objects | 135 | 132 | One older browser-check-only session; two older sessions have 200 learning events and 100 test trials but lack learning-item identity/state fields |
| Monsters | 152 | 147 | Five browser-check-only sessions, including one after the October cutoff; no task trials in those five |
| Spring imagery | 39 | 38 | One session lacks questionnaire and practice responses; both main blocks are present |
| Autumn imagery | 10 | 6 | Four sessions lack questionnaire and practice responses; adaptation and both memory blocks are present |

For the current reporting cohort, the other-study counts are: temporal attention
6/6 complete, autumn decoy 10/10, tomatoes 13/13, objects 12/12, and monsters
12/13. The remaining rows are older cohorts. Three deleted legacy endpoints
still have no server results and cannot be assessed without archived exports.

### What was checked

- Each required component was matched by its recorded component identity.
  Reloaded/empty attempts were not counted as missing when a complete saved
  attempt exists for the same session and component.
- Questionnaires were checked for all 16 item responses; imagery main blocks
  for 192 reports per autumn block or 288 per spring block; practice for complete
  recorded cycles; adaptation for both runs and all coded questions.
- Temporal attention has 150 main-trial responses. Comments and feedback were
  required only for its newer `temporal-feedback-v2` protocol, not for the older
  two-component version verified in Git history. Blank optional comments are
  valid when the saved comment/skip record is present.
- Objects were checked for 200 learning-item records, their recorded item/state
  information, 100 test trials and 200 item reports. The two early sessions with
  missing learning-item metadata retain test data but cannot support the newer
  item-specific retention-lag reconstruction from their learning records.
- Monsters were checked using recorded block/position keys and each block's
  recorded planned length, allowing its 96-block/576-trial and 144-block/864-trial
  protocols. A saved timed-out trial is not missing data; low responding is a
  separate performance/exclusion question.

All ten new gap cases outside autumn imagery are historical except the one
current-cohort monster session. Every browser-check-only gap has a recorded
window dimension below the minimum. At the time of this audit, the unconditional
save-and-advance callback was present in the monster, object and spring-imagery
routines. The subsequent deployments below protect autumn imagery, Monsters
and Objects. Spring imagery remains unchanged. The audit itself changed no
completion statuses or analysis exclusions; the historical gaps remain.

A private, per-session CSV with result/worker IDs and issue descriptions is kept
outside this repository at:
`C:\Users\anche7026\AppData\Local\Temp\prpsyk305-components-20261026-wkjka8in\finished_session_issues_PRIVATE.csv`.
Raw exports and private manifests are retained in that same temporary audit folder.

## Completion-flow repairs deployed on 26 October 2026

- Autumn imagery (28788) was repaired at approximately 12:53 Europe/Paris.
  Questionnaire, training and main-block advancement now requires a normal-end
  marker, complete expected responses and an acknowledged result save. Browser
  exclusions stay in the current component; failed saves offer an identical
  retry. Source commit: `1b988df5a82f9cbbd8d1918ada4279f07bad2061`.
- Monsters (18334) and Objects (18335) were repaired at approximately 13:36
  Europe/Paris. Monsters validates all planned block/trial keys, including valid
  recorded timeouts. Objects validates all learning-image identities/states and
  both choices in every test. Both require a normal-end marker and acknowledged
  saving before advancement. Source commit:
  `671090bee4a008ea36baa63677fd58f70f6c1147`.
- Fresh checks immediately before each deployment found no recent unfinished
  participant activity: a five-minute window for imagery, and a conservative
  60-minute window for both Monsters and Objects. The latest unfinished activity
  predated deployment by several days. No production participant bots were run.
- Isolated local JATOS copies passed normal completion, browser exclusion and
  failed-save/retry scenarios. Stored synthetic exports were checked. All uploaded
  assets were read back byte-for-byte, and full pull-back snapshots matched the
  source commits. Study/component identities, batches and existing links were
  preserved. Deployment records are committed and pushed in `jatos-studies`.

## Issues still open

- `overall_progress.qmd` counts server-side `FINISHED` sessions rather than verified
  complete datasets. In the audited current cohort, Monsters has 13 finished
  sessions but 12 task datasets. Autumn imagery has 10 complete memory datasets
  but only six complete questionnaires. These denominators should be distinguished.
- The 14 historical finished sessions with gaps have not been repaired or relabeled.
  Missing answers cannot be recreated from the saved data; analysis eligibility
  depends on which measures are required.
- Spring imagery (23728) still has the unconditional completion callback. It was
  outside the authorized deployments and remains unchanged, along with legacy
  studies.
- Three deleted legacy endpoints have no live results. Historical analyses need
  their archived exports. The original tomato report additionally requires the
  absent `tomatoes.csv`; its disabled download/preprocessing chunks cannot create it.

## Imagery-measure comparison

The imagery report now reads the Afterimage component (49460) and plots VVIQ
against the second-run relative imagery/afterimage rating, following the existing
methods. Run 1 is practice. The comparison uses the ordinal scores −2 through +2;
the unsure code (3) is missing, not a high imagery score. Only complete pairs enter
the Spearman correlation. Live metadata matched today's audited imagery export:
10 finished sessions have afterimage ratings, six also have complete VVIQs.
The plot does not apply color-memory performance exclusions to these imagery measures.
The validated comparison has Spearman rho = .38, p = .461 (six complete pairs).
The updated imagery report rendered successfully as a standalone HTML document
with embedded resources using R 4.6.1, apastats2 1.0.6 and circhelp 1.4.1. The
figure was visually checked, and its six observations and original ordinal scores
were checked against the saved component data. Small-sample uncertainty remains;
the report describes this correlation as preliminary.

## CI dependency repair

The first run after publishing these report changes stopped before rendering:
the progress plot uses `ragg`, but its dependency was absent from `renv.lock`.
The lockfile now records the installed `ragg` 1.5.2, `systemfonts` 1.3.2 and
`textshaping` 1.0.5, preserving every existing package record and R version.
The workflow installs their Linux system dependencies, retains the strict
`renv::status()` check, and saves restored packages even if a later check fails.

The original tomato report remains unchanged. While its archived `tomatoes.csv`
is unavailable, CI identifies that one report as archived in the job summary
and preserves its existing HTML instead of attempting an analysis without inputs.
Restoring the CSV automatically re-enables rendering. Every other tracked report
is still attempted; a genuine render failure still fails the job after successful
reports have been published.

The repaired CI dependency check and regression tests passed, then a fresh render
exposed a separate temporal-attention reader error: newer comment/feedback
components store JSON objects rather than jsPsych trial arrays. The report now
selects only `FINISHED` sessions and their completed main-task component by its
recorded UUID. Practice, reloaded attempts, comments and feedback are excluded
before parsing task trials. A regression check covers these mixed component types.

Verified on GitHub Actions on 26 October 2026, approximately 15:20 Europe/Paris:
[run 40334938529, attempt 2](https://github.com/achetverikov/PRPSYK305_empirical_projects/actions/runs/40334938529/attempts/2)
passed dependency consistency, regression tests, all nine non-archived report
renders and publishing. The first attempt was retried after unusually slow Ubuntu
package installation. The published temporal CSV contains 900 main trials from
six sessions, 150 each, with no practice rows. The imagery plot and correlation
are present in the published HTML; the original tomato source and HTML remain
unchanged. Source fixes: `08b7cdf` and `d3efc82`; generated reports: `e8d6536`.

## Earlier snapshot

The audit covers all **11 course study IDs** configured in `setenv.R`, including
older sessions. Eight IDs have results on Mindprobe; the three legacy endpoints
have no result records. Across the eight available studies, the snapshots contain
983 sessions, including **438 unfinished sessions**. Of these, 47 have saved
component files, but **none has all required task data**.

Metadata and exported component data were checked against the task components
and saved trial counts. The current-report subset below selects sessions starting
after **2026-10-01 00:00 UTC**, matching `JATOS_START_DATE`.
Exports and generated participant-level outputs remain in a temporary directory
outside this repository. No Mindprobe statuses or analysis inclusion rules for
unfinished sessions were changed.

## Unfinished sessions

Counts are snapshots taken during the audit, rather than a simultaneous server census.
"Unfinished" below includes all statuses other than `FINISHED`, including `FAIL`.

| Study | FINISHED | Unfinished | Unfinished with saved component files | Unfinished with full task data |
|---|---:|---:|---:|---:|
| Autumn imagery, 28788 | 10 | 9 | 4 | 0 |
| Temporal attention, 18331 | 6 | 24 | 2 | 0 |
| Autumn decoy, 28940 | 10 | 10 | 0 | 0 |
| Subset averaging, 23544 | 12 | 14 | 5 | 0 |
| Objects, 18335 | 11 | 5 | 0 | 0 |
| Monsters, 18334 | 12 | 2 | 0 | 0 |
| Spring decoy, 23570 | 0 | 18 | 0 | 0 |

- One unfinished imagery session has a full first main block: 192 saved response
  rows for 96 trials with two reports each. The second main block is absent.
  Other saved unfinished imagery files contain questionnaire, afterimage or
  practice data. None has both required main blocks.
- The two unfinished temporal-attention sessions with saved files have practice
  data, with 15 responses each; neither has the 150-trial main block.
- Saved unfinished tomato files contain only practice or initialization data;
  none has the 288-response main block.
- Other unfinished sessions have no saved task files in these exports.

Before the cutoff, the available unfinished task data are also partial: 24
temporal-attention sessions have only practice files, two tomato sessions have
only practice files, and ten spring-imagery sessions have questionnaire and/or
practice files. One spring-imagery session additionally has its first main block
(288 response rows for 144 trials), but no second main block. No older unfinished
session has a complete task dataset.

The legacy imagery, decoy and tomato endpoints have no result records. Their
configured study IDs remain unchanged; rebuilding historical analyses requires
the archived results.

`FINISHED` is a server completion status, rather than a guarantee of usable data:
one finished monster result contains only browser/fullscreen checks, and four
finished imagery sessions lack all 16 questionnaire responses despite having
the main memory blocks. The report readers exclude the empty monster result;
the imagery reader now records missing questionnaire scores as `NA`, not zero.

## Missing-column fixes

- The original decoy report received an empty export from the deleted study.
  The spring report had no finished task files after the cutoff. Both now render
  an explicit data-availability notice and stop before their analyses, rather
  than indexing absent `id` or `subject_id` columns. Their study IDs are unchanged.
- The imagery reader still used spring questionnaire component IDs. It now reads
  the autumn questionnaire and the two main blocks, excluding afterimage and
  practice files. Unused browser-dimension processing was removed because those
  fields are not recorded in the autumn main blocks. The report includes the
  existing autumn methods description.
- The imagery questionnaire join no longer duplicates result-ID columns. A
  correction assignment that requested six output columns from a two-column
  selection now assigns only the two returned quantities, `be_c` and `is_outlier`.

## Historical statistical failures

Restricting the exported data to sessions completed before the 12 October CI run
reproduced all three failures; no test inputs or participant values were invented.

| Report | Inputs at the failed run | Explanation | Usable sample in the current audit |
|---|---|---|---|
| Monsters | One participant for each of the eight paired RT comparisons | A paired t-test needs at least two finite pairs | 11 participants |
| Objects | Two participants; identical different-state binding accuracy | The one-sample t-test has zero between-participant variance | 11 participants, with varying accuracy |
| Tomatoes 2026 | Two finite accuracy/bias pairs after preprocessing | The Pearson correlation test needs at least three pairs | 10 finite pairs |

All three statistical analyses execute with the current exported data. Their
historical errors were caused by the small or constant samples available then.
The sample sizes and statistical rules were not relaxed to make tests run.

The original tomato report unconditionally reads `tomatoes.csv`, but that file
is absent from both the checkout and tracked files. Its download/preprocessing
chunks, including the chunk that writes this CSV, have `eval: false`, so CI cannot
create the required input. The legacy study is also absent from Mindprobe.
Restoring the historical report requires its archived data; the CSV and study ID
were left unchanged rather than substituting the current tomato study's data.

## Validation

- Existing date-filter and one-participant cleanup tests pass. A new knitting
  regression check verifies that an empty report displays its data-availability
  notice and never reaches the analysis code.
- Six isolated HTML previews were rendered using the downloaded Mindprobe
  exports: imagery, original and spring decoy, monsters, objects and tomatoes
  2026. Both decoy previews contain the expected availability notice and no
  statistical results. The imagery preview explicitly reports its four missing
  questionnaire scores.
- The previews use the installed R 4.6.1 and circhelp 1.4.1. Resource embedding
  was disabled only in the isolated copies because sandbox permissions block
  Quarto's resource bundler; the source reports retain their embedding settings.
- Generated participant-level CSV/RDS files and previews were written outside
  the teaching repository. No generated datasets were staged or published.
