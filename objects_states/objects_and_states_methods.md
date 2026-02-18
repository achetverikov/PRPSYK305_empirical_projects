## Research questions

**Main theoretical question:** Are object identity and its state stored independently in visual long-term memory?

Everyday recognition depends on remembering not just what an object is, but also what state it is in. For example, when cooking you need to keep track of which burner has which pot (identity) and the flame setting on each burner (state). If identity and state were stored independently, then recalling one without the other should produce characteristic, systematic errors—such as correctly remembering the pots but mixing up which flame setting belonged to which burner.

The key questions to address in your analysis include:

1. Is there evidence that object state and exemplar information are stored independently in visual memory?
2. How well can participants remember which states go with which exemplars?
3. Is there a difference in memory performance when objects are presented in the same state versus different states?
4. What does the pattern of errors tell us about how visual information is stored in long-term memory?

Feel free to explore other questions as well!

# Methods

The experiment followed the design of Utochkin & Brady (2020, Exp. 1, Exemplar-state task).

## Apparatus and Stimuli

The experiment was programmed using jsPsych 7.3.4 with the psychophysics plugin (version 3.7.0). Stimuli consisted of 200 photographic images of everyday objects from 100 distinct object categories (e.g., bottles, chairs, food items, household objects, tools), taken from Brady et al. (2013). These stimuli were specifically designed to examine memory for object details, with each category containing two exemplars (different objects from the same category) and each exemplar appearing in two states (e.g., different orientations, configurations, or poses).

Images were presented on a white background. During learning, images (250 x 250 pixels) were displayed centrally. During testing, images were arranged in a 2 × 2 grid, with horizontal positions at ±150 pixels from center and vertical positions at 50 ± 150 pixels from center.

## Design
The experiment employed a within-subjects design with a learning phase followed by a testing phase. During the learning phase, participants viewed 200 images (one state of each exemplar from all 100 categories). For half of the categories, both exemplars were shown in the same state; for the other half, exemplars were shown in different states.

The testing phase consisted of 100 trials, one for each object category. Each trial presented four images arranged in two rows. In each row, one image was identical to one shown during learning (target), while the other was a novel state of either the same or different exemplar (distractor). The positions of targets and distractors were fully counterbalanced and randomized across trials.

## Procedure

The experiment began with general instructions explaining that participants would first learn images and later identify them among similar alternatives. A browser check ensured minimum screen requirements were met, and participants were instructed to switch to fullscreen mode.

During the learning phase, participants viewed 200 images sequentially, each presented for 2000 ms. Participants were instructed to memorize the visual appearance of each image. The entire learning phase took approximately 7 minutes to complete.

After completing the learning phase, participants received instructions for the testing phase. On each test trial, participants were presented with four images arranged in a 2 × 2 grid, with the instruction to "Click on one image in each row that was presented during the learning phase." Participants needed to select one image from each row by clicking directly on it. Selected images were highlighted with a gold-colored frame. The trial ended automatically once the participant had selected one image from each row.

Performance was scored based on the number of correct selections (0, 1, or 2 per trial). At the conclusion of the experiment, participants received feedback on their overall performance, shown as the percentage of correctly recognized images.


