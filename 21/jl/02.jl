#=================================
   Day 2: Dive!
=================================#

using DelimitedFiles
moves = readdlm("data/02.txt")

#=
linear view: dive = Dv
D is 2 x N mtx of "unit moves", e.g. "up" -> (-1, 0), "fwd" -> (0, 1)
v is coefs on each unit move

From data: dive is sum of "moves", each "move" a tuple (direction, value).
=#

direction_map = Dict(
    "up"       => [-1, 0],
    "down"     => [1, 0],
    "forward"  => [0, 1],
    "backward" => [0, -1]
)

pos = start_pos = [0, 0]
pos += sum([direction_map[dir] * value for (dir, value) in eachrow(moves)])
answer_1 = prod(pos)



# --- part 2 ---

# depth, fwd distance, aim

aim_map = Dict(
    "down" => 1,
    "up" => -1,
    "forward" => 0
)

direction_map = Dict(
    "up"       => [0, 0],
    "down"     => [0, 0],
    "forward"  => [1, 1]
    # can't infer backward from the example
)

pos = start_pos = [0, 0]
aim = 0

# at this point a linalg solution ceases to be readable
# but not sure this is much improvement =D 
for (dir, value) in eachrow(moves)
    aim += aim_map[dir] * value
    pos += (direction_map[dir] .* ([aim, 1] * value))
end

prod(pos)
