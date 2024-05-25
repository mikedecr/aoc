import Base: +


# iterate over characters in a file
struct EachChar
    io::IO
end

function eachchar(file_path::String)
    io = open(file_path, "r")
    return EachChar(io)
end

Base.iterate(iter::EachChar, state=nothing) = eof(iter.io) ? nothing : (read(iter.io, Char), state)
Base.IteratorSize(::Type{EachChar}) = Base.IsInfinite()

# Point type

# struct Point
#     x::Int
#     y::Int
# end
#
#
# function +(a::Point, b::Point)::Point
#     return Point(a.x + b.x, a.y + b.y)
# end

Point = CartesianIndex

map_chars = Dict(
    '>' => Point(1, 0),
    '<' => Point(-1, 0),
    '^' => Point(0, 1),
    'v' => Point(0, -1),
    # null pt
    # '\n' => Point(0, 0)
)

function parse_offset(character::Char)::Union{Point, Nothing}
    get(map_chars, character, nothing)
end


function part_one(filepath::String)
    houses = []
    cur = Point(0, 0)
    for c in eachchar(filepath)
        if c == '\n' continue end
        cur = parse_offset(c) + cur
        push!(houses, cur)
    end
    return length(Set(houses))
end


function part_two(filepath::String)::Int
    line = readlines(filepath)[1]
    a = [Point(0, 0)]
    b = [Point(0, 0)]
    for ii in eachindex(line)
        p = parse_offset(line[ii])
        if ii % 2 == 1
            push!(a, a[length(a)] + p)
        else
            push!(b, b[length(b)] + p)
        end
    end
    return length(union(Set(a), Set(b)))
end


# main
path = "15/data/03-final.txt"
part_one(path)
part_two(path)
