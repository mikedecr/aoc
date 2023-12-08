
not(f) = (a...) -> f(a...) == false
drop_empties(l) = filter(not(isempty), l)
as_integer(s) = parse(Int, s)

function score_card(line)
    left, right = split(line, "|")
    haystack = split(split(left, ":")[2], " ") |> drop_empties
    needles = split(right, " ") |> drop_empties
    n_matches = filter(n -> n in haystack, needles) |> length
    n_matches == 0 && return 0
    return 2^(n_matches - 1)
end

function part1(inputs)
    score_card.(inputs) |> sum
end


@assert part1(readlines("data/04/test.txt")) == 13

part1(readlines("data/04/final.txt"))


