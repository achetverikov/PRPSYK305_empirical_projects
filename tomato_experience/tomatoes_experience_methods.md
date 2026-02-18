
## Research questions

**Main theoretical question:**
How does the variability of items within a subset affect the estimation of summary statistics?

The empirical questions to address in your analysis include:

1. How does task type (single item vs. averaging) affect color memory accuracy?
2. How does the similarity between colors influence performance in both task types?
3. How does the noise level (variability) in color patches affect how participants weight stimuli when computing averages?
4. Is there an interaction between similarity and noise that affects performance or bias?

Feel free to explore other questions as well!

## Apparatus, Stimuli, and Procedure
The experiment was conducted using a web-based platform built with jsPsych (version 7.3.2). Stimuli were presented on participants' personal displays with a minimum required resolution of 1000 × 600 pixels, verified via browser-check.

Participants performed a color estimation task framed as quality control at a "magical tomato factory." On each trial, participants first viewed a central fixation circle (radius = 20 pixels) for 1000 ms. Subsequently, two 8 × 8 color patch stimuli (64 patches per stimulus) appeared simultaneously on the left and right sides of the screen for 1500 ms. Each stimulus measured 256 × 256 pixels, with individual patches sized at 32 × 32 pixels. Each stimulus contained patches with colors sampled from a normal distribution with a specified mean and standard deviation (either 5° or 20° in OKLCH color space). All colors were presented at a constant luminance (L = 50%) and chroma (C = 0.1), with only the hue parameter varying according to the experimental conditions. These color patches represented samples from two tomatoes.

The mean hue of the left stimulus was selected randomly to ensure coverage across the full 360° color space. The mean hue of the right stimulus was determined by the similarity bin factor, with the distractor mean set at either 20°, 45°, or 135° (±3°) away from the target mean, with the direction (clockwise or counterclockwise) determined randomly.

After a 500 ms memory delay, a response cue appeared for 500 ms, indicating which color the participant should report: the left tomato, right tomato, or the average color of both tomatoes. A color wheel (radius = 120 pixels, thickness = 20% of radius) then appeared around the corresponding tomato image(s). Participants selected a color by clicking on the wheel, with response time limited to 10 seconds per trial.

In the training phase (10 trials), participants received extended feedback showing both their selected color and the correct target color. Stimulus presentation times gradually decreased during training. In the test phase, only a numerical score indicated performance accuracy without revealing the correct color.

The experiment had a within-subjects factorial design with the following factors: target position (2 levels: left or right), target standard deviation (2 levels: 5° or 20°), distractor standard deviation (2 levels: 5° or 20°), similarity between target and non-target colors (3 levels: 20°, 45°, or 135°), and task type (2 levels: averaging task or single-item report task). The relative frequency distribution was structured such that participants performed the averaging task (reporting the average color of both stimuli) in 60% of trials and the single-item report task (reporting the color of either the right or left stimulus) in the remaining 40% of trials. For the single-item report task, the target was equally likely to appear on the left or right side. This distribution ensured greater emphasis on the averaging task compared to the single-item report task. The full factorial design with this distribution generated 360 unique experimental conditions, all of which were administered to each participant in the test phase. A mandatory rest period was provided at the midpoint of the experiment (after 50% of trials were completed) to mitigate potential fatigue effects.