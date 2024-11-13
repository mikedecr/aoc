from itertools import pairwise


bad_substrings = ["ab", "cd", "pq", "xy"]


def contains_bad_substring(input: str) -> bool:
    return any(
        ''.join(p) in bad_substrings
        for p in pairwise(input)
    )


vowels = list('aeiou')


def has_enough_vowels(input: str) -> bool:
    return sum(c in vowels for c in input) >= 3


def has_double_letter(input: str) -> bool:
    return any(a == b for a, b in pairwise(input))


def negate(f):
    def _not_f(x):
        return not f(x)
    return _not_f


def is_good_string(input: str) -> bool:
    fns = [negate(contains_bad_substring), has_enough_vowels, has_double_letter]
    return all(fn(input) for fn in fns)


if __name__ == "__main__":

    file = "15/data/05-final.txt"
    sum(map(is_good_string, open(file).read().splitlines()))






