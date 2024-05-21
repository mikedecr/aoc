using Lazy: splitby

data = readlines(ARGS[1])

x = splitby(==(""), data)

cumsum(map(==(""), data))

function split_data(x)
    conds = map(==(""), x)
    grp = map(Bool, cumsum(conds))
    [x[grp .== a] for a in unique(grp)]
    # [x[grp == a] for a in unique(grp)]
end
crates, moves = split_data(data)

vcat(map(s -> [x for x in s], crates))
keep_ix = findall(x -> x ∈ '1':'9', last(crates))

tight = map(v -> v[keep_ix], crates)

for i in eachindex(first(tight))

end



['a' 'b'
 'c' 'd']

[a for a in "Hello"]


println(last(x))

for i in last(x)
    println(i)
end


