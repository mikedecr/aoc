mapping = f::Function -> d -> map(f, d)

# data clean
parse_move = function(move::String)
    pair = split(move, " ")
    only(first(pair)), parse(Int, last(pair))
end

motions = map(function(x) Motion(x...) end, moves)

# ----- in case we want to use this Point type ----------

struct Motion
    direction::Char
    magnitude::Int
end

struct Point
    x::Int
    y::Int
end
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
Base.:-(a::Point, b::Point) = Point(a.x - b.x, a.y - b.y)

Point(0, 1) + Point(1, 0)
Point(0, 1) + Point(1, 0)

function basis(direction::Char) 
    Dict(
        'R' => Point( 1,  0),
        'L' => Point(-1,  0),
        'U' => Point( 0,  1),
        'D' => Point( 0, -1)
    )[direction]
end

basis_from_move = basis ∘ first

unit_move(start::Point, direction::Char) = begin
    start + basis(direction)
end

unit_move(Point(0, 0), first(first(moves)))

maybe_move_tail(new::Point, old::Point, tail::Point) = begin
    diff = new - tail
    # println(diff)
    if (abs(diff.x) >= 2) | (abs(diff.y) >= 2)
        return old
    else
        return tail
    end
end

maybe_move_tail(Point(2, 0), Point(1, 0), Point(0, 0))


execute_motion(head::Point, tail::Point, motion::Motion) = begin
    set_of_tails = Set()
    for i in 1:motion.magnitude
        union!(set_of_tails, [tail])
        old = head
        head = unit_move(head, motion.direction)
        tail = maybe_move_tail(head, old, tail)
        # println(head, tail)
        union!(set_of_tails, [tail])
    end
    return head, tail, set_of_tails
end

init = Point(0, 0)
execute_motion(init, init, first(motions))

part1(motions::Array{Motion}) = begin
    init = Point(0, 0)
    head = init
    tail = init
    all_tails = Set()
    for m in motions
        head, tail, tails = execute_motion(head, tail, m)
        union!(all_tails, tails)
        # println(head, tail)
        # println(all_tails)
    end
    return all_tails
end

part1(motions)


#================#
#=    part 2    =#
#================#

function long_motion(rope::Vector{Point}, motion::Motion) 
    all_tails = Set()
    for i in 1:motion.magnitude
        union!(all_tails, [last(rope)])
        head = unit_move(rope[1], motion.direction)
        new = [head]
        for j in 2:length(rope)
            knot = maybe_move_tail(new[j - 1], rope[j - 1], rope[j])
            println(knot)
            new = hcat(new, knot)
        end
        union!(all_tails, [last(new)])
        rope = new
    end
    return rope, all_tails
end

part2(motions::Array{Motion}) = begin
    init = Point(0, 0)
    rope = repeat([Point(0, 0)], 10)
    all_tails = Set()
    for m in motions
        rope, tails = long_motion(rope, m)
        union!(all_tails, tails)
        # println(head, tail)
        # println(all_tails)
    end
    return all_tails
end

long_motion(repeat([Point(0, 0)], 10), motions[3])

part2(motions)


#======================#
#=    ways forward    =#
#======================#

file = "data/09/final.txt"

# partial(f, a...) = (b...) -> f(a..., b...)
# compose = partial(reduce, ∘)
# compose([mapping(parse_move), readlines])()

ans_1 = (part1 ∘ mapping(t -> Motion(t...)) ∘ mapping(parse_move) ∘ readlines)(file)

reduce(∘, [mapping(parse_move), readlines])(file)

raw = readlines(file)
motions = (mapping(t -> Motion(t...)) ∘ mapping(parse_move) ∘ readlines)(file)


