import itertools
from dataclasses import dataclass
from functools import reduce
from operator import mul
from pathlib import Path

import numpy as np
from rich import print

from .app import Data, Flag, app


@dataclass
class Box:
    x: int
    y: int
    z: int

    def __hash__(self):
        return hash((Box, *self.to_tuple()))

    def to_tuple(self):
        return (self.x, self.y, self.z)

    @classmethod
    def from_str(cls, s: str) -> "Box":
        """'x,y,z' -> Box(x, y, z)"""
        chars = s.strip().split(",")
        ints = map(int, chars)
        return cls(*ints)

    @staticmethod
    def compute_distance(a: "Box", b: "Box") -> float:
        a_arr = np.array(a.to_tuple())
        b_arr = np.array(b.to_tuple())
        return np.linalg.norm(a_arr - b_arr)


# this is just a set of Boxes
class Circuit(set):
    def __init__(self, points: set[Box]):
        assert all(isinstance(pt, Box) for pt in points), (
            "Circuit must be a set of Boxes"
        )
        super().__init__(points)


@dataclass
class CircuitNetwork:
    _circuits: list[Circuit]

    # idk if this is the best place for this method but oh well.
    def contains_link(self, a: Box, b: Box) -> bool:
        return any(a in circ and b in circ for circ in self._circuits)

    def attach(self, a: Circuit, b: Circuit) -> None:
        assert a != b, "Circuits must be distinct"
        assert a in self._circuits, f"Circuit {a=} is not in the network"
        assert b in self._circuits, f"Circuit {b=} is not in the network"
        self._circuits.remove(a)
        self._circuits.remove(b)
        self._circuits.append(a.union(b))

    def get_circuit(self, pt: Box) -> Circuit:
        for circ in self._circuits:
            if pt in circ:
                return circ

    def map(self, f):
        return map(f, self._circuits)

    def __len__(self):
        return len(self._circuits)


@app.command()
def day_8_1(test: Flag("--test") = False):
    """Day 8.1"""
    data_path: Path = Data(8, test=test)
    points: list[Box] = [Box.from_str(line) for line in open(data_path, "r")]
    ordered_connections: list[set[Box]] = sorted(
        map(set, itertools.combinations(points, r=2)),
        key=lambda pair: Box.compute_distance(*pair),
    )
    circuits: CircuitNetwork = CircuitNetwork([Circuit({pt}) for pt in points])
    for _ in range(10 if test else 1000):
        a, b = ordered_connections.pop(0)
        if circuits.contains_link(a, b):
            continue
        circuits.attach(circuits.get_circuit(a), circuits.get_circuit(b))
    largest_3_circuit_sizes = sorted(circuits.map(len))[-3:]
    result = reduce(mul, largest_3_circuit_sizes)
    print("solution:", result)


@app.command()
def day_8_2(test: Flag("--test") = False):
    """Day 8.2"""
    data_path: Path = Data(8, test=test)
    points: list[Box] = [Box.from_str(line) for line in open(data_path, "r")]
    ordered_connections: list[set[Box]] = sorted(
        map(set, itertools.combinations(points, r=2)),
        key=lambda pair: Box.compute_distance(*pair),
    )
    circuits: CircuitNetwork = CircuitNetwork([Circuit({pt}) for pt in points])
    while ordered_connections:
        possible = ordered_connections.pop(0)
        if circuits.contains_link(*possible):
            continue
        # we need to persist these assignments if they are a new link
        a, b = possible
        circuits.attach(circuits.get_circuit(a), circuits.get_circuit(b))
    result = a.x * b.x
    print("solution:", result)


if __name__ == "__main__":
    app()
