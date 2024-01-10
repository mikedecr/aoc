using Base.Iterators: peel
using Chain

#===================#
#=    card type    =#
#===================#

struct Card
    winners::Vector{String}
    held::Vector{String}
end

function parse_card(text::String)
    wins, held = @chain text begin
        split(": ")
        getindex(2)
        split("|")
        split.()
    end
    Card(wins, held)
end

#===============#
#=    first    =#
#===============#

function n_matches(card::Card)::Int
    filter(x -> x in card.winners, card.held) |> length
end

function score_matches(n::Int)::Int
    n == 0 && return 0
    return 2^(n - 1)
end

function part_one(file::String)
    score_line = l -> l |> parse_card |> n_matches |> score_matches
    file |> eachline .|> score_line |> sum
end

@assert part_one("data/04/test.txt") == 13
println(part_one("data/04/final.txt"))


#================#
#=    second    =#
#================#

test = "data/04/test.txt"
final =  "data/04/final.txt"
test |> readlines |> first |> parse_card |> n_matches

# this is kinda hacky but whatever
function increment_coefs(coefs, i, n)
    i == 0 && return(coefs)
    r = range(1, n) .+ i
    multiple = coefs[i]
    coefs[r] = coefs[r] .+ multiple
    return coefs
end

function part_two(filename::String)
    cards = readlines(filename) .|> parse_card
    coefs = repeat([1], length(cards))
    for (i, c) in enumerate(cards)
        n = n_matches(c)
        coefs = increment_coefs(coefs, i, n)
    end
    return sum(coefs)
end

@assert part_two(test) == 30
println(part_two(final))

