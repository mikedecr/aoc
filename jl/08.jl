using Chain
using Memoize
using IterTools
using Lazy: cycle
using Base.Iterators: peel
using TailRec

#=================#
#=    library    =#
#=================#

function parse_assignment(line)
    split(line)[1]
end

function index(a, i) a[i] end

@memoize function parse_LR(line)
    @chain line begin
        split(" = ")
        index(2)
        replace("(" => "", ")" => "")
        split(", ")
    end
end

function parse_node(line)
    lr = parse_LR(line)
    key = parse_assignment(line)
    Dict(key => Dict('L' => lr[1], 'R' => lr[2]))
end

function parse_nodes(input)
    assignments = filter(s -> contains(s, "="), input)
    reduce(merge, parse_node.(assignments))
end

#====================#
#=    first part    =#
#====================#

function walk_elements(n, here, steps, nodes)
    if here == "ZZZ"
        return n
    end
    dir, next = peel(steps)
    # println(here)
    # println(dir)
    # println(nodes[here])
    return walk_elements(n + 1, nodes[here][dir], next, nodes)
end

function part_one(input)
    steps = input[1] |> collect |> cycle
    nodes = parse_nodes(input)
    return walk_elements(0, "AAA", steps, nodes)
end

@assert part_one(readlines("data/08/test.txt")) == 2
@assert part_one(readlines("data/08/test_cycle.txt")) == 6

println("Part 1: ", part_one(readlines("data/08/final.txt")))

#=====================#
#=    second part    =#
#=====================#

function part_two(input)
    steps = input[1] |> collect |> cycle
    nodes = parse_nodes(input)
    starts = filter(str -> endswith(str, 'A'), keys(nodes))
    walk_elements_simultaneously(0, starts, steps, nodes)
end

@tailrec function walk_elements_simultaneously(n, heres, steps, nodes)
    if all(endswith(str, 'Z') for str in heres)
        return n
    end
    dir, next = peel(steps)
    all_next = [nodes[h][dir] for h in heres]
    return walk_elements_simultaneously(n + 1, all_next, next, nodes)
end

@assert part_two(readlines("data/08/test_multi.txt")) == 6

part_two(readlines("data/08/final.txt"))



