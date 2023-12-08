
# function sum_line_parts(line, above, below)
#     numbers = filter(str -> !isempty(str) && first(str) ∈ range('0', '9'), split(line, "."))
#     for n in numbers
#         ranges = findall(n, line)
#         println(n * " at " * string(ranges))
#         searches = map(r -> safely_expand_range(r, 1, length(line)), ranges)
#         for src in searches
#             any(l -> contains_symbol(l[src]), line, above, below)
#         end
#         println("search in " * string(searches))
#         result = all(c in [range('0', '9')..., '.'] for src in searches for c in src )
#         println(result)
#     end
#     # ranges = vcat(findall.(numbers, line)...)
#     # println(ranges)
#     # search_here = map(r -> safely_expand_range(r, 1, length(line)), ranges)
#     # println(search_here)
# end

not(f) = (a...) -> f(a...) == false
nonempty = not(isempty)
keep_digits(input) = filter(isdigit, input)

function is_symbol(c)
    nums = range('0', '9')
    !(only(c) in vcat(nums..., '.', ' '))
end

function contains_symbol(str)
    any(map(is_symbol, str))
end

function safely_expand_range(range, min, max)
    lower = maximum([first(range) - 1, min])
    upper = minimum([last(range) + 1, max])
    return lower:upper
end

function sum_line_parts(line, above, below)
    locations = findall(r"\d+", line)
    scores = [score_location(l, line, above, below) for l in locations]
    sum(scores)
end
# sum_line_parts(input[1], input[2], input[2])

function score_location(location, current, above, below)
    search = safely_expand_range(location, 1, length(current))
    for line in [above, below, current]
        chars = collect(line[search])
        if contains_symbol(chars)
            # println("found " * String(chars))
            return parse(Int, current[location])
        # contains_symbol(chars) && return parse(Int, current[location])
        end
    end
    # println(current[location])
    return 0
end

function part1(file)
    lines = readlines(file)
    empty = repeat(".", length(first(lines)))
    sum = 0
    for (i, l) in enumerate(lines)
        if i == 1
            sum += sum_line_parts(l, empty, lines[i + 1])
        elseif i == length(lines)
            sum += sum_line_parts(l, lines[i - 1], empty)
        else
            sum += sum_line_parts(l, lines[i - 1], lines[i + 1])
        end
    end
    return sum
end

@assert part1("data/03/test.txt") == 4361
println("Part 1: " * string(part1("data/03/final.txt")))


