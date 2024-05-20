import Base: +


struct Point
    x::Int
    y::Int
end


function +(a::Point, b::Point)::Point
    return Point(a.x + b.x, a.y + b.y)
end


function part_one(filepath::String)::Int
    file = read(file)
end

