# BINGO FUNCTIONS

"1. True if all axis values are among set of draws"
function is_axis_bingo(axis, draws)
    return all((value in draws) for value in axis)
end

"2. True if card contains at least one bingo axis"
function is_card_bingo(card, draws)
    iter_card_axes = Iterators.flatten([eachrow(card), eachcol(card)])
    bingos = map(axis -> is_axis_bingo(axis, draws), iter_card_axes)
    return any(bingos)
end

"3. Returns the (first) winning card from a set, else nothing"
function winning_cards(cards, draws)
	is_winner = map(card -> is_card_bingo(card, draws), cards)
    if any(is_winner)
	    return cards[is_winner]
	end
end

"4. Recursively play bingo until a card wins"
function play_bingo(cards, queue, draws = [])
    # pull a new number from the queue
	# & use it for a bingo round
    push!(draws, popfirst!(queue))
    winners = winning_cards(cards, draws)
	# if no winner yet, function calls itself :)
    if !isnothing(winners) 
		return winners, draws
	else
		play_bingo(cards, queue, draws)
	end
end

"calculate winning score according to the problem instructions"
function winning_score(card, pulls)
    unmatched = map(n -> n * !(n in pulls), card)
    return sum(unmatched) * last(pulls)
end

