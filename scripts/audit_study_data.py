"""Read private JATOS ZIP exports; write aggregate findings and a private issue ledger.

Usage: python3 scripts/audit_study_data.py /path/to/private/export/folders
Each folder is named for its JATOS_*_UID configuration variable and contains
results_PRIVATE.zip. No server state or participant data are modified. The output
stays beside the private inputs; only aggregate findings belong in the repository.
"""

import argparse
import hashlib
import itertools
import json
import math
import re
import zipfile
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path


STUDIES = {
    'JATOS_COLORS_AND_IMAGERY_STUDY_2026H_UID': ('Autumn imagery', {49456: 'vviq', 49460: 'afterimage', 49457: 'imagery_practice', 49458: 'imagery_192', 49459: 'imagery_192'}),
    'JATOS_COLORS_AND_IMAGERY_STUDY_2026_UID': ('Spring imagery', {40213: 'vviq', 40214: 'imagery_practice', 40215: 'imagery_288', 40216: 'imagery_288'}),
    'JATOS_TEMP_ATT_STUDY_UID': ('Temporal attention', {29929: 'temporal_practice', 29930: 'temporal_main'}),
    'JATOS_DECOY_STUDY_2026H_UID': ('Autumn decoy', {49723: 'decoy'}),
    'JATOS_DECOY_STUDY_2026_UID': ('Spring decoy', {39870: 'decoy'}),
    'JATOS_TOMATO_STUDY_2026_UID': ('Tomatoes', {39794: 'tomato_practice', 39795: 'tomato_main'}),
    'JATOS_OBJ_STUDY_UID': ('Objects', {29943: 'objects'}),
    'JATOS_MONSTERS_STUDY_UID': ('Monsters', {29942: 'monsters'}),
}


def finite(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def angle_difference(a, b, period=360):
    return (a - b + period / 2) % period - period / 2


def response_rows(rows):
    return [row for row in rows if row.get('trial_type') == 'psychophysics' and row.get('seq_type') == 'response']


def with_stimulus_context(rows):
    """Stimulus metadata are recorded on earlier rows in the same component."""
    context = {}
    fields = ('color_bin', 'target_position', 'target_x', 'target_sd', 'distr_sd', 'similarity_bin', 'cue_n',
              'left_correlation', 'right_correlation', 'overall_sample_mean', 'cued_color',
              'target_line_ori', 'target_ori', 'real_target_position', 'cue_type',
              't1_ori', 't2_ori', 't3_ori')
    for row in rows:
        context.update({key: row[key] for key in fields if row.get(key) is not None})
        if row.get('trial_type') == 'psychophysics' and row.get('seq_type') == 'response':
            yield {**context, **row}


def validate_component(kind, raw):
    gaps, issues, measures = [], Counter(), {}
    if kind in ('comments', 'feedback'):
        if not isinstance(raw, dict) or raw.get('phase') != kind:
            return [kind + '_record_missing'], issues, measures
        if kind == 'comments' and (not isinstance(raw.get('comment'), str) or raw.get('skipped') != (raw.get('comment') == '')):
            issues['comment_skip_inconsistent'] += 1
        if kind == 'feedback' and raw.get('trials') != 150:
            gaps.append('feedback_trial_count')
        return gaps, issues, measures
    rows = [row for row in raw if isinstance(row, dict)] if isinstance(raw, list) else []
    task = [row for row in rows if row.get('trial_type') == 'psychophysics']
    responses = list(with_stimulus_context(rows))

    if kind == 'vviq':
        values = [value for row in rows if row.get('trial_type') == 'survey-likert'
                  for value in (row.get('response') or {}).values()]
        if len(values) != 16:
            gaps.append('questionnaire_items_missing')
        issues['questionnaire_value_out_of_range'] += sum(not isinstance(v, int) or not 0 <= v <= 4 for v in values)
        measures['questionnaire_items'] = len(values)
    elif kind == 'afterimage':
        pages = ('stimulus', 'afterimage_duration', 'face_recognised', 'imagery_duration', 'relative_rating', 'rating_accuracy')
        keys = Counter((row.get('ai_run'), row.get('ai_page')) for row in rows)
        if any(keys[run, page] != 1 for run in (1, 2) for page in pages):
            gaps.append('afterimage_run_or_page_missing')
        allowed = {'relative_rating': set(range(-2, 4)), 'face_recognised': {0, 1, 2}, 'rating_accuracy': set(range(5))}
        for row in rows:
            page = row.get('ai_page')
            if page in allowed and row.get('ai_code') not in allowed[page]:
                issues['afterimage_code_out_of_range'] += 1
            if page in ('afterimage_duration', 'imagery_duration'):
                if not finite(row.get('rt')) or row['rt'] < 0:
                    issues['afterimage_duration_invalid'] += 1
                elif row['rt'] < 1000:
                    issues['afterimage_duration_under_1s_review'] += 1
            if row.get('ai_run') == 2 and page == 'relative_rating':
                measures['afterimage_unsure'] = int(row.get('ai_code') == 3)
    elif kind in ('imagery_practice', 'temporal_practice', 'tomato_practice'):
        cycle = {'imagery_practice': 20, 'temporal_practice': 15, 'tomato_practice': 10}[kind]
        if not responses or len(responses) % cycle:
            gaps.append('practice_responses_missing')
        measures['practice_responses'] = len(responses)
    elif kind.startswith('imagery_'):
        expected = int(kind.split('_')[1])
        if len(responses) != expected:
            gaps.append('memory_responses_missing')
        keys = Counter((row.get('trial_number'), row.get('cue_n')) for row in responses)
        if responses and (len(keys) != expected or any(n != 1 for n in keys.values())):
            issues['memory_trial_key_mismatch'] += 1
        stimulus = [row for row in task if row.get('seq_type') == 'stimuli']
        expected_cells = Counter(itertools.product(
            [45, 135, 225, 315] if expected == 192 else [30, 90, 150, 210, 270, 330],
            ['left', 'right'], [5, 20], [5, 20], [20, 45, 135]))
        cells = Counter((row.get('color_bin'), 'left' if row.get('target_x', 0) < 0 else 'right',
                         row.get('target_sd'), row.get('distr_sd'), row.get('similarity_bin')) for row in stimulus)
        if stimulus and cells != expected_cells:
            issues['imagery_factorial_mismatch'] += 1
        measures['memory_responses'] = len(responses)
    elif kind == 'temporal_main':
        if len(responses) != 150:
            gaps.append('temporal_responses_missing')
        if sorted(row.get('trial_number', -1) for row in responses) != list(range(1, 151)):
            issues['temporal_trial_key_mismatch'] += 1
        cells = Counter((row.get('target_position'), row.get('cue_type')) for row in responses)
        expected = Counter({(position, cue): repetitions for position in (1, 2, 3)
                            for cue, repetitions in [('neutral', 10), ('valid', 30), ('invalid', 10)]})
        if responses and cells != expected:
            issues['temporal_factorial_mismatch'] += 1
        for row in responses:
            if row.get('real_target_position') not in (1, 2, 3):
                issues['temporal_target_out_of_range'] += 1
            if row.get('cue_type') == 'valid' and row.get('target_position') != row.get('real_target_position'):
                issues['temporal_cue_validity_mismatch'] += 1
            if row.get('cue_type') == 'invalid' and row.get('target_position') == row.get('real_target_position'):
                issues['temporal_cue_validity_mismatch'] += 1
        measures['memory_responses'] = len(responses)
    elif kind == 'tomato_main':
        if len(responses) != 288:
            gaps.append('tomato_responses_missing')
        if sorted(row.get('trial_number', -1) for row in responses) != list(range(1, 289)):
            issues['tomato_trial_key_mismatch'] += 1
        stimulus = [row for row in task if row.get('seq_type') == 'stimuli']
        cells = Counter(tuple(row.get(k) for k in ('color_bin', 'target_position', 'similarity_bin', 'left_correlation', 'right_correlation')) for row in stimulus)
        expected = Counter({cell: 4 for cell in itertools.product([60, 180, 300], ['left', 'right'], [20, 45, 135], [0, 0.8], [0, 0.8])})
        if stimulus and cells != expected:
            issues['tomato_factorial_mismatch'] += 1
        measures['memory_responses'] = len(responses)
    elif kind == 'monsters':
        main = [row for row in task if row.get('block_i') is not None and row.get('seq_type') == 'search']
        if len(main) not in (576, 864):
            gaps.append('monsters_main_trials_missing')
        blocks = defaultdict(list)
        for row in main:
            blocks[row['block_i']].append(row)
        for block in blocks.values():
            lengths = {row.get('real_length') for row in block}
            if len(lengths) != 1 or not all(finite(n) and n > 0 for n in lengths):
                issues['monsters_planned_length_invalid'] += 1
                continue
            length = int(next(iter(lengths)))
            if sorted(row.get('trial_i_within_block', -1) for row in block) != list(range(1, length + 1)):
                gaps.append('monsters_block_position_missing_or_duplicated')
            if any(row.get('expected_length', 0) + row.get('lengthDiff', 0) != length for row in block):
                issues['monsters_length_difference_mismatch'] += 1
        block_cells = Counter((block[0].get('expected_length'), block[0].get('lengthDiff')) for block in blocks.values())
        expected = Counter({(length, diff): (32 if len(main) == 864 else 16) if diff == 0 else 2
                            for length in (5, 6, 7) for diff in range(-4, 5)})
        if main and block_cells != expected:
            issues['monsters_factorial_mismatch'] += 1
        for row in main:
            if row.get('correct') is None and row.get('rt') is None and row.get('clicked_monster_id') is None:
                issues['legacy_monsters_timeout_without_correctness'] += 1
            elif row.get('correct') not in (0, 1):
                issues['monsters_correctness_invalid'] += 1
            if row.get('clicked_monster_id') is not None and row.get('correct') != int(row['clicked_monster_id'] == 0):
                issues['monsters_scoring_mismatch'] += 1
        if main and not any(row.get('correct') == 1 for row in main):
            issues['no_correct_monsters_responses_review'] += 1
        responses = main
        measures['main_trials'] = len(main)
        measures['practice_rows'] = len(task) - len(main)
    elif kind == 'objects':
        tests = [row for row in task if row.get('seq_type') == 'test_trial']
        learning = [row for row in task if row.get('seq_type') != 'test_trial']
        if len(learning) != 200 or len(tests) != 100:
            gaps.append('objects_learning_or_test_trials_missing')
        items = {(row.get('category'), row.get('ex')): row for row in learning}
        if learning and (len(items) != 200 or any(not all(row.get(key) is not None for key in ('category', 'ex', 'state', 'filename')) for row in learning)):
            gaps.append('objects_learning_item_metadata_missing')
        categories = {row.get('category') for row in tests}
        if tests and (len(categories) != 100 or len(tests) != len(categories)):
            issues['objects_test_category_mismatch'] += 1
        if len(items) == 200 and not gaps:
            learning_categories = {category for category, _ in items}
            if categories != learning_categories or any((category, exemplar) not in items for category in categories for exemplar in (1, 2)):
                issues['objects_learning_test_link_mismatch'] += 1
            else:
                states = [row.get('state') for row in learning]
                if any(state not in (1, 2) for state in states):
                    issues['objects_studied_state_out_of_range'] += 1
                same = sum(items[category, 1]['state'] == items[category, 2]['state'] for category in categories)
                if same != 50:
                    issues['objects_state_condition_balance_mismatch'] += 1
        for row in tests:
            images, correct = row.get('final_imgs'), row.get('final_correct')
            if not isinstance(images, list) or len(images) != 2 or not isinstance(correct, list) or len(correct) != 2:
                gaps.append('objects_item_reports_missing')
                continue
            if any(v not in (0, 1) for v in correct) or row.get('correct') != sum(correct):
                issues['objects_scoring_mismatch'] += 1
            for filename, score in zip(images, correct):
                exemplar = re.search(r'e(\d+)', filename)
                state = re.search(r's(\d+)', filename)
                item = items.get((row.get('category'), int(exemplar[1]))) if exemplar else None
                if item and item.get('state') is not None and state and score != int(int(state[1]) == item['state']):
                    issues['objects_studied_state_mismatch'] += 1
        measures['learning_trials'], measures['test_trials'] = len(learning), len(tests)
        responses = tests
    elif kind == 'decoy':
        main = [row for row in task if row.get('phase') == 'main'] if any('phase' in row for row in task) else task
        revised = any(row.get('exp_version') == 'H26-shopping-240-v1' for row in main)
        count = 240 if revised else 288
        if len(main) != count:
            gaps.append('decoy_main_trials_missing')
        if sorted(row.get('trial_counter', -1) for row in main) != list(range(1, count + 1)):
            issues['decoy_trial_key_mismatch'] += 1
        shared = list(itertools.product(['perceptual', 'numeric'], ['NH', 'WL'], ['H', 'W'], [0.03, 0.1]))
        fields = ('condition', 'correct_option', 'set_type', 'target_to_competitor', 'decoy_on', 'decoy_type', 'decoy_reduction')
        expected = Counter()
        for cell in shared:
            for placement, decoy_type, reduction in itertools.product(['target', 'competitor'], ['stronger', 'weaker', 'both'], [0.05, 0.2]):
                expected[cell + (placement, decoy_type, reduction)] += 1
            if revised:
                expected[cell + ('no_decoy', None, None)] += 3
            else:
                for decoy_type, reduction in itertools.product(['stronger', 'weaker', 'both'], [0.05, 0.2]):
                    expected[cell + ('no_decoy', decoy_type, reduction)] += 1
        if main and Counter(tuple(row.get(key) for key in fields) for row in main) != expected:
            issues['decoy_factorial_mismatch'] += 1
        for row in main:
            response = row.get('response')
            if response is not None:
                choice = next((row.get('stim_type_' + str(i)) for i in range(3) if row.get('stim_number_' + str(i)) == response), None)
                if choice is None or row.get('correct') != int(choice == 'target'):
                    issues['decoy_scoring_or_response_mapping_mismatch'] += 1
        measures['main_trials'], measures['revised_protocol'] = len(main), int(revised)
        responses = main

    if kind not in ('vviq', 'afterimage'):
        deadline = (15000 if revised else 20000) if kind == 'decoy' else 5000 if kind.startswith('imagery_') or kind == 'monsters' else 10000 if kind.startswith('tomato_') else None
        for row in responses:
            rt = row.get('rt')
            rts = rt if isinstance(rt, list) else [rt]
            for value in rts:
                if value is not None and (not finite(value) or value < 0):
                    issues['reaction_time_invalid'] += 1
                elif finite(value):
                    if value < 100:
                        issues[('practice_' if kind.endswith('_practice') else '') + 'reaction_time_under_100ms_review'] += 1
                    if deadline and value > deadline + 1:
                        issues['reaction_time_over_nominal_deadline_review'] += 1
            error = row.get('error')
            period = 180 if kind.startswith('temporal_') else 360
            if error is not None and (not finite(error) or abs(error) > period / 2 + 1e-6):
                issues['angular_error_out_of_range'] += 1
            if finite(error):
                response = row.get('resp_ori' if period == 180 else 'resp_color')
                target = row.get('target_line_ori', row.get('target_ori')) if period == 180 else row.get('overall_sample_mean') if kind.startswith('tomato_') else row.get('cued_color')
                if finite(response) and finite(target) and abs(angle_difference(error, angle_difference(response, target, period), period)) > 1e-5:
                    issues['recorded_angular_error_mismatch'] += 1
        measures['missing_response_rts'] = sum(row.get('rt') is None for row in responses)
        measures['finite_response_rts'] = sum(finite(row.get('rt')) for row in responses)
        measures['response_rows'] = len(responses)
    return sorted(set(gaps)), +issues, measures


def audit(folder, cutoff):
    name, requirements = STUDIES[folder.name]
    private, aggregates = [], []
    with zipfile.ZipFile(folder / 'results_PRIVATE.zip') as archive:
        metadata = json.loads(archive.read(next(n for n in archive.namelist() if n.endswith('metadata.json'))))['data'][0]
        files = {re.search(r'comp-result_(\d+)', n)[1]: n for n in archive.namelist() if re.search(r'comp-result_(\d+)', n) and n.endswith('.txt')}
        for session in metadata['studyResults']:
            if session['studyState'] != 'FINISHED':
                continue
            parsed = {}
            for component in session['componentResults']:
                path = files.get(str(component['id']))
                try:
                    raw = json.loads(archive.read(path)) if path else []
                except (ValueError, UnicodeDecodeError):
                    raw = []
                parsed[component['id']] = raw
            required = dict(requirements)
            if name == 'Temporal attention' and any(isinstance(raw, list) and any(isinstance(row, dict) and row.get('exp_version') == 'temporal-feedback-v2' for row in raw) for raw in parsed.values()):
                required.update({49990: 'comments', 49991: 'feedback'})
            gaps, problems, measurements = [], Counter(), Counter()
            for component_id, kind in required.items():
                candidates = []
                for component in session['componentResults']:
                    if component['componentId'] == component_id:
                        result = validate_component(kind, parsed[component['id']])
                        candidates.append((len(result[0]), component['componentState'] != 'FINISHED', -len(parsed[component['id']]), component, result))
                if candidates:
                    _, _, _, component, (component_gaps, component_issues, component_measures) = min(candidates, key=lambda x: x[:3])
                    if not component_gaps and component['componentState'] != 'FINISHED':
                        component_issues['complete_data_in_nonfinished_component'] += 1
                else:
                    component_gaps, component_issues, component_measures = [kind + '_component_missing'], Counter(), {}
                gaps.extend(component_gaps)
                problems.update(component_issues)
                measurements.update(component_measures)
            current = session['startDate'] > cutoff
            start = datetime.fromtimestamp(session['startDate'] / 1000, timezone.utc).isoformat()
            browsers = [row for raw in parsed.values() if isinstance(raw, list) for row in raw if isinstance(row, dict) and row.get('trial_type') == 'browser-check']
            browser_failed = any(finite(row.get('width')) and finite(row.get('height')) and (row['width'] < 1000 or row['height'] < 600) for row in browsers)
            record = dict(study=name, study_id=metadata['studyId'], session_id=session['id'], start_utc=start,
                          current=current, gaps=sorted(set(gaps)), issues=dict(problems), measures=dict(measurements),
                          browser_below_minimum=browser_failed)
            if gaps or problems:
                private.append(record)
            aggregates.append(record)
    summary = {'study': name, 'study_id': metadata['studyId'], 'all_finished': len(aggregates),
               'all_with_gaps': sum(bool(r['gaps']) for r in aggregates),
               'current_finished': sum(r['current'] for r in aggregates),
               'current_with_gaps': sum(r['current'] and bool(r['gaps']) for r in aggregates)}
    with (folder / 'results_PRIVATE.zip').open('rb') as handle:
        summary['export_sha256'] = hashlib.file_digest(handle, 'sha256').hexdigest()
    summary['export_downloaded_utc'] = datetime.fromtimestamp(
        (folder / 'results_PRIVATE.zip').stat().st_mtime, timezone.utc).isoformat()
    for scope, records in [('all', aggregates), ('current', [r for r in aggregates if r['current']])]:
        codes = set(code for row in records for code in row['gaps'] + list(row['issues']))
        summary[scope + '_findings'] = {code: {'sessions': sum(code in row['gaps'] or code in row['issues'] for row in records),
                                             'events': sum(row['issues'].get(code, int(code in row['gaps'])) for row in records)} for code in sorted(codes)}
        summary[scope + '_measures'] = dict(sum((Counter(r['measures']) for r in records), Counter()))
    return summary, private


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('exports', type=Path)
    parser.add_argument('--cutoff', default='2026-10-01')
    args = parser.parse_args()
    cutoff = datetime.fromisoformat(args.cutoff).replace(tzinfo=timezone.utc).timestamp() * 1000
    summaries, private = [], []
    for config in STUDIES:
        folder = args.exports / config
        summary, issues = audit(folder, cutoff)
        summaries.append(summary)
        private.extend(issues)
        print(summary['study'], ': finished/gaps =', summary['all_finished'], summary['all_with_gaps'],
              '; current finished/gaps =', summary['current_finished'], summary['current_with_gaps'], flush=True)
    (args.exports / 'audit_summary.json').write_text(json.dumps({
        'generated_at_utc': datetime.now(timezone.utc).isoformat(),
        'cutoff_utc': args.cutoff, 'studies': summaries}, indent=2) + '\n')
    (args.exports / 'audit_issues_PRIVATE.json').write_text(json.dumps(private, indent=2) + '\n')


if __name__ == '__main__':
    main()
