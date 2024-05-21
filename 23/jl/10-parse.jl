using Functors: fmap

@enum Direction Up Down Left Right None
@enum Shape Start Vert Horiz L J Seven F Other


direction_map::Dict = Dict(
    Vert => Dict(Up => Down, Down => Up),
    Horiz => Dict(Left => Right, Right => Left),
    L => Dict(Down => Right, Left => Up),
    J => Dict(Right => Up, Down => Left),
    Seven => Dict(Right => Down, Up => Left),
    F => Dict(Up => Right, Left => Down)
)

function change_direction(dir::Direction, shape::Shape)
    direction_map[shape][dir]
end

coord_map = Dict(
    Up => CartesianIndex(0, 1),
    Down => CartesianIndex(0, -1),
    Left => CartesianIndex(-1, 0),
    Right => CartesianIndex(1, 0)
)

function next_coord(index, direction)
    index + coord_map[direction]
end

function access_element(grid, index)
    grid[index[2]][index[1]]
end

# function to take a step?
# step direction -> shape -> move direction

function shape_at(index, direction, grid)
    access_element(grid, next_coord(index, direction))
end

function parse_pipe(chr)::Shape
    matches = Dict(
        'S' => Start,
        '|' => Vert,
        '-' => Horiz,
        'L' => L,
        'J' => J,
        '7' => Seven,
        'F' => F
    )
    get(matches, chr, Other)
end

function format_input(input)
    fmap(parse_pipe, input .|> collect)
end

function part_one(input)
    grid = format_input(input)
    s_index = start_index(grid)
end

function take_step(index, grid)
    next_coord(index, Up)
end

function start_index(grid)
    y = findfirst(v -> Start ∈ v, grid)
    x = findfirst(==(Start), grid[y])
    CartesianIndex(x, y)
end

index, direction

start_index(format_input(d))

d = readlines("data/10/test.txt")

format_input(d)

