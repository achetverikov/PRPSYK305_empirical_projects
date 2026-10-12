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

This section describes the spring 2026 control-trial study. The revised H26 protocol has different trial counts, practice, timing, and feedback.
## Apparatus and Stimuli
The experiment was programmed using jsPsych 7.3.4 (de Leeuw, 2015) with the psychophysics plugin (version 3.7.0). Stimuli consisted of red and blue rectangular bars displayed on a dark gray background (#424242). The bars represented two attributes of consumer products (TVs): price and quality. The fullness of each bar indicated the value of that attribute, with fuller bars representing higher quality or lower price. 

In the "numeric" condition, explicit pricing information (ranging from $200 to $5000) and quality ratings (from 2.0 to 5.0 stars) were displayed alongside the bars. In the "perceptual" condition, only the bars were shown without the numeric values. Products were positioned in a triangular arrangement, equidistant from the center of the screen (200 pixels radius).

## Design
The bar-display task was inspired by Spektor, Kellen, and Klauer (2022), who compared perceptual and preferential choices and examined attraction, repulsion, and information search ([Cognition, 225, 105164](https://doi.org/10.1016/j.cognition.2022.105164)). It employed a fully factorial within-subjects design with the following factors:

- Condition (perceptual, numeric): whether explicit numeric values were shown
- Correct option (NH, WL): narrow & high vs. wide & low option as the target
- Set type (H, W): which parameter of the competitor option was adjusted (height or width)
- Decoy type (stronger, weaker, both): whether the fuller bar, less full bar, or both bars of the attached option were reduced
- Target-to-competitor difference (0.03, 0.1): how much worse the competitor was relative to the target
- Decoy reduction (0.05, 0.2): how much worse the decoy was
- Decoy placement (target, competitor, no decoy): which option dominated the decoy, or a two-option control

The spring 2026 study contained 288 main trials: 192 decoy trials (96 per placement) and 96 two-option controls, arranged in 18 blocks of 16 trials. For each of the 16 shared factor combinations, there were six controls and six trials per decoy placement. Decoy type and reduction do not describe control stimuli; their recorded values on controls reflect repetitions of the shared design.

Which attribute (price or quality) was represented by which color (red or blue) was counterbalanced across participants, with assignment determined randomly at the beginning of the experiment.

## Procedure
The experiment began with an instruction screen explaining the task and showing example stimuli. Participants were instructed to select the best option in terms of both price and quality, with fuller bars indicating better values (higher quality and lower price).

On each trial, two or three options appeared one second after trial onset. Participants responded with the corresponding number key (1 or 2 for controls; 1, 2, or 3 for decoy trials). The implemented trial limit was 20 seconds from trial onset, approximately 19 seconds after the options appeared, although the instruction screen stated 15 seconds. An unanswered trial ended without detailed feedback. There was no separate practice phase in this version.

The experiment was divided into blocks of 16 trials, with short breaks between blocks. During these breaks, participants received feedback on their performance, visualized as TVs they had "taken home" (correct choices) versus "missed" (incorrect choices). After completing all trials, a final performance summary was displayed before concluding the experiment.