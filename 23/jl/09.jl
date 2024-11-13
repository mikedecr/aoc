function convert_line(line::String)::Vector{Int}
    line |> split .|> (s -> parse(Int, s))
end

#===============#
#=    first    =#
#===============#

function extend_history(hist::Vector{Int})::Int
    dh::Vector{Int} = diff(hist)
    if dh == zeros(length(dh))
        return last(hist)
    end
    return last(hist) + last(extend_history(dh))
end

function part_one(input::Vector{String})::Int
    histories::Vector{Vector{Int}} = convert_line.(input)
    return sum(extend_history.(histories))
end

@assert part_one(readlines("23/data/09/test.txt")) == 114
println("Part 1: ", part_one(readlines("23/data/09/final.txt")))

#================#
#=    second    =#
#================#

function part_two(input::Vector{String})
    histories::Vector{Vector{Int}} = convert_line.(input)
    return sum(extrapolate_backwards.(histories))
end

function extrapolate_backwards(hist::Vector{Int})
    dh = diff(hist)
    if dh == zeros(length(dh))
        return first(hist)
    end
    return first(hist) - first(extrapolate_backwards(dh))
end

@assert part_two(readlines("data/09/test.txt")) == 2
println("Part 2: ", part_two(readlines("data/09/final.txt")))

