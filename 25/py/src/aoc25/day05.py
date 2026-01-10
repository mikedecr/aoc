from functools import reduce
from pathlib import Path
from typing import TypeAlias
from rich import print
from .app import app, Flag, Data

Interval: TypeAlias = tuple[int, int]


@app.command()
def day_5_1(test: Flag("--test") = False):
    """Day 5.1"""
    data_path: Path = Data(5, test=test)
    # just parse data...
    key = "ranges"
    data = {key: []}
    with open(data_path, "r") as f:
        for line in f:
            if line == "\n":
                key = "ids"
                data[key] = []
                continue
            if key == "ranges":
                data[key].append(tuple(map(eval, line.strip().split("-"))))
            elif key == "ids":
                data[key].append(eval(line.strip()))
    # algo
    result = 0
    for id in data["ids"]:
        for range in data["ranges"]:
            if id >= range[0] and id <= range[1]:
                print("id", id, "in range", range)
                result += 1
                break  # range loop
    print("solution:", result)


@app.command()
def day_5_2(test: Flag("--test") = False):
    data_path: Path = Data(5, test=test)
    intervals_lst: list[Interval] = []
    with open(data_path, "r") as f:
        for line in f:
            if line == "\n":
                break
            interval: Interval = tuple(eval(chr) for chr in line.strip().split("-"))
            intervals_lst.append(interval)
    # with the intervals sorted, we can do this w/ reduce
    # fn: combine RIGHT w/ tail of LEFT or append RIGHT to LEFT
    intervals_lst.sort()
    collapsed_intervals: list[Interval] = reduce(attach_interval, intervals_lst, [])
    result: int = sum(1 + (right - left) for left, right in collapsed_intervals)
    print("solution:", result)

def attach_interval(lst: list[Interval], new: Interval) -> list[Interval]:
    """Collapse interval `new` to the last element of `lst` if possible, otherwise append."""
    if len(lst) == 0:
        lst.append(new)
        return lst
    if (collapsed := maybe_collapse_intervals(lst[-1], new)):
        lst[-1] = collapsed
    else:
        lst.append(new)
    return lst

def maybe_collapse_intervals(left: Interval, right: Interval) -> tuple[Interval, ...] | None:
    """Return collapsed interval if possible, or None"""
    a, b = left
    x, y = right
    if a <= x <= y <= b:    # left contains right
        return (a, b)
    elif x <= a <= b <= y:  # right contains left
        return (x, y)
    elif a <= x <= b <= y:  # left straddles right lower bound
        return (a, y)
    elif x <= a <= y <= b:  # left straddles right upper bound
        return (x, b)
    else:
        return
