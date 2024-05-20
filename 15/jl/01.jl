convert_floor = function(paren::Char)::Int8
    paren == '(' && return 1
    paren == ')' && return -1
end


function part_one(filepath::String)::Int
    file::IOStream = open(filepath, "r")
    floor::Int = 0
    while !eof(file)
        chr::Char = read(file, Char)
        floor += convert_floor(chr)
    end
    close(file)
    return floor
end


function part_two(filepath)
    file::IOStream = open(filepath, "r")
    floor::Int = 0
    pos::UInt = 1
    while !eof(file)
        chr::Char = read(file, Char)
        floor += convert_floor(chr)
        floor < 0 && return pos
        pos += 1
    end
    close(file)
    return result
end


# main
path = "data/01-final.txt"
print("Part 1: " * string(part_one(path)))
print("Part 2: " * string(part_two(path)))
