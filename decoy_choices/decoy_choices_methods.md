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
- Decoy placement (target, competitor): whether the decoy was asymmetrically dominated by the target or the competitor

This resulted in a total of 192 unique trial types (2×2×2×3×2×2×2), with each participant experiencing all conditions exactly once. The experiment consisted of 192 trials divided into 12 blocks of 16 trials each.

Which attribute (price or quality) was represented by which color (red or blue) was counterbalanced across participants, with assignment determined randomly at the beginning of the experiment.

## Procedure
The experiment began with an instruction screen explaining the task and showing example stimuli. Participants were instructed to select the best option in terms of both price and quality, with fuller bars indicating better values (higher quality and lower price).

On each trial, three options were presented simultaneously. Participants indicated their choice by pressing the corresponding number key (1, 2, or 3). They had a maximum of 20 seconds to respond. If no response was recorded within the time limit, a "Too late!" message appeared encouraging faster responses.

The experiment was divided into blocks of 16 trials, with short breaks between blocks. During these breaks, participants received feedback on their performance, visualized as TVs they had "taken home" (correct choices) versus "missed" (incorrect choices). After completing all trials, a final performance summary was displayed before concluding the experiment.