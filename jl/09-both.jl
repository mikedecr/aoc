using Memoize

function convert_line(line::String)::Vector{Int}
    map(c -> parse(Int, c), split(line))
end

# double-sided extrapolation
@memoize function extrapolate_history(x::Vector{Int})::Tuple{Int, Int}
    dx::Vector{Int} = diff(x)
    if dx == zeros(length(dx))
        return first(x), last(x)
    else
        f, l = extrapolate_history(dx)
        return first(x) - f, last(x) + l
    end
end

# part one gets the "last" element of the extrapolation
function part_one(input::Vector{String})::Int
    histories = convert_line.(input)
    extraps = extrapolate_history.(histories)
    map(last, extraps) |> sum
end

# part two gets the "first" element of the extrapolation
function part_two(input::Vector{String})::Int
    histories = convert_line.(input)
    extraps = extrapolate_history.(histories)
    map(first, extraps) |> sum
end

@assert part_one(readlines("data/09/test.txt")) == 114
println("Part 1: ", part_one(readlines("data/09/final.txt")))

@assert part_two(readlines("data/09/test.txt")) == 2
println("Part 2: ", part_two(readlines("data/09/final.txt")))

