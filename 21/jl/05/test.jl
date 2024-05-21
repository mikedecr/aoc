# test space for fns.jl
include("src/05/fns.jl")

raw = readlines("data/05_test.txt")

coords = parse_vent_lines.(raw)

# -- create a grid --
# 1. abstract all coords into pts
pts = collect(Iterators.flatten(coords))
let x = [p[1] for p in pts], y = [p[2] for p in pts]
	global x_bounds = minimum(x), maximum(x)
	global y_bounds = minimum(y), maximum(y)
end
# 2. grid itself?
x_bounds
y_bounds


straights = coords[is_horiz_or_vert_line.(coords)]

