import importlib.util
import itertools
import unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location('audit', Path(__file__).resolve().parents[1] / 'scripts/audit_study_data.py')
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class StudyAuditTests(unittest.TestCase):
    def test_imagery_uses_recorded_cues_and_target_coordinates(self):
        rows = []
        for number, cell in enumerate(itertools.product([45, 135, 225, 315], [-300, 300], [5, 20], [5, 20], [20, 45, 135]), 1):
            rows.append(dict(zip(('color_bin', 'target_x', 'target_sd', 'distr_sd', 'similarity_bin'), cell),
                             trial_type='psychophysics', seq_type='stimuli'))
            for cue in (1, 2):
                rows.append(dict(trial_type='psychophysics', seq_type='cue', cue_n=cue, cued_color=90))
                rows.append(dict(trial_type='psychophysics', seq_type='response', trial_number=number,
                                 resp_color=100, error=10, rt=500))
        gaps, issues, _ = audit.validate_component('imagery_192', rows)
        self.assertFalse(gaps)
        self.assertFalse(issues)
        gaps, _, _ = audit.validate_component('imagery_192', rows[:-1])
        self.assertIn('memory_responses_missing', gaps)

    def test_timeout_is_saved_trial_not_missing_data(self):
        rows = []
        block = 0
        for length in (5, 6, 7):
            for difference in range(-4, 5):
                for _ in range(32 if difference == 0 else 2):
                    block += 1
                    rows.extend(dict(trial_type='psychophysics', seq_type='search', block_i=block,
                                     trial_i_within_block=position, expected_length=length,
                                     lengthDiff=difference, real_length=length + difference,
                                     correct=0, clicked_monster_id=None, rt=None)
                                for position in range(1, length + difference + 1))
        gaps, issues, _ = audit.validate_component('monsters', rows)
        self.assertFalse(gaps)
        self.assertEqual(issues, {'no_correct_monsters_responses_review': 1})
        rows[0]['rt'] = -10
        _, issues, _ = audit.validate_component('monsters', rows)
        self.assertEqual(issues['reaction_time_invalid'], 1)

    def test_afterimage_unsure_is_valid_recorded_answer(self):
        rows = []
        for run in (1, 2):
            for page in ('stimulus', 'afterimage_duration', 'face_recognised', 'imagery_duration', 'relative_rating', 'rating_accuracy'):
                rows.append(dict(ai_run=run, ai_page=page, rt=2000,
                                 ai_code={'face_recognised': 2, 'relative_rating': 3, 'rating_accuracy': 0}.get(page)))
        gaps, issues, measures = audit.validate_component('afterimage', rows)
        self.assertFalse(gaps)
        self.assertFalse(issues)
        self.assertEqual(measures['afterimage_unsure'], 1)

    def test_object_learning_test_links_and_state_balance(self):
        rows = []
        for category in range(100):
            states = [1, 1 if category < 50 else 2]
            images = [f'e{exemplar}_s{state}.jpg' for exemplar, state in enumerate(states, 1)]
            rows.extend(dict(trial_type='psychophysics', category=category, ex=exemplar,
                             state=state, filename=filename)
                        for exemplar, (state, filename) in enumerate(zip(states, images), 1))
            rows.append(dict(trial_type='psychophysics', seq_type='test_trial', category=category,
                             final_imgs=images, final_correct=[1, 1], correct=2, rt=[500, 700]))
        gaps, issues, _ = audit.validate_component('objects', rows)
        self.assertFalse(gaps)
        self.assertFalse(issues)
        rows[-1]['category'] = 0
        _, issues, _ = audit.validate_component('objects', rows)
        self.assertIn('objects_test_category_mismatch', issues)


if __name__ == '__main__':
    unittest.main()
