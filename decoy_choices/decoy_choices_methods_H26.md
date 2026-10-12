## Research questions

**Main theoretical question:** How does presenting prices and ratings alongside bars change the influence of an additional, inferior offer on choices?

The main questions are:

1. Does adding a decoy change target-choice proportions compared with the two-option control condition?
2. Does this change differ between numeric and perceptual presentation?
3. Does a decoy attached to the target affect choices differently from one attached to the competitor?
4. Do response times differ by presentation, decoy placement, or chosen option?

An increase in choices of the option dominating a decoy is an attraction effect; a decrease is a repulsion effect. Do not assume the effect must be attraction. You can explore additional questions, including decoy type and reduction, using the decoy trials.

# Methods

These methods describe the revised H26 study, version `H26-shopping-240-v1`. Match the methods to the version of the data you analyze; the spring 2026 study used 288 main trials.

## Apparatus and Stimuli

The online experiment used jsPsych 7.3.4 with the psychophysics plugin 3.7.0. Red and blue bars on a dark gray background (#424242) represented the price and quality of TV offers. Fuller bars represented a lower price or a higher quality rating. The assignment of price and quality to horizontal/red and vertical/blue bars was randomly selected for each participant.

Numeric trials displayed prices ($200–$5000) and quality ratings (2–5 stars) alongside the bars. Perceptual trials displayed bars alone. Offers were positioned around the screen center at a radius of 200 pixels. Three-option trials used a triangular arrangement; two-option controls omitted the third offer. Positions and number labels were randomized from trial to trial.

The task draws on the bar-display approach used by Spektor, Kellen, and Klauer (2022), who compared perceptual and preferential choices and examined attraction, repulsion, and information search. The present study uses TV offers and an online keyboard task; it does not collect eye tracking or confidence judgments. See [The repulsion effect in preferential choice and its relation to perceptual choice](https://doi.org/10.1016/j.cognition.2022.105164).

## Design

All participants experienced both presentation formats, both decoy placements, and the two-option control condition. Four binary factors were shared by control and decoy trials:

| Factor | Levels | Meaning |
| --- | --- | --- |
| Presentation (`condition`) | `perceptual`, `numeric` | Bars alone, or bars with prices and ratings |
| Target assignment (`correct_option`) | `NH`, `WL` | Which member of the pair with swapped bar widths/heights was designated the target |
| Adjusted attribute (`set_type`) | `H`, `W` | Which bar of the competitor was reduced |
| Target–competitor difference | 0.03, 0.10 | Reduction of one competitor bar, as a fraction of the full bar scale |

These factors produce 16 combinations. Each combination appeared three times as a two-option control (16 × 3 = **48 control trials**).

Decoy trials additionally crossed three factors:

- **Decoy placement** (`decoy_on`): attached to the target or the competitor. The attached option dominated the decoy: it was at least as good on both attributes and better on at least one.
- **Decoy type** (`decoy_type`): `stronger`, `weaker`, or `both`. The decoy was made worse on the attached option's fuller bar, less full bar, or both bars. Thus, type describes which attribute was reduced; placement describes which option the decoy accompanied.
- **Decoy reduction** (`decoy_reduction`): 0.05 or 0.20 of the full bar scale. The reduction applied to one bar for `stronger`/`weaker`, and was split equally between the two bars for `both`.

There were 16 × 3 types × 2 reductions × 2 placements = **192 decoy trials**, with 96 attached to the target and 96 to the competitor. For each shared combination, there were six decoy trials per placement, compared with three controls. Decoy type and reduction do not apply to control trials and are recorded as missing there.

The main task therefore contained **240 trials**, shuffled for each participant. It comprised **15 rounds of 16 choices**, organized into **three chapters of five rounds**. Practice trials were additional to these counts.

The target was the original offer with the better overall combination of price and quality according to the task's scoring rule. Choosing it counted as a good deal for the task's collection score. This scoring rule describes target selection; a decoy effect is assessed by comparing choice proportions across choice sets.

## Procedure

Participants were asked to stock an imaginary electronics shop by choosing TV offers with a good price–quality combination. Instructions explained the bars, number-key responses, shopping chapters, and breaks, and showed examples with and without numeric labels. They also explained that a completion code would appear on the final feedback screen and should be copied or saved before closing the tab.

Participants first completed five easy practice trials: two perceptual and three numeric. One option was clearly better on both attributes. After each choice, feedback explained the best deal; numeric feedback also listed each option's price and rating. All five responses had to be correct in the same attempt. Any wrong or missing response required repeating all five practice trials. Practice was excluded from the main-task analyses and summaries.

On each main trial, the offers appeared one second after trial onset, when keyboard responses became available. Participants responded with the number above the chosen offer: 1 or 2 for controls, and 1, 2, or 3 for decoy trials. The response window was **15 seconds after the offers appeared**; an unanswered trial then ended without detailed feedback. Recorded response times were measured from the opening of this response window.

After each round, feedback showed a shelf of collected TVs, a five-star delivery rating based on the proportion collected, cumulative collection totals, and rounds remaining. Completed chapters earned star badges. Participants could take a break before continuing; chapter boundaries occurred after every five rounds. Detailed choice explanations were confined to practice.

After the final round dashboard, the main-task data and a nine-character completion code were saved. A failed save displayed a retry option and kept the explanation hidden. The final screen combined the collection total, overall star rating, target-choice proportions, and completion code. The code appeared after JATOS confirmed successful completion, with a copy button; the page stayed open without a further keypress or redirect. An expandable interactive example explained the decoy effect on that same screen. Unanswered trials were listed separately and excluded from choice percentages. The personal summary was descriptive and did not establish an individual decoy effect. Participants could explore the explanation or close the tab after keeping their code. Debrief interactions were excluded from the saved task data.

## Analysis notes

The three choice sets have unequal trial counts (48, 96, 96), so compare target-choice **proportions**, not raw counts. Compute each participant's proportion within each presentation × placement cell before comparing participants. Include participants who made zero choices of a particular option as zero proportions rather than dropping them from that option's summary.

The report's choice and response-time analyses use answered main trials. Report missing-response frequencies separately; they are not slow responses with an observed response time. Analyze decoy type/reduction on decoy trials only: missing values for those factors in controls are intentional. Keep versions separate when their trial numbers, practice, timing, or feedback differ.
