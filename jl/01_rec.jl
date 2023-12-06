file = "data/01/final.txt"

#================#
#=    part 1    =#
#================#

# recursive style
# step through a file iterator
# at each step, get the sum of first and last digits in the line
# add the sum to the recursive call on the next line
# terminate by returning 0 (identity) when the next line is nothing
function sum_calibration_chars(file_iter::Base.EachLine{IOStream})::Int
    line = iterate(file_iter)
    if line === nothing
        return 0
    end
    digits = filter(isdigit, first(line))
    as_string = first(digits) * last(digits)
    as_number = parse(Int, as_string)
    return as_number + sum_calibration_chars(file_iter)
end

function part1(file::String)::Int
    iterator = eachline(file)
    sum_calibration_chars(iterator)
end

@assert part1("data/01/test.txt") == 142


#================#
#=    part 2    =#
#================#

# sshh just let me do this
rest(a) = last(a, length(a) - 1)

# okay this is way better.
# this function recurses down a string, each time looking for the first matching pattern
# we know the patterns are exclusive
function find_first_pattern(word, patterns)
    matches = filter(p -> startswith(word, p), patterns)
    if isempty(matches)
        return find_first_pattern(rest(word), patterns)
    end
    return only(matches)
end

number_words = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
number_chars = range('1', '9')
needles = vcat(number_words..., string.(number_chars)...)

function convert_word(input)
    d = Dict(zip(number_words, number_chars))
    if (length(input) == 1) && (only(input) ∈ values(d))
        return only(input)
    else
        return only(d[input])
    end
end

# we use these to walk fwd down the string and "backward" down the reversed string
# looking for matches forward and then backward, hell yeah B|

function sum_calibration_chars_and_words(file_iter)
    line_item = iterate(file_iter)
    if isnothing(line_item)
        return 0
    end
    line = first(line_item)
    # walk down the line, look for matches
    first_match = find_first_pattern(line, needles)
    # walk "up" the reversed line for reversed matches, reverse the detected match
    last_match = let
        # taking advantage of let block to contain clutter
        each_needle_reversed = reverse.(string.(needles))
        each_line_reversed = reverse(line)
        reversed_last_match = find_first_pattern(each_line_reversed, each_needle_reversed)
        reverse(reversed_last_match)
    end
    # matches -> ensure chars -> one string -> int
    s = String(convert_word.([first_match, last_match]))
    n = parse(Int, s)
    n + sum_calibration_chars_and_words(file_iter)
end

function part2(file)
    iterator = eachline(file)
    sum_calibration_chars_and_words(iterator)
end

@assert part2("data/01/test2.txt") == 281

file = "data/01/final.txt"
println(part1(file))
println(part2(file))


