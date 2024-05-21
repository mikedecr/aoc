file = ARGS[1]

raw = readlines(file)

function partition_by(λ, a::Vector)
    first, last = firstindex(a), lastindex(a)
    splits = [first-1; findall(λ, a); last]
    s1, s2 = @view(splits[1:end-1]), @view(splits[2:end])
    return [view(a, i1+1:i2) for (i1, i2) in zip(s1, s2)]
end



# function partition_by(fn::Function, lst::AbstractVector)
#     matches = findall(fn, lst)
#     for m in matches
#         sub = 
#     end
#     # result = Vector()
#     # current = Vector()
#     # for x in lst
#     #     if fn(x)
#     #         result = vcat(result, [current])
#     #         current = []
#     #     else
#     #         current = vcat(current, [x])
#     #     end
#     #     println(current)
#     # end
#     # return result
# end

partition_by(==(""), raw)

function partition_by(fn::Function, lst::Vector{String})
    if length(lst) == 0
        return
    elseif fn(first(lst))
        println("matched")
        return partition_by(fn, last(lst, length(lst) - 1))
    else
        println("neutral")
        return vcat(first(lst), partition_by(fn, rest(lst)))
    end
end

test = last(raw, length(raw) - 3)



findall(==(""), raw)

split_by(==(""), reverse(raw))

partition_by(==(""), test)



