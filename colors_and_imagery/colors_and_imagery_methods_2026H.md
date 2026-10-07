## Research questions

**Main theoretical question:** How do stimulus noise and individual imagery ability jointly shape color memory performance?

Why is this important? Visual memory is often studied as if everyone uses the same strategy, but some studies suggest that individual differences in imagery ability can significantly impact how people approach the task. Imagine that you want to describe a color of a dress to a friend. Some people might have a very vivid mental image of the dress, while others will rely more on semantic descriptions. Understanding these differences helps connect memory mechanisms to measurable variation in experiment outcomes.

The study investigates the relationship between visual imagery ability (measured by VVIQ and an adaptation test) and color memory performance. In particular, it examines how noise in the stimulus affects memory accuracy and whether this is moderated by individual differences in imagery ability.

The empirical questions to address in your analysis include:

1.  How does noise level in the target and distractor stimuli affect color memory accuracy?
2.  How are VVIQ and adaptation-based measures of imagery related to each other?
3.  Does imagery ability predict overall color memory performance?
4.  Does imagery ability predict how strongly performance is affected by noise?
5.  Does imagery ability predict how much performance degrades when reporting the second item compared to the first?

Feel free to explore other questions as well!

# Methods

## Procedure

Participants first completed a browser check to ensure their screen met the minimum requirements (1000 × 600 pixels) and were instructed to switch to fullscreen mode. They then received general instructions explaining the purpose of the study and were informed that they would complete a questionnaire and an imagery task followed by a memory task. Participants completed the Visual Vividness Imagery Questionnaire and the adaptation (afterimage) task, after which they received detailed instructions for the color memory task. They then completed training on the color memory task followed by two experimental blocks with a short break halfway through each block.

## Materials

The experiment was implemented using jsPsych 7.3.4, a JavaScript library for conducting behavioral experiments in a web browser.

### Visual Vividness Imagery Questionnaire (VVIQ)

Participants completed a shortened version of the Visual Vividness Imagery Questionnaire (Marks, 1973), which assessed their self-reported ability to form mental images. The VVIQ included four scenarios (out of the original eight): visualizing a relative or friend, a sunrise, a shop front, and a countryside scene, presented in random order. For each scenario, participants were presented with a screen containing all four specific visual details to rate simultaneously. Participants rated the vividness of each detail on a 5-point scale, from “No image at all, you only ‘know’ that you are thinking of the object” (rating = 0) to “Perfectly clear and as vivid as real seeing” (rating = 4). Higher scores indicated more vivid visual imagery.

### Adaptation task

After the VVIQ, participants completed an afterimage–imagery comparison task adapted from Price et al. (2026). A high-contrast black-and-white image of a face with a red fixation dot in the centre was presented full screen on a white background for 30 s. Participants were instructed to keep their gaze on the red dot, to close their eyes as soon as the image disappeared, and to attend to any afterimage until it had completely faded, after which they clicked a button (the time until this click was recorded as the afterimage duration). Participants then reported whether they had experienced an afterimage that was recognisable as a face ("Yes", "No", or "Unsure"). Next, they were asked to generate a visual image of the face of somebody they knew well, with eyes open or closed, for as long as needed to make it as strong and clear as possible (the time spent on this screen was recorded as the imagery duration). Participants then compared their self-generated image with the afterimage, each at its strongest, in terms of overall strength, detail and visual quality, and chose one of five statements. These ranged from the self-generated image being "much stronger, detailed and visual" than the afterimage (relative rating = +2) through "quite similar" (0) to "much weaker, less detailed and visual" (−2). A sixth option allowed them to indicate that they were unsure or found the question impossible to answer; these responses were excluded from analyses. Finally, participants rated how accurate they felt their comparison was ("Very accurate" = 4 to "Very inaccurate" = 1, or "Unsure"). The whole procedure was completed twice. The first run served as practice, and the relative rating from the second run was the main dependent variable, with higher values indicating that self-generated imagery was more vivid relative to the afterimage.

### Color Memory Task

Participants performed a color memory task that required them to remember the colors of two simultaneously presented colored patches.

#### Stimuli

Each colored patch consisted of an 8 × 8 grid of colored squares (64 squares total). Colors were represented in the OKLCH color space, with hue values ranging from 0° to 360°. The colors of individual squares within each patch were drawn from a normal distribution with a mean corresponding to the target color and a standard deviation that could be either 5° or 20° in hue angle. Target colors were selected from four color bins spaced evenly around the 360° color wheel (i.e., at 90° intervals), with random jitter covering the entire bin to ensure the whole color space was sampled. The similarity between the two patches’ mean colors was manipulated across three levels (20°, 45°, or 135° separation in hue angle). The patches were presented to the left and right of a central fixation point.

#### Trial Procedure

Each trial began with a central fixation circle (2000 ms). The circle briefly disappeared for 100 ms (from 300 to 200 ms before the colored patches appeared) and then reappeared. This was followed by the simultaneous presentation of two colored patches for a variable duration (1500 ms in the main blocks). After a brief memory delay (500 ms), a white circle (cue) appeared either to the left or right of fixation (500 ms), indicating which color patch the participant needed to report. Participants then saw a color wheel and were asked to select the color that best matched the average color of the cued patch by clicking on the appropriate position on the wheel. The color wheel had a random offset on each trial to prevent position-based response strategies. Participants had 5 seconds to respond. If they failed to respond within this time window, they received a “Too late! Try to respond faster next time” message for 2500 ms. After reporting the first color, participants were cued to report the color of the second patch following the same procedure.

#### Design

The experiment employed a 4 (color bin) × 2 (target position: left, right) × 2 (target standard deviation: 5°, 20°) × 2 (distractor standard deviation: 5°, 20°) × 3 (similarity bin: 20°, 45°, 135°) within-subjects factorial design. Each of the two experimental blocks contained all 96 combinations once, giving 192 trials in total, each with two color reports (one per patch).

#### Training

Before starting the main experimental trials, participants completed 10 training trials (after which they could choose to complete another 10 training trials or continue to the main task) where stimulus presentation times were initially longer (4000 ms for the colored patches and 1000 ms for the cue) and gradually decreased to match the timing used in the main experiment (1500 ms and 500 ms, respectively). During training, participants received detailed feedback showing both their response and the correct answer after each trial.

Participants’ performance was scored based on the angular deviation between their response and the target color, with higher scores awarded for more accurate responses.
