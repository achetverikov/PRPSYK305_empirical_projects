## Research questions

**Main theoretical question:** How does the way information is presented moderate the influence of a decoy on choices?

Why is this important? Many decisions involve multi-attribute options, and context can shift choices even when preferences seem stable. A real-life experimental example is pricing-page A/B testing, where adding a strategically worse subscription plan can increase selection of a target plan. Studying decoy effects helps explain and quantify this kind of choice-architecture influence.

The key questions to address in your analysis include:

1. Does the presence of a decoy option influence participants' choices between target and competitor items?
2. How does the presentation format (numeric vs. perceptual) affect the strength of the decoy effect?
3. Is there a difference in the decoy effect when the decoy is related to the target versus when it's related to the competitor?
4. Do response times differ based on which item is chosen and/or decoy placement?

Feel free to explore other questions as well!

# Methods
## Apparatus and Stimuli
The experiment was programmed using jsPsych 7.3.4 (de Leeuw, 2015) with the psychophysics plugin (version 3.7.0). Stimuli consisted of red and blue rectangular bars displayed on a dark gray background (#424242). The bars represented two attributes of consumer products (TVs): price and quality. The fullness of each bar indicated the value of that attribute, with fuller bars representing higher quality or lower price. 

In the "numeric" condition, explicit pricing information (ranging from $200 to $5000) and quality ratings (from 2.0 to 5.0 stars) were displayed alongside the bars. In the "perceptual" condition, only the bars were shown without the numeric values. Products were positioned in a triangular arrangement, equidistant from the center of the screen (200 pixels radius).

## Design
The experiment closely followed the design of Spektor et al. (2022, Cognition), who investigated the role of metacognition in the decoy effect. It employed a fully factorial within-subjects design with the following factors:

- Condition (perceptual, numeric): whether explicit numeric values were shown
- Correct option (NH, WL): narrow & high vs. wide & low option as the target
- Set type (H, W): which parameter of the competitor option was adjusted (height or width)
- Decoy type (stronger, weaker, both): on which dimension the decoy was reduced compared to the target
- Target-to-competitor difference (0.03, 0.1): how much worse the competitor was relative to the target
- Decoy reduction (0.05, 0.2): how much worse the decoy was
- Decoy placement (target, competitor, no decoy): whether the decoy was present, and whether it was asymmetrically dominated by the target or the competitor 

This resulted in a total of 288 unique trials (2×2×2×3×2×2×3), with each participant experiencing all conditions exactly once. The main part of the experiment consisted of 288 trials divided into 18 blocks of 16 trials each.

Which attribute (price or quality) was represented by which color (red or blue) was counterbalanced across participants, with assignment determined randomly at the beginning of the experiment.

## Procedure
The experiment began with an instruction screen explaining the task and showing example stimuli. Participants were instructed to select the best option in terms of both price and quality, with fuller bars indicating better values (higher quality and lower price).

Before the main part, participants completed five easy practice trials (two without numeric values, three with them) in which one option had both the lowest price and the highest quality. After each practice trial, feedback explained which option was the best deal; in trials with numeric values, it also listed the price and rating of every option. Participants had to answer all five practice trials correctly in the same round; otherwise, the practice was repeated. Practice trials are not included in the analyses.

On each trial, three (or two in case of no decoy) options were presented simultaneously, 1 second after the trial started. Participants indicated their choice by pressing the corresponding number key on a keyboard (1, 2, or 3; or 1, 2 in case of no decoy). They had a maximum of 15 seconds after the options appeared to respond; trials without a response ended without feedback.

The experiment was divided into blocks of 16 trials, with short breaks between blocks. During these breaks, participants received feedback on their performance, visualized as TVs they had "taken home" (correct choices) versus "missed" (incorrect choices). After completing all trials, a final performance summary was displayed before concluding the experiment.