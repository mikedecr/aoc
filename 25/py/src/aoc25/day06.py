from functools import reduce
from pathlib import Path
import numpy as np
from operator import add, mul
from typing import Callable

from rich import print

from .app import app, Flag, Data


OPERATIONS: dict[str, Callable] = {
    "+": add,
    "*": mul,
}

INITS = {
    "+": 0,
    "*": 1,
}


@app.command()
def day_6_1(test: Flag("--test") = False):
    """Day 6.1"""
    data_path: Path = Data(6, test=test)
    lines = data_path.read_text().splitlines()
    ops: list[str] = list(filter(len, lines[-1].split(" ")))
    args: list[list] = []
    for i in range(len(ops)):
        args.append([])
    for line in lines[:-1]:
        stripped = list(map(eval, filter(len, line.split(" "))))
        for i, n in enumerate(stripped):
            args[i].append(n)
    result = sum(
        reduce(OPERATIONS[ops[i]], args[i], 0 if ops[i] == "+" else 1)
        for i in range(len(ops))
    )
    print("solution:", result)


# k...k..kill.. me...

@app.command()
def day_6_2(test: Flag("--test") = False):
    """Day 6.2"""
    data_path: Path = Data(6, test=test)
    lines = data_path.read_text().splitlines()
    ops: list[str] = list(filter(len, lines[-1].split(" ")))
    grid: list[list] = []
    for i, line in enumerate(lines[:-1]):
        grid.append([])
        for j, n in enumerate(line):
            grid[i].append(n)
    grid = np.array(grid).T
    args = [[] for _ in ops]
    ix = 0
    for i in range(grid.shape[0]):
        text = ''.join(grid[i])
        if text.strip() == '':
            ix += 1
            continue
        number = eval(text)
        args[ix].append(number)
    result = sum(
        reduce(OPERATIONS[ops[i]], args[i])
        for i in range(len(ops))
    )
    print("solution:", result)
