## Research questions

**Main theoretical question:** Do automatic predictions in vision depend on conscious expectations?

Why is this important? Our visual system, like the other systems in the brain, continuously learns what visual features are important here and now, helping us to react quickly. If you forage for blueberries, for example, your vision will quickly focus on blue-black colors, helping you to separate the berries from the leaves. But is this process purely automatic, or do our conscious expectations play a role as well? Researchers seem to disagree on this point, and here you will test it empirically.

The empirical questions to address in your analysis include:

1. How does response time change as participants progress through a sequence of trials?
2. Is there evidence of a priming-of-popout effect, with faster responses after the first trial in a sequence?
3. How does performance change when sequences continue beyond their expected end point?
4. Do expectation violations in one sequence affect performance in the next sequence?

Feel free to explore other questions as well!

## Apparatus and Stimuli
The experiment was programmed using jsPsych 7.3.4 with the psychophysics plugin (version 3.7.0). Stimuli consisted of colored monster-shaped figures displayed on a gray background within an 800 × 800 pixel canvas. Each monster was drawn using SVG path data with an initial width of 96 pixels and height of 88 pixels, and filled with a color represented in the OKLCH color space, with hue values ranging from 0° to 360° while maintaining constant luminance (50%) and chroma (0.1). The monsters were positioned randomly within a 600 × 400 pixel area centered on the screen (from -300 to +300 horizontally and -200 to +200 vertically), with a minimum distance of 120 pixels between them to ensure visibility.

Each trial displayed 12 monster figures simultaneously, with one monster (the "leader") having a distinct color from the rest of the group. The leader's color was randomly selected from the full 360° color wheel, while the other monsters' colors were selected from a region 145° to 235° away from the leader color on the color wheel, with random jitter within this range. For each new sequence, the target and distractor colors were determined randomly.

## Design
The experiment employed a within-subjects design examining how participants develop expectations about sequence lengths. The key manipulating factors were:
- Expected sequence length (4 levels: 5, 6, or 7 trials per wave)
- Length difference (9 levels: -4, -3, -2, -1, 0, 1, 2, 3, or 4 trials from expected)

The length difference factor determined how the actual sequence length deviated from the expected length. For example, if the expected length was 6 trials and the length difference was -2, the actual sequence contained only 4 trials. Each combination of expected length and non-zero length difference (e.g., 5 trials with +2 difference) was repeated 2 times throughout the experiment. In contrast, combinations with zero length difference (e.g., 5 trials with 0 difference) were repeated 16 times. This created a probability distribution where participants were much more likely to experience sequences that matched their expectations, with occasional unexpected deviations.

As a result of these manipulations, the actual length of sequences varied from 1 to 11 trials (when expected length was 11 and length difference was +4). The full factorial design with the biased distribution of length differences resulted in a total of 576 trials per participant.

## Procedure
The experiment began with an instruction screen explaining the task, followed by a browser check to ensure minimum screen requirements were met. Participants were instructed that monsters from outer space were attacking in waves, each with a leader distinguished by its unique color. Their task was to eliminate the leader as quickly as possible by clicking on it with their mouse.

Each trial began with a 500 ms message indicating how many groups remained before a new wave would begin. Then, a set of monsters appeared on the screen, with one monster (the leader) having a distinct color from the others. Participants had exactly 5000 ms to identify and click on the leader. The monsters began increasing in size immediately from the start of each trial, following a specified scaling function (reaching 1.25× their original size at 80% of the trial duration, and 2× by the end), encouraging participants to respond within the time limits. If participants failed to click on the correct monster, they received a feedback message stating "Oh no! You missed the leader" for 2500 ms.

The experiment was divided into blocks, with breaks provided after every 16 sequences. During breaks, participants received feedback on their performance, including accuracy (number of correctly identified leaders) and average response time. Based on performance metrics, participants earned bronze stars (for basic completion), silver stars (for >80% accuracy and <1.8 seconds average response time), or gold stars (for >90% accuracy and <1.1 seconds average response time), which were displayed as a cumulative record throughout the experiment.

At the end of the experiment, participants received a summary of their overall performance before submitting their data and completing the study.
