from typing import List, Tuple


# :: common ::::::::::::::::::::::::::::::::::::::::

def parse_two_lists(file: str) -> Tuple[List[int]]:
    left = []
    right = []
    for line in open(file):
        # creates list of "a", "", "", "b"
        substrings = line.replace("\n", "").split(" ")
        a, b = map(int, filter(lambda s: s != "", substrings))
        left.append(a)
        right.append(b)
    return left, right


# notes:
# could have done pipe(substrings, curry(filter, non_empty), curry(map, int))
# IMO this is only "obscure" because writing it yourself exposes the operation
# it only looks simple in e.g. R


# :: part one ::::::::::::::::::::::::::::::::::::::

def sum_abs_diff(left: List[int], right: List[int]) -> int:
    return sum(abs(a - b) for a, b in zip(left, right))


def part_one(filepath: str):
    sorted_left, sorted_right = map(sorted, parse_two_lists(filepath))
    return sum_abs_diff(sorted_left, sorted_right)


# :: part two ::::::::::::::::::::::::::::::::::::::

def num_appearances(needle: int, haystack: int):
    """
    How many times does needle appear in haystack
    """
    return sum(1 for x in haystack if x == needle)


def part_two(filepath: str):
    left, right = parse_two_lists(filepath)
    return sum(lnum * num_appearances(lnum, right) for lnum in left)


if __name__ == "__main__":

    test_file = "data/24/01/test.txt"
    assert part_one(test_file) == 11
    assert part_two(test_file) == 31

    final_file = "data/24/01/final.txt"
    print("part one:", part_one(final_file))
    print("part two:", part_two(final_file))
