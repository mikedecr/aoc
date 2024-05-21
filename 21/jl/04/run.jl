# implement day 4

include("src/04/fns.jl")
import DelimitedFiles as dlm
using Pipe

# --- format data ---
# 1 row of draws & a block of boards w/ no separations
raw = dlm.readdlm("data/04.txt")

# queue of draws from the top
queue = @pipe raw[1, :] |>
    join(_) |>
    split(_, ',') |>
    [parse.(Int, x) for x in _]

# chop remaining data into cards
stack = raw[2:end, :]
boards = []
# add top card to our set, delete from remaining stack
while length(stack) > 0
    push!(boards, stack[1:5, :])
    stack = stack[setdiff(1:end, 1:5), :]
end

# --- part 1: which card wins first ---

# the recursive fn mutates the queue, so use a copy
winners, draws = play_bingo(boards, copy(queue))
winning_score(winners[1], draws)

# --- part 2, which card wins last ---

# repeatedly play bingo, 
# pop winning cards from array until it's gone

# this mutates the set of cards, so we copy that as well
Q = copy(queue)
B = copy(boards)
# also have to initialize draws to pass them outside of fn scope
draws = []

# find final winnerby deleting winning cards from the set
while (length(Q) > 0) & (length(B) > 0)
    winners, draws = play_bingo(B, Q, draws)
    for card in winners
        deleteat!(B, findall(x -> x == card, B))
    end
end

winning_score(winners[1], draws)

