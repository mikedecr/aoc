import logging
from rich import print

from .app import app, Flag, Data, ReqOption

log = logging.getLogger(__name__)


@app.command()
def day_3(N: ReqOption(int, "-n"), test: Flag("--test") = False):
    """Day 3.1"""
    data = Data(3, test=test)
    result: int = 0
    with open(data, "r") as f:
        for line_num, line in enumerate(f):
            # initialize the current number
            current = line[0:N]
            for new in line[N:]:
                if not new.isdigit():
                    continue
                possibles: list[str] = [current]
                for n in range(N):
                    # drop the Nth char from current
                    # shift rest of the nums left
                    # append new char
                    possible: str = ''.join([c for i, c in enumerate(current) if i != n])
                    possible += new
                    possibles.append(possible)
                current = max(*possibles)
            result += int(current)
    print("solution:", result)
