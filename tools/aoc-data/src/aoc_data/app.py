from datetime import date as Date
from pathlib import Path
from typing import Optional

from typer import Typer, Option, Argument
from typing_extensions import Annotated
from aocd import get_data
from aocd.models import default_user

app = Typer()

def OptOption(typevar, *args, **kwargs):
    return Annotated[Optional[typevar], Option(*args, **kwargs)]


@app.command()
def fetch(
    day: OptOption(int, help = "day: e.g. 12") = Date.today().day,
    year: OptOption(int, help = "year: e.g. 2024") = Date.today().year,
    file: OptOption(str, help = "file to save data") = None
):
    daystr = str(day)
    if len(daystr) == 1:
        daystr = "0" + daystr
    if file is None:
        file = Path("data") / str(year) / daystr / "final.txt"
    if file.exists():
        print(f"{file} already there")
        return
    file.parent.mkdir(exist_ok=True, parents=True)
    # get data
    session = default_user().token
    data = get_data(session=session, day=day, year=year)
    with open(file, "w") as f:
        f.write(data)
    print(f"saved to {file}")


@app.command()
def all(
    year: OptOption(int, help = "year: e.g. 2024") = Date.today().year,
    path: OptOption(str, help = "directory to save") = None
):
    if path is None:
        path = Path("data") / str(year)
    last_day = Date.today().day if year == Date.today().year else 25
    for day in range(1, last_day + 1):
        fetch(day, year)
