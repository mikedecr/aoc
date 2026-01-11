from pathlib import Path
from rich import print
from .app import app, Flag, Data


START = "S"
SPLITTER = "^"


@app.command()
def day_7_1(test: Flag("--test") = False):
    """Day 7.1"""
    data_path: Path = Data(7, test=test)
    lines: list[str] = data_path.read_text().splitlines()
    beams: set[int] = set(i for i, c in enumerate(lines[0]) if c == START)
    splits = 0
    for i, line in enumerate(lines[1:]):
        next = set()
        splitters: set[int] = set(i for i, c in enumerate(line) if c == SPLITTER)
        if not splitters:
            continue
        for b in beams:
            if b in splitters:
                splits += 1
                next |= set({b - 1, b + 1})
            else:
                next.add(b)
        beams = next
    print("solution:", splits)


# in part two, every "split" creates an additional "path"
# there is no de-duplication of beams, but running the algo for each path is too expensive.
# it is sufficient to count beams at each position.

@app.command()
def day_7_2(test: Flag("--test") = False):
    """Day 7.2"""
    data_path: Path = Data(7, test=test)
    lines: list[str] = data_path.read_text().splitlines()
    beams: dict[int, int] = {i: 1 for i, c in enumerate(lines[0]) if c == START}
    for line in lines[1:]:
        next = {}
        splitters: set[int] = set(i for i, c in enumerate(line) if c == SPLITTER)
        if not splitters:
            continue
        for i, wt in beams.items():
            if i in splitters:
                left, right = i - 1, i + 1
                next[left] = wt + next.get(left, 0)
                next[right] = wt + next.get(right, 0)
            else:
                next[i] = wt + next.get(i, 0)
        beams = next
    print("solution", sum(beams.values()))
