import logging
from rich import print
from toolz import partition

from .app import app, Flag, Data

log = logging.getLogger(__name__)


@app.command()
def day_2_1(test: Flag("--test") = False):
    """Day 2.1"""
    data = Data(2, test=test)
    text = data.read_text()
    result = 0
    for product_range in text.split(","):
        begin, end = product_range.split("-")
        for number in range(int(begin), int(end) + 1):
            string = str(number)
            if len(string) % 2 != 0:
                continue
            half = int(len(string) / 2)
            splits = partition(half, string)
            if len(set(splits)) == 1:
                result += number
    print("solution:", result)


@app.command()
def day_2_2(test: Flag("--test") = False):
    data = Data(2, test=test)
    text = data.read_text()
    result = 0
    for product_range in text.split(","):
        begin, end = product_range.split("-")
        for number in range(int(begin), int(end) + 1):
            string = str(number)
            half = int(len(string) / 2)
            for n in range(1, half + 1):
                # skip uneven character splits
                if len(string) % n != 0:
                    continue
                splits = list(partition(n, string))
                if len(set(splits)) == 1:
                    result += number
                    break
    print("solution:", result)
