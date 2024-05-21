
data = readlines(ARGS[1])

parse_grid(lines::Vector{String}) = map(x::String -> [s for s in x], lines)

g = permutedims(hcat(parse_grid(data)...))

ending = only(findall(==('E'), g))
start = only(findall(==('S'), g))

function surrounding_indices(index::CartesianIndex)
    surrounds = []
    x, y = index[1], index[2]
    for h in [-1 0 1]
        for v in [-1 0 1]
            nx = x + h
            ny = y + v
            bounds_okay = nx >= 1 & ny >= 1
            new_pt = (x != nx) || (y != ny)
            bounds_okay && new_pt && push!(surrounds, CartesianIndex(nx, ny))
        end
    end
    return surrounds
end
surrounding_indices(ending)

# don't think we want this
function surrounding_letters(index::CartesianIndex, grid::Matrix)
    inds = surrounding_indices(index)
    map(i -> grid[i], inds)
end

cur = ending
for c in range('z', 'a', -1)
end

fin = nothing
counter = 0
chr = Int('a') - 1
standing = Dict(start => chr)
while isnothing(fin)
    counter = counter + 1
    inds = surrounding_indices()
    for n in 
        
    end
end

# do this depth first...
# for each ix, keep a set of ix to check next, increment counter

