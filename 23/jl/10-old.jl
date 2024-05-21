
function s_location(input)
    y = findfirst(v -> 'S' ∈ v, input)
    x = findfirst(==('S'), input[y])
    return x, y
end

@enum Direction Up Down Left Right

# helper fn
function other(x, a, b)
    @assert x ∈ (a, b)
    x == a && return b
    return a
end

function next_direction(pipe::Shape, from::Direction)::Direction
    pipe == Vert && return other(from, Up, Down)
    pipe == Horiz && return other(from, Left, Right)
    pipe == L && return other(from, Up, Right)
    pipe == J && return other(from, Up, Left)
    pipe == Seven && return other(from, Left, Down)
    pipe == F && return other(from, Down, Right)
    @assert false
end

# probably could do this with some basis vector mapping where -> [dx, dy]
# and collapse this fn with next_direction Shape, Basis -> Basis
function next_coord(where::Direction, x::Int, y::Int)
    where == Up && return x, y + 1
    where == Down && return x, y - 1
    where == Left && return x - 1, y
    where == Right && return x + 1, y
end

next_direction(Horiz, Right)

function part_one(input)
    sx, sy = s_location(input)
    neighbors = neighbors(sx, sy, input)
    @assert length(neighbors) == 2
    nx, ny = first(neighbors)
end


#=========================#
#=    another attempt    =#
#=========================#

# rather than mess w/ CartesianIndex I will just make my own thing
struct Point
    x::Int
    y::Int
end
import Base.:+
(Base.:+)(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)

Point(2, 3) + Point(5, 6)


function find_next_shape(current, dxdy, field)
    next = current + dxdy
    shape = access(field, next)
    next_dxdy = redirect(shape, dxdy)
end

access(field, where::Point) = field[where.y][where.x]

@enum Shape Vert Horiz L J Seven F

function redirect(what::Char, how::Point)
    down = Point(0, -1)
    up = Point(0, 1)
    right = Point(1, 0)
    left = Point(-1, 0)
    @assert how ∈ [up, down, left, right]
    @assert what in ['|', '-', 'J', '7', 'L', 'F']
    # this is all fucked up
    # what == '|' && return other(how, up, down)
    # what == '-' && return other(how, left, right)
    # what == 'J' && return other(how, up, left)
    # what == '7' && return other(how, down, left)
    # what == 'L' && return other(how, up, right)
    # what == 'F' && return other(how, down, right)
    # @assert false
end

d = readlines("data/10/test.txt")
s_location(d)

redirect('F', Point(1, 0))

