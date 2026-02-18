## Research questions

**Main theoretical question:** How effectively can attention be allocated and reallocated in time?

Why is this important? Real-world perception often requires selecting brief events at the right moment, not just at the right location. For example, in sports, people must often start doing something at specific moments (like ready - set - go!), requiring them to anticipate the right timing. But what happens before and after the moment you attend to? Temporal cueing effects reveal how much performance drops when attention must be reoriented quickly.

The key questions to address in your analysis include:

1. Does knowing when to attend help? How does cue validity (valid, invalid, neutral) affect orientation judgment accuracy?
2. Can people efficiently reorient their attention? Is there an interaction between the initial cue position and the post-cue position? Perhaps only post-cue matters?
3. Does attention have a refractory period? When attention must be shifted (invalid trials), is there an asymmetry in performance costs between forward shifts (attending to a later item than initially cued) versus backward shifts (attending to an earlier item)?

Feel free to explore other questions as well!

# Methods

### Apparatus and Stimuli
The experiment was programmed using jsPsych 7.3.4 (de Leeuw, 2015) with the psychophysics plugin (version 3.7.0). Stimuli consisted of Gabor patches (sinusoidal gratings with a Gaussian envelope) presented sequentially at the same location. Each Gabor patch had a spatial frequency of 0.05 cycles per pixel, a phase of 90°, a width of 300 pixels, and a contrast parameter of 10. The orientation of each Gabor patch was randomly determined for each trial, ranging from -90° to 90°.

Auditory cues consisted of four sound files: three pure tones at different frequencies (330 Hz, 784 Hz, and 1318 Hz) and one mixed tone combining all three frequencies. Visual displays were presented on a gray background.

### Design
The experiment employed a within-subjects design with the following factors:

- Target position (1, 2, 3): which of the three sequentially presented Gabor patches was the target
- Cue type (neutral, valid, invalid): whether the initial cue validly or invalidly indicated the to-be-remembered target, or provided no specific information

The experiment used a factorial design with 10 repetitions of each condition, resulting in a total of 150 trials (3 target positions × 5 cue conditions × 10 repetitions). The cue conditions were weighted such that valid cues occurred three times more frequently than invalid or neutral cues.

### Procedure
The experiment began with an instruction screen explaining the task, followed by a browser check to ensure minimum screen requirements were met.

Prior to the main experiment, participants completed 15 training trials with gradually decreasing stimulus durations to familiarize themselves with the task.

Each trial began with a fixation cross presented at the center of the screen. After 250 ms, participants heard an auditory cue and simultaneously saw a visual text cue ("1", "2", "3", or "all") indicating which of the upcoming visual patterns would be most important (a 'pre-cue'). The high-pitched tone indicated the first pattern, the mid-pitched tone indicated the second pattern, and the low-pitched tone indicated the third pattern. A mixed tone indicated that all patterns were equally important.

Following the cue, three Gabor patches were presented sequentially at the same location, with each patch displayed for 50 ms (during training, this duration started at 400 ms and gradually decreased) and separated by a 250 ms inter-stimulus interval. After all three patterns were presented and a delay of 500 ms, participants heard a second auditory cue (and saw the corresponding visual cue) that indicated which pattern's orientation they needed to report (a 'post-cue').

Participants then used the mouse to adjust the orientation of a response line to match the orientation of the cued Gabor patch. After submitting their response by clicking, participants received feedback in the form of a score based on their accuracy. The score calculation rewarded precise orientation matching, with higher scores for smaller errors and penalties for large errors.

The experiment was divided into two blocks: a training block with 15 trials and a main block with 150 trials. Participants could take breaks between blocks and were provided with feedback about their overall performance.

