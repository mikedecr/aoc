from itertools import pairwise
from typing import List
from toolz import pipe, curry, first, last


def parse_line(line: str):
    return pipe(
        line,
        lambda s: s.replace("\n", ""),
        curry(str.split, sep = " "),
        # curry(filter, str.isdigit),
        curry(map, int),
        list
    )


def diff(series: List[int]):
    return [b - a for a, b in pairwise(series)]


def recursive_extrapolation(series: List[int]) -> int:
    zeros = [0] * len(series)
    if series == zeros:
        return last(series)
    else:
        cur = last(series)
        lower = recursive_extrapolation(diff(series))
        return cur + lower


def iterative_extrapolation(series: List[int]) -> int:
    m = series.copy()
    lasts = []
    while m != ([0] * len(m)):
        lasts.append(m[-1])
        m = diff(m)
    return m[-1] + sum(lasts)


if __name__ == "__main__":

    file = "23/data/09/final.txt"
    lines = open(file).readlines()
    series = first(map(parse_line, lines))

    pipe(
        lines,
        curry(map, parse_line),
        curry(map, recursive_extrapolation),
        sum
    )

    pipe(
        lines,
        curry(map, parse_line),
        curry(map, iterative_extrapolation),
        sum
    )
