# Teaching study data audit, 4 November 2026

The final snapshot contains **715 server-marked FINISHED sessions across eight available studies**.
**701 have the required component data; 14 have a structural gap.** The same 14 cases were
documented on 26 October; the newest gap began on 23 October. No newer missing-data case was found.
These are session counts, not distinct people across studies or final analysis sample sizes.

The current cohort starts strictly after **1 October 2026, 00:00 UTC**. It contains **231 finished
sessions, five with gaps**: four autumn-imagery sessions and one Monsters session. Data collection
continued during this work. Final report builds use the saved audit ZIPs rather than fetching
different snapshots independently. The aggregate counts and export checksums are in
`study_data_audit_20261104.json`; the audit completed at 09:34 UTC / 10:34 Europe/Oslo.

| Study | All finished | All with gaps | Current finished | Current with gaps |
|---|---:|---:|---:|---:|
| Autumn imagery | 40 | 4 | 40 | 4 |
| Spring imagery | 39 | 1 | 0 | 0 |
| Temporal attention | 137 | 0 | 33 | 0 |
| Autumn decoy | 38 | 0 | 38 | 0 |
| Spring decoy | 40 | 0 | 0 | 0 |
| Tomatoes | 78 | 1 | 39 | 0 |
| Objects | 165 | 3 | 42 | 0 |
| Monsters | 178 | 5 | 39 | 1 |

Three deleted legacy study endpoints still have no live result records. They cannot be audited
without their archived exports. The original tomato report additionally needs its historical
`tomatoes.csv`; the 2026 tomato data are not a substitute.

## Missing parts and whether the cause is closed

| Missing-data cases | Evidence and cause | Current live code |
|---|---|---|
| Four autumn-imagery sessions | Questionnaire and practice contain browser exclusions rather than responses. Both memory blocks and both afterimage runs are present. | **Completion-flow repair present.** `component_completion.js` checks the normal-end marker and questionnaire/practice/main completeness, then awaits saving before advancement. |
| One spring-imagery session | Questionnaire and practice are missing; both memory blocks are complete. | **Still open.** The live `on_finish` still submits whatever rows exist and advances without checking normal completion. |
| One older tomato session | Browser-check-only practice; all 288 main responses are present. | **Guard present.** The live code checks the normal-end marker and response count, awaits practice saving and requires completed practice before the main task. |
| Five Monsters sessions | Browser-check-only records, with no main task. One belongs to the current cohort. | **Completion-flow repair present.** Planned block/position keys and normal completion must pass before saving and advancement. |
| One older Objects session | Browser-check-only record, with no learning or test data. | **Completion-flow repair present.** Normal completion, learning-item records and both responses in every test are checked. |
| Two early Objects sessions | 200 learning events and 100 tests exist, but learning-item identity/state fields are absent. | **Historical schema limitation.** The current code records and validates these fields. Old item-specific retention lags cannot be recovered from the saved events. |

All 12 browser-exclusion cases recorded a window below the required 1000 × 600 pixels.
They match the previously diagnosed failure: a browser exclusion invokes jsPsych's experiment
`on_finish`; the old unconditional save-and-advance callback treated that as completed work.
The dated deployment evidence is preserved in `study_data_audit_20261026.md`. Fresh authenticated
GETs of the live assets confirm that the autumn-imagery, Monsters and Objects guards remain
deployed. The local experiment checkout predates those repair commits, so the old local checkout
was not used as evidence that a repair is live.

Historical missing answers remain missing. No server completion status, participant record or
experimental asset was changed during this audit.

## Values needing review

**Monsters has an open timing-handler issue separate from the repaired completion flow.**
One current-cohort main trial records RT **−133.6 ms**. Two older trials record **7.84 s and
10.693 s**, beyond the nominal five-second response window. The live handler subtracts
`trial_start_time` from `event.timeStamp`, accepts stale events, and does not enforce the deadline
inside the click handler. An isolated Node execution of that exact live handler accepted a stale
synthetic event with RT −133.6 ms and a late synthetic event with RT 6 s. This demonstrates that
the handler still permits both outcomes; it does not establish which browser event sequence
produced the historical records. Negative RT is invalid for latency analysis, while its recorded
choice can still contribute to accuracy. This audit does not silently introduce a new RT exclusion.

**Very short nonnegative RTs are performance flags, not proof of missing or corrupt data.**
Current-cohort main-task counts below 100 ms are:

| Study | Flagged timings | Sessions |
|---|---:|---:|
| Autumn imagery | 80 | 3 |
| Temporal attention | 29 | 8 |
| Autumn decoy, both protocols | 285 | 8 |
| Tomatoes | 130 | 2 |
| Monsters, positive RTs only | 2 | 2 |
| Objects, individual click timings | 1 | 1 |

For revised autumn decoy, 233 flags occur in seven sessions; one session has 136 of 240 trials
below 100 ms. The remaining 52 flags come from its older 288-trial protocol, which the revised
report already excludes by version. One tomato session accounts for 129 rapid main responses.
That tomato session already fails the existing circular-SD rule (153.8° versus the 60° cutoff);
the other session has a single rapid response and remains eligible. These patterns merit
sensitivity checks; no participant was newly excluded on this basis.
The decoy keyboard listener starts at the response window and explicitly disallows held keys;
short values alone do not identify a held-key bug or an RT-unit conversion error.

In older Monsters data, **636 saved timeout trials in 15 sessions lack an explicit correctness
value**. Their task rows and block positions are present. The current live `on_finish` explicitly
saves timeout correctness as zero and RT as null, and no such case occurs in the current cohort.
Historical accuracy analyses should account for these timeouts rather than silently omit them.

The checks found no other out-of-range angular errors or questionnaire/afterimage codes, no
inconsistent response-to-score mappings, and no unexpected main-task factorial cells among the
available finished task datasets. Null RTs on saved timeout rows, negative circular color
representations modulo 360, and the afterimage unsure code are handled according to their
recorded meaning rather than classified as lost task trials.

## Design and report mismatches corrected

- **Tomatoes methods:** the deployed factorial and data contain **288 main trials**, not 360.
  Pixel correlations 0 and 0.8 with marginal SD 20° yield approximate within-patch SDs 20° and 9°;
  the old factor paragraph incorrectly called the lower level 5°. The methods now match the
  code and saved factor combinations.
- **Tomatoes reader and counts:** it now requires a FINISHED session and finished main component,
  excluding practice before response-count filtering. The report previously overwrote the
  recruitment denominator with post-exclusion summaries; it now reports **39 finished, four
  excluded, 35 analyzed**. The existing performance cutoffs were preserved.
- **Imagery matching and exclusions:** one shared pseudonym map now covers questionnaires,
  afterimage measures and memory trials. Finished component attempts are selected explicitly.
  Missing questionnaires remain missing rather than zero. The participant description now names
  the actual circular-SD/report-count exclusion rule instead of calling it an MAE threshold.
- **Temporal attention model:** post-cue position is now a three-level categorical factor,
  matching the intended design. Previously it entered as a numeric trend. With 33 sessions, the
  corrected model gives post-cue **F(2,64) = 3.45, p = .044** and interaction
  **F(4,128) = 9.41, p < .001**. All nine pre/post cells are present for every current participant.
- **Objects plot:** response proportions now sum to one within each same/different-state
  condition. Previously the denominator pooled the two conditions, halving the displayed
  conditional proportions. The underlying participant records were unchanged.
- **Decoy versions:** 38 current finished sessions comprise 37 revised 240-trial sessions and one
  earlier 288-trial session. Their different counts are intentional; the revised report retains
  only its matching protocol.

## Imagery Figure 3

As clarified by the user, the new matrix belongs to **colors and imagery**, not tomatoes.
Figure 3 contains VVIQ, the second-run imagery/afterimage comparison, and bias-corrected memory
MAE. Every off-diagonal panel has a scatterplot, OLS line and 95% confidence band. Diagonal
panels show the distributions. The standalone export is
`colors_and_imagery/imagery_correlation_matrix.png`.

The table retains all 40 finished imagery sessions: 36 have VVIQ scores, 39 have a non-unsure
afterimage rating, and 36 pass the existing memory criteria. Pairwise availability is used;
memory exclusions do not remove valid imagery-only observations. The ordinal afterimage
correlations use Spearman's rho; VVIQ–MAE uses Pearson's r. OLS bands are descriptive,
particularly for the ordinal rating. P-values are exploratory and unadjusted.

| Pair | N | Correlation | p |
|---|---:|---:|---:|
| VVIQ–imagery/afterimage | 35 | rho = .440 | .008 |
| VVIQ–memory MAE | 33 | r = .259 | .145 |
| Imagery/afterimage–memory MAE | 35 | rho = −.058 | .742 |

The questionnaire uses raw 0–4 item codes, summed to 0–64. The deployed participant feedback
adds one per item and displays 16–80. This constant 16-point offset does not affect correlations;
the report and data dictionary explicitly use 0–64.

## Reproduction and validation

`scripts/audit_study_data.py` reads saved ZIPs without changing them. It checks required
components and saved attempts, questionnaire item counts, both afterimage runs, complete
practice cycles, main trial keys and factorial counts, Objects learning/test linkage, Monsters
planned positions, score mappings, angle consistency and RT validity. A saved timeout counts
as a task row; omitted nonessential score/feedback-display rows do not count as missing responses.

Public aggregates and export SHA-256 hashes are in `study_data_audit_20261104.json`. Raw ZIPs,
live-source snapshots and the per-session issue ledger remain outside the repository in
`/tmp/prpsyk305-audit-20261104/final/`; the ledger is `audit_issues_PRIVATE.json`. Initial exports
are retained in the parent directory. No participant identifiers or raw comments are included
in this report or the public aggregate JSON.

For an exact report rebuild, set `JATOS_RESULTS_FILE` to the corresponding private result ZIP;
the shared reader checks its study UUID. Without that variable, reports download fresh data.
The updated imagery metrics/correlation CSVs use the same pseudonyms as its trial CSV.

R regression checks cover identity joins, missing scores, unsure ratings, memory MAE, pairwise
sample sizes, finished/main-component selection, categorical positions and conditional
normalization. Python tests cover recorded-cue reconstruction, complete saved timeouts and
valid unsure responses. All five affected reports rendered from the audited snapshots, and
the matrix was visually inspected. The new tests are included in the report CI workflow.

Local execution used R 4.6.1, GGally 2.4.0, ggplot2 4.0.3, apastats2 1.0.6, circhelp 1.4.0,
rmarkdown 2.31 and knitr 1.51. Existing lockfile records were preserved; seven missing GGally
dependency records were added. CI has been configured but was not dispatched or published.
