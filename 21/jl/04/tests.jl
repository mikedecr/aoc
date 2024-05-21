include("src/04/fns.jl")


# --- instantiate test data ---

# make a card
multiplier = [1 2 7 5 3] 
base = [1 2 3 4 5
        1 2 3 4 5
        1 2 3 4 5
        1 2 3 4 5
        1 2 3 4 5]
card = multiplier .* base
 
row_draws = card[1, :]
col_draws = card[:, 1]
false_draws = [0]

# --- check single axis ---

# horizontal axis
@assert is_axis_bingo(card[1, :], row_draws) == true
@assert is_axis_bingo(card[1, :], false_draws) == false
# vertical axis
@assert is_axis_bingo(card[:, 1], col_draws) == true
@assert is_axis_bingo(card[:, 1], false_draws) == false
# diagonals don't count


# --- check entire card ---

@assert is_card_bingo(card, row_draws)
@assert is_card_bingo(card, col_draws)
@assert is_card_bingo(card, [3 6 9 12 15])
@assert is_card_bingo(card, false_draws) == false

# --- check set of cards ---
winning_cards([card], row_draws)
winning_cards([card, card], row_draws)

# --- play bingo game ---

queue = [false_draws; row_draws]
res = play_bingo([card, card], queue)
res[1]
res[2]


# --- test reading data ---

import DelimitedFiles as delim

raw = delim.readdlm("data/04_test.txt")

# grab first row, convert to Ints
using Pipe
queue = @pipe raw[1, :] |> 
    join(_) |>
    split(_, ',') |>
    [parse.(Int, x) for x in _]

boards_joined = raw[2:end, :]
boards = []
while length(boards_joined) > 0
    # extract matrix of first 5 rows
    local card_chunk = boards_joined[1:5, :]
    push!(boards, card_chunk)
    # delete first 5 rows from the remaining data
    boards_joined = boards_joined[setdiff(1:end, 1:5), :]
end

@assert length(boards) == 3

# --- do we get the example answer back? ---

winners, draws = play_bingo(boards, copy(queue))

@assert winners[1] == boards[3]
@assert winning_score(winners[1], draws) == 4512


# --- part 2 answer ---

Q = copy(queue)
B = copy(boards)

draws = []
while (length(Q) > 0) & (length(boards) > 0)
    print("queue is ", Q, '\n')
    print("draws are ", draws, '\n')
    winners, draws = play_bingo(boards, Q, draws)
    print("winners are ", [w for w in winners], '\n')
    for winner in winners
        deleteat!(boards, findall(x -> x == winner, boards))
    end
end

@assert winning_score(winners[1], draws) == 1924

