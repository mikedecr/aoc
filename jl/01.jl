#==============#
#=    funx    =#
#==============#

function negate(f::Function)
    (a...) -> !f(a...)
end

function reverse_dict(d::AbstractDict)
    Dict(zip(values(d), keys(d)))
end

# ----- dictionary transducers ----------

function valfilter(fn::Function, d::Dict)
    Dict(k => v for (k, v) in d if fn(v))
end

function keyfilter(fn::Function, d::Dict)
    Dict(k => v for (k, v) in d if fn(k))
end

function valmap(fn::Function, d::Dict)
    Dict(k => fn(v) for (k, v) in d)
end

function keymap(fn::Function, d::Dict)
    Dict(fn(k) => v for (k, v) in d)
end


#================#
#=    part 1    =#
#================#

# filter the digits out of a string
numbers(line::AbstractString) = filter(isdigit, collect(line))
# COULD have done this with juxt(first, last) but we're trying to be "readable" ugh
first_last(v::Vector) = [first(v), last(v)]
as_integer(s::AbstractString) = parse(Int, s) 

function part1(input)
    # fn of one line, then apply over lines
    first_last_numbers = line -> line |>
        numbers |>
        first_last |>
        String |>
        as_integer
    first_last_numbers.(input) |> sum
end

@assert part1(readlines("data/01/test.txt")) == 142

#================#
#=    part 2    =#
#================#

word_map = let 
    word_digits = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    char_digits = only.(collect.(string.(1:9)))
    Dict(zip(word_digits, char_digits))
end

# vector of all substrings that we are looking for
all_needles = vcat(keys(word_map)..., values(word_map)...)

# first index of every occurrence of needle in haystack
function begin_indices(needle, haystack)
    ranges = findall(needle, haystack)
    return map(first, ranges)
end 

function part2(input::Vector{String})
    # dict of {str: first index}
    substr_to_begins = line -> line |>
        (x -> Dict(zip(all_needles, begin_indices.(all_needles, x)))) |>
        (x -> valfilter(negate(isempty), x))
    first_number = d -> d |>
        reverse_dict |>
        (d -> keymap(minimum, d)) |>
        (d -> keyfilter(k -> k == minimum(keys(d)), d)) |>
        (convert_number ∘ only ∘ values)
    last_number = d -> d |>
        reverse_dict |>
        (d -> keymap(maximum, d)) |>
        (d -> keyfilter(k -> k == maximum(keys(d)), d)) |>
        (convert_number ∘ only ∘ values)
    get_first_and_last = x -> [first_number(x), last_number(x)]
    f = as_integer ∘ String ∘ get_first_and_last ∘ substr_to_begins
    sum(map(f, input))
end

# convert words to numbers (for constructing the code)
function convert_number(word::String)
    @assert word in keys(word_map)
    return word_map[word]
end
# for a char the method is idempotent
function convert_number(c::Char)
    @assert c in values(word_map)
    return c
end

@assert part2(readlines("data/01/test2.txt")) == 281

#==============#
#=    main    =#
#==============#

input = readlines("data/01/final.txt")
println("Part 1 " * string(part1(input)))
println("Part 2: " * string(part2(input)))

