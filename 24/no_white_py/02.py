"""
No-Significant-Whitespace Python. Not even function defs!
"""

import itertools
from pathlib import Path
from typing import List, Callable as Function


parse_words: Function[str, List[str]] = lambda chars: \
    [s for s in chars.split(" ") if s != ""]

parse_int_sequence: Function[str, List[int]] = lambda chars: \
    [int(word) for word in parse_words(chars)]

diff_series: Function[List[int], List[int]] = lambda series: \
    [a - b for a, b in itertools.pairwise(series)]

all_same_sign: Function[List[int], bool] = lambda seq: \
    all(x < 0 for x in seq) or all(x > 0 for x in seq)

all_good_region_values: Function[List[int], bool] = lambda seq: \
    all(1 <= abs(x) <= 3 for x in seq)

is_good_report: Function[List[int], bool] = lambda levels: \
    all(fn(diff_series(levels)) for fn in [all_same_sign, all_good_region_values])

part_one: Function[Path, int] = lambda filepath: \
    sum(is_good_report(parse_int_sequence(seq))
        for seq in open(filepath).read().splitlines())

# pt 2 with good ol sequence operations
take: Function[[int, List], List] = lambda ind, lst: lst[:ind]
drop: Function[[int, List], List] = lambda ind, lst: lst[ind:]
remove_nth: Function[[int, List], List] = lambda ind, lst: take(ind, lst) + drop(ind + 1, lst)

# test if any variation of the sequence is good
is_good_report_flexible: Function[List[int], bool] = lambda levels: \
    any(is_good_report(remove_nth(n, levels)) for n in range(len(levels)))

part_two: Function[Path, int] = lambda filepath: \
    sum(is_good_report_flexible(parse_int_sequence(seq))
        for seq in open(filepath).read().splitlines())


if __name__ == "__main__":

    pt2_data = Path("data/2024/02")
    test_file = pt2_data / "test.txt"
    final_file = pt2_data / "final.txt"

    assert (found := part_one(test_file)) == (expected := 2), f"{found=}, {expected=}"
    assert (found := part_two(test_file)) == (expected := 4), f"{found=}, {expected=}"

    print(f"{part_one(final_file)=}")
    print(f"{part_two(final_file)=}")
