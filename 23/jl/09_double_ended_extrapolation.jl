# string containing ints -> Vector{Int}
# "14 57 98" -> [14, 57, 98]
function convert_line(line::String)::Vector{Int}
    line |> split .|> (s -> parse(Int, s))
end

# for some x, extrapolate both ends of the sequence
# return the first and last of extrapolated sequence
function extrapolate_history(x::Vector{Int})::Tuple{Int, Int}
    dx = diff(x)
    # bottom case terminates recursion
    # otherwise extrapolate current layer using lower layer info
    if dx == zeros(length(dx))
        return first(x), last(x)
    else
        f, l = extrapolate_history(dx)
        return first(x) - f, last(x) + l
    end
end

# part one cares about the last element of extended sequence
function part_one(input::Vector{String})::Int
    extraps = input .|> convert_line .|> extrapolate_history
    return extraps .|> last |> sum
end

# part two cares about the first element of extended sequence
function part_two(input::Vector{String})::Int
    extraps = input .|> convert_line .|> extrapolate_history
    return extraps .|> first |> sum
end

@assert part_one(readlines("data/09/test.txt")) == 114
println("Part 1: ", part_one(readlines("data/09/final.txt")))

@assert part_two(readlines("data/09/test.txt")) == 2
println("Part 2: ", part_two(readlines("data/09/final.txt")))

