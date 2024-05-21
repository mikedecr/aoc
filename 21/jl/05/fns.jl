function parse_vent_lines(line)
    pairs = split(line, " -> ") # two-vector of (start,end)
    pairs = split.(pairs, ",")  # point -> (x, y)
	[parse.(Int, x) for x in pairs]
end

function is_horiz_or_vert_line(coords)
	start, fin = coords
	return (start[1] == fin[1]) | (start[2] == fin[2])
end

function grid_bounds(coords)

end

