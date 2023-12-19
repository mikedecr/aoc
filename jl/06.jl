using Chain

#================#
#=    part 1    =#
#================#

function all_hold_times(time)
    [t for t in range(1, time)]
end

function isolate_values(string)
    [e for e in split(string, " ") if e != ""]
end

function extract_field(field_name, input::Vector{String})
    match = [s for s in input if startswith(s, field_name)] |> only
    nontrivials = isolate_values(split(match, ":")[2])
    return [parse(Int, s) for s in nontrivials]
end

function num_winning_holds(time, record)
    holds = all_hold_times(time)
    lower_winners = [h for h in holds if distance_moved(time, h) > record]
    length(lower_winners)
end

function distance_moved(time, held)
    speed = held
    moving = (time - held)
    return moving * speed
end


function part1(input::Vector{String})
    times = extract_field("Time", input)
    distances = extract_field("Distance", input)
    ways = [num_winning_holds(t, d) for (t, d) in zip(times, distances)]
    prod(ways)
end

#==================#
#=    2nd part    =#
#==================#

function extract_collapsed_field(field_name, input)
    match = [s for s in input if startswith(s, field_name)] |> only
    s = replace(split(match, ":")[2], " " => "")
    parse(Int, s)
end

function part2(input::Vector{String})
    times = extract_collapsed_field("Time", input)
    distances = extract_collapsed_field("Distance", input)
    ways = [num_winning_holds(t, d) for (t, d) in zip(times, distances)]
    prod(ways)
end


@assert part1(readlines("data/06/test.txt")) == 288
part1(readlines("data/06/final.txt"))

@assert part2(readlines("data/06/test.txt")) == 71503
part2(readlines("data/06/final.txt"))

