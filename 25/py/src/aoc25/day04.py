import itertools
from pathlib import Path
from rich import print
from .app import app, Flag, Data


@app.command()
def day_4_1(test: Flag("--test") = False):
    """Day 4.1"""
    data = Data(4, test=test).read_text().splitlines()
    print(data)
    nrow = len(data)
    ncol = len(data[0])
    x_moves = y_moves = [-1, 0, 1]
    result = 0
    for row, col in itertools.product(range(nrow), range(ncol)):
        cell = data[row][col]
        if not cell == "@":
            continue
        rolls = 0
        for dx, dy in itertools.product(x_moves, y_moves):
            if dx == 0 and dy == 0:
                continue
            xp = col + dx
            if xp < 0 or xp >= ncol:
                continue
            yp = row + dy
            if yp < 0 or yp >= nrow:
                continue
            if data[yp][xp] == "@":
                rolls += 1
        if rolls < 4:
            result += 1
    print("solution:", result)


@app.command()
def day_4_2(test: Flag("--test") = False):
    data: Path = Data(4, test=test)
    # pt 2 we need to mutate data, so let's make a list of lists
    grid = []
    with open(data, "r") as f:
        for line in f:
            grid.append([c for c in line if c != "\n"])

    nrow = len(grid)
    ncol = len(grid[0])
    x_moves = y_moves = [-1, 0, 1]

    # rcursive function until we hit an idempotent state
    def do_removes(grid, initial_removed):
        newly_removed = 0
        for row, col in itertools.product(range(len(grid)), range(len(grid[0]))):
            cell = grid[row][col]
            if not cell == "@":
                continue
            adjacent_rolls = 0
            for dx, dy in itertools.product(x_moves, y_moves):
                if dx == 0 and dy == 0:
                    continue
                xp = col + dx
                if not 0 <= xp < ncol:
                    continue
                yp = row + dy
                if not 0 <= yp < nrow:
                    continue
                if grid[yp][xp] == "@":
                    adjacent_rolls += 1
            if adjacent_rolls < 4:
                grid[row][col] = "x"
                newly_removed += 1
        if newly_removed > 0:
            return do_removes(grid, initial_removed + newly_removed)
        return initial_removed + newly_removed

    result = do_removes(grid, initial_removed=0)
    print("removed", result)
