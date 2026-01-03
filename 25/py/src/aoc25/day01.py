import logging
from pathlib import Path
from rich import print
from toolz import groupby

from .app import app, Flag, Data


log = logging.getLogger(__name__)


__all__ = ["day_1_1"]


@app.command()
def day_1_1(
    test: Flag("--test", help = "test mode") = False,
):
    data = Data(1, test=test)
    pos = 50
    password = 0
    for row in data.read_text().splitlines():
        val = int(row[1:]) * (-1 if row[0] == "L" else 1)
        if val > 99:
            log.warning(f"val {val} is too high")
        pos = (pos + val) % 100
        if pos == 0:
            password += 1
    print("solution:", password)


@app.command()
def day_1_2(test: Flag("--test", help = "test mode") = False):
    data = Data(1, test=test)
    pos = 50
    password = 0
    for row in data.read_text().splitlines():
        val = int(row[1:]) * (-1 if row[0] == "L" else 1)
        for _ in range(abs(val)):
            pos += (1 if val > 0 else -1)
            pos = pos % 100
            if pos == 0:
                password += 1
    print("solution:", password)
