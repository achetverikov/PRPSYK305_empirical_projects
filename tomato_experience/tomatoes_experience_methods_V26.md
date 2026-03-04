## Research questions

**Main theoretical question:** How does the variability of items within a subset affect the estimation of summary statistics?

Why is this important? You've read about ensemble averaging - it's a cool ability of the brain to quickly judge the average, shown in many studies. But in real life, when you want to know the 'average' of something in the environment, the information often comes from different objects, which might have their own variability. For example, if you want to know the average salary of restaurant workers in Norway, the data would come from many cities, each with its own variation. Thus, you need to account for that variability. Similarly, let's say you want to know whether the tomatoes in a supermarket are ripe. You would need to judge their average color, but each tomato will differ not only in how red they are, but also in how uniform its color is. Again, you need to take that into account. The way in which you should account for that is specified by ideal observer models, but we won't go into that here. For this project, we will explore this empirically.

In this task, the aim is to investigate how the variability of items within a subset influences the estimation of summary statistics, such as the average color. Participants are asked to remember and report the average of the colors of two stimuli (tomatoes) presented on the screen.

The empirical questions to address in your analysis include:

1. How does the similarity between colors influence performance?
2. How does the noise level (variability) in color patches affect how participants weight stimuli when computing averages? Is there a bias towards more variable or less variable items?
3. Is there an interaction between similarity and noise that affects performance or bias?

Feel free to explore other questions as well!

## Apparatus, Stimuli, and Procedure
The experiment was conducted using a web-based platform built with jsPsych (version 7.3.2). Stimuli were presented on participants' personal displays with a minimum required resolution of 1000 × 600 pixels, verified via browser-check.

Participants performed a color estimation task framed as quality control at a "magical tomato factory." On each trial, participants first viewed a central fixation circle (radius = 20 pixels) for 500 ms. Subsequently, two 8 × 8 color patch stimuli (64 patches per stimulus) appeared simultaneously on the left and right sides of the screen for 1000 ms. Each stimulus measured 256 × 256 pixels, with individual patches sized at 32 × 32 pixels. Each stimulus contained patches with colors sampled from a normal distribution with a specified mean and standard deviation (either about 9° or 20° in OKLCH color space). All colors were presented at a constant luminance (L = 50%) and chroma (C = 0.1), with only the hue parameter varying according to the experimental conditions. These color patches represented samples from two tomatoes.

The mean hue of the left stimulus was selected randomly to ensure coverage across the full 360° color space. The mean hue of the right stimulus was determined by the similarity bin factor, set at either 20°, 45°, or 135° (±3°) away from the left stimulus mean, with the direction (clockwise or counterclockwise) determined randomly.

After a 500 ms memory delay, a response cue appeared for 500 ms, indicating that participants should report the average color of both tomatoes. A color wheel (radius = 120 pixels, thickness = 20% of radius) then appeared around the corresponding tomato image(s). Participants selected a color by clicking on the wheel, with response time limited to 10 seconds per trial.

In the training phase (10 trials), participants received extended feedback showing both their selected color and the correct average color. Stimulus presentation times gradually decreased during training. In the test phase, only a numerical score indicated performance accuracy without revealing the correct color.

The experiment had a within-subjects factorial design with the following factors: left item color variability (2 levels: 5° or 20° standard deviation), right item color variability (2 levels: 5° or 20°), and similarity between them (3 levels: 20°, 45°, or 135°). The full factorial design with this distribution generated 360 unique experimental conditions, all of which were administered to each participant in the test phase. A mandatory rest period was provided at the midpoint of the experiment (after 50% of trials were completed) to mitigate potential fatigue effects.