using Memoize
using IterTools: partition
using .Iterators
using Chain
using Functors: fmap

input = readlines("data/05/test.txt")

@memoize function parse_seeds(input::Vector{String})::Vector{Int}
    str_nums = split(input[1], "seeds: ")[2]
    parse.(Int, split(str_nums, " "))
end

@memoize function to_int_sequence(str::String)::Vector{Int}
    map(s -> parse(Int, s), split(str, " "))
end

# ----- different style ----------

negate(f) = (a...)  -> !f(a...)

function clean_sequences(name, input)
    sep = "-to-" * name
    contains_set(s) = occursin(sep, s)
    drop_front = dropwhile(negate(contains_set), input)  # drop all before impt section
    segment = takewhile(!=(""), drop_front)                # drop everything after the impt section
    drop(segment, 1) .|> to_int_sequence                   # keep only numeric data as vectors of ints
end

function offset_value(value, codes)
    offset = value - codes[2]
    in_range = 0 <= offset < codes[3] 
    in_range && return codes[1] + offset
    return value
end

function to_mapped_value(value, maps)
    possible_values = map(m -> offset_value(value, m), maps) |> unique
    length(possible_values) == 1 && return value      # return value if untransformed
    return filter(!=(value), possible_values) |> only # otherwise assume a unique transform
end

function find_location(seed, input)
    # this could be recursive but we are trying
    categories = ["soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]
    # for each category, create a lambda of some input value
    # first, a fn that turns a category into (input-value -> value-in-category)
    to_value_in_category = cat -> value -> to_mapped_value(value, clean_sequences(cat, input))
    # a list of fns that do this for every category
    mappers = map(to_value_in_category, categories)
    # a fn that blasts you through all categories
    to_location = reduce(∘, reverse(mappers))
    # evaluate it on an initial seed
    to_location(seed)
end
find_location(13, input)

function part1(input)
    seeds = parse_seeds(input)
    locs = map(s -> find_location(s, input), seeds)
    return minimum(locs)
end

@assert part1(readlines("data/05/test.txt")) == 35
part1(readlines("data/05/final.txt"))


#================#
#=    part 2    =#
#================#

function parse_seed_ranges(input)
    nums = parse_seeds(input)
    grps = partition(nums, 2)
    make_range = g -> range(g[1], length = g[2])
    map(make_range, grps)
end
parse_seed_ranges(input)

function part2(input)
    seeds = parse_seed_ranges(input) |> Iterators.flatten |> unique
    locs = map(s -> find_location(s, input), seeds)
    minimum(locs)
end

@assert part2(readlines("data/05/test.txt")) == 46

@time part2(readlines("data/05/final.txt"))




