from pathlib import Path
from typer import Typer, Option
from typing import Annotated

app = Typer(name = "Advent of Code 2025")


def Root():
    return Path(".").resolve()


def Data(day: int, test: bool = False) -> Path:
    padded = str(day).zfill(2)
    directory = Root().parent / "data" / padded
    return directory / "test.txt" if test else directory / "final.txt"


def Flag(*args, **kwargs):
    return Annotated[bool, Option(*args, **kwargs)]


def ReqOption(type_, *args, **kwargs):
    return Annotated[type_, Option(*args, **kwargs)]
