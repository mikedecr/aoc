function parse_dimensions(input::String)::Vector{Int}
    parse.(Int, split(input, 'x'))
end


function compute_face_areas(length::Int, width::Int, height::Int)::Vector{Int}
    [length * width, length * height, width * height]
end


function required_paper(length::Int, width::Int, height::Int)::Int
    faces::Vector{Int} = compute_face_areas(length, width, height)
    return sum(2 * faces) + minimum(faces)
end


function shortest_perimeter(length::Int, width::Int, height::Int)::Int
    ordered_sides = sort([length, width, height])
    shortest = Base.Iterators.take(ordered_sides, 2) 
    sum(2 .* shortest)
end


function required_ribbon(length::Int, width::Int, height::Int)::Int
    (length * width * height) + shortest_perimeter(length, width, height)
end


function part_one(path::String)::Int
    reduce(+, map(line -> required_paper(parse_dimensions(line)...), eachline(path)))
end


function part_two(path::String)::Int
    reduce(+, map(line -> required_ribbon(parse_dimensions(line)...), eachline(path)))
end


# main
path = "data/02-final.txt"
print("part 1: " * string(part_one(path)))
print("part 2: " * string(part_two(path)))

