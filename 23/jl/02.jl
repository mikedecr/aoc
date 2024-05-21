# ----- parse game data ----------

function structure_game_input(line::String)
    game, draws = split(line, ": ")
    game_no::Int = game_number(game)
    set_draws::Vector{Dict} = parse_handfull.(divide_handfulls(draws))
    Dict(game_no => set_draws)
end

function game_number(header::AbstractString)
    substr = match(r"Game [0-9]*", header).match
    digits = filter(isdigit, substr)
    parse(Int, digits)
end

# array of "handfulls"
function divide_handfulls(game_draws::AbstractString)::Vector{AbstractString}
    split(game_draws, "; ")
end

# array of handfulls -> Dict of 
function parse_handfull(cube_set::AbstractString)
    Dict(n_color.(split(cube_set, ", ")))
end

# string of "n color"
function n_color(one_color_string::AbstractString)
    num, color = split(one_color_string, " ")
    color => parse(Int, num)
end

#================#
#=    part 1    =#
#================#

function part1(input)
    # we screwed up early by making this a list of dicts instead of one dict
    games = structure_game_input.(input)
    passing_games = let
        constraints = Dict("red" => 12, "green" => 13, "blue" => 14)
        [g for g in games if game_meets_constraints(only(values(g)), constraints)]
    end
    passing_keys = [only(keys(g)) for g in passing_games]
    sum(passing_keys)
end

function handfull_meets_constraints(handfull::Dict, constraints::Dict)
    all(n <= constraints[color] for (color, n) in handfull)
end

function game_meets_constraints(game::AbstractArray{Dict}, constraints::Dict)
    all(handfull_meets_constraints(g, constraints) for g in game)
end

test = readlines("data/02/test.txt")
@assert part1(test) == 8

#================#
#=    part 2    =#
#================#

function part2(input::Vector{String})
    games = structure_game_input.(input)
    f = prod ∘ values ∘ minimal_colors ∘ only ∘ values
    f.(games) |> sum
end

function minimal_colors(set_of_handfulls::Vector{Dict})
    min_colors = Dict("red" => 0, "green" => 0, "blue" => 0)
    for hf in set_of_handfulls
        for col in keys(min_colors)
            min_colors[col] = maximum([min_colors[col], get(hf, col, 0)])
        end
    end
    return min_colors # cols = get_for_color.(set_of_handfulls)
end

@assert part2(test) == 2286


#==============#
#=    main    =#
#==============#

input = readlines("data/02/final.txt")
println("Part 1: " * (part1(input) |> string))
println("Part 2: " * (part2(input) |> string))

