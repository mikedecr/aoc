using StatsBase: countmap

function parse_hands(input::Vector{String})::Vector{ Vector{Face} }
    to_chars = line -> split(line, " ") |> first |> (s -> split(s, ""))
    values_to_face = s -> map(to_face, s)
    input .|> to_chars .|> values_to_face
end

function parse_bids(input::Vector{String})::Vector{Int}
    get_int = line -> split(line, " ") |> last |> (c -> parse(Int, c))
    get_int.(input)
end

@enum HandType begin
    HighCard
    OnePair
    TwoPair
    ThreeOfAKind
    FullHouse
    FourOfAKind
    FiveOfAKind
end

# the clever thing about this is we put Joker and J in the same enum
@enum Face Joker Two Three Four Five Six Seven Eight Nine T J Q K A

function to_face(value::Union{AbstractString, Char})::Face
    mapper = Dict('A' => A,
                  'K' => K,
                  'Q' => Q,
                  'J' => J,
                  'T' => T,
                  '9' => Nine,
                  '8' => Eight,
                  '7' => Seven,
                  '6' => Six,
                  '5' => Five,
                  '4' => Four,
                  '3' => Three,
                  '2' => Two,
                  'j' => Joker)
    return mapper[only(value)]
end

# move this outside of the ranking fn
function parse_hand_type(hand)::HandType
    card_counts = hand |> countmap |> values |> sort
    card_counts == [5] && return FiveOfAKind
    card_counts == [1, 4] && return FourOfAKind
    card_counts == [2, 3] && return FullHouse
    card_counts == [1, 1, 3] && return ThreeOfAKind
    card_counts == [1, 2, 2] && return TwoPair
    card_counts == [1, 1, 1, 2] && return OnePair
    return HighCard
end


function rank_hands(hands::Vector{ Vector{Face} }, ranker::Function)::Vector{Int}
    hand_to_type = Dict(h => ranker(h) for h in hands)
    sorted_hands::Vector{Vector{Face}} = []
    for type in sort(unique(values(hand_to_type)))
        hands_of_type = [h for (h, t) in hand_to_type if t == type]
        push!(sorted_hands, sort(hands_of_type)...)
    end
    [findfirst(==(h), sorted_hands) for h in hands]
end

function part_one(input::Vector{String})::Int
    hands, bids = parse_hands(input), parse_bids(input)
    ranks = rank_hands(hands, parse_hand_type) # fix argument
    only(hcat(ranks...) * hcat(bids))
end

@assert part_one(readlines("data/07/test.txt"))  == 6440

println(part_one(readlines("data/07/final.txt")))



#==================#
#=    snd part    =#
#==================#

# number of jokers matters
# grid of (current hand) x (n. jokers) up to 5 jokers...?
# there are some sufficiencies in that grid.

function convert_jokers(hand)
    [if (v == J) Joker else v end for v in hand]
end

function parse_jokerless_hand_type(hand)
    jokerless_hand = filter(!=(Joker), hand)
    # early return
    if jokerless_hand == hand 
        return parse_hand_type(hand)
    end
    n_jokers = sum(hand .== Joker)
    if n_jokers ∈ [4 5]
        return FiveOfAKind
    end
    jokerless_counts = jokerless_hand |> countmap |> values |> sort
    joker_best_hand_maps = Dict(
        1 => Dict([4] => FiveOfAKind,
                  [1, 3] => FourOfAKind, # skip FullHouse here
                  [2, 2] => FullHouse,
                  [1, 1, 2] => ThreeOfAKind, # skip TwoPair?
                  [1, 1, 1, 1] => OnePair),
        2 => Dict([3] => FiveOfAKind,
                  [1, 2] => FourOfAKind,
                  [1, 1, 1] => ThreeOfAKind),
        3 => Dict([2] => FiveOfAKind,
                  [1, 1] => FourOfAKind)
    )
    which_map = joker_best_hand_maps[n_jokers]
    return which_map[jokerless_counts]
end

function part_two(input)
    hands = parse_hands(input) .|> convert_jokers
    bids = parse_bids(input)
    ranks = rank_hands(hands, parse_jokerless_hand_type) # fix argument
    only(hcat(ranks...) * hcat(bids))
end

@assert part_two(readlines("data/07/test.txt")) == 5905
part_two(readlines("data/07/final.txt")) |> println

