file = "data/01/final.txt"

# recursive style
# step through a file iterator
# at each step, get the sum of first and last digits in the line
# add the sum to the recursive call on the next line
# terminate by returning 0 (identity) when the next line is nothing
function sum_numbers(file_iter::Base.EachLine{IOStream})::Int
    line = iterate(file_iter)
    if line === nothing
        return 0
    end
    digits = filter(isdigit, first(line))
    as_string = first(digits) * last(digits)
    as_number = parse(Int, as_string)
    return as_number + sum_numbers(file_iter)
end

function part1(file::String)::Int
    iterator = eachline(file)
    sum_numbers(iterator)
end

@assert part1("data/01/test.txt") == 142

part1(file)


function sum_numbers_and_words(file_iter, needles)
    line = iterate(file_iter)
    if line === nothing
        return 0
    end
    # min of findfirst
    firsts = Dict(minimum(k) => convert_word(v)
                  for (k, v) in [(findfirst(n, first(line)), n) for n in needles]
                  if k !== nothing)
    # min of findlast
    lasts = Dict(minimum(k) => convert_word(v)
                  for (k, v) in [(findlast(n, first(line)), n) for n in needles]
                  if k !== nothing)
    # first appearing value
    first_num = firsts[minimum(keys(firsts))]
    # last appearing value
    last_num = lasts[maximum(keys(lasts))]
    # as one number
    number = parse(Int, string(first_num) * string(last_num))
    return number + sum_numbers_and_words(file_iter, needles)
end

needles = let
    words = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    vcat(words..., range('1', '9'))
end

function convert_word(input)
    words = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    nums = range('1', '9')
    d = Dict(zip(words, nums))
    if input ∈ values(d)
        out = parse(Int, input)
    else
        out = parse(Int, d[input])
    end
    return out
end

function part2(file)
    iterator = eachline(file)
    sum_numbers_and_words(iterator, needles)
end

@assert part2("data/01/test2.txt") == 281

file = "data/01/final.txt"
println(part1(file))
println(part2(file))


