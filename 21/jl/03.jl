using DelimitedFiles
using StatsBase
using Pipe

# matrix of strings
report_raw = readdlm("data/03.txt", String) 
# report_raw = readdlm("data/03_test.txt", String) 

# convert to matrix of single chars
report = let A = report_raw
    A = collect.(A)               # explode string to chars
    A = reshape(vcat(A...), :, length(A))  # matrix of chars BY COLUMN
    permutedims(A)
end

# --- pt 1 ---

modes = map(mode, eachcol(report))
anti_modes = map(bitchar -> Dict('0' => '1', '1' => '0')[bitchar], 
                 modes)
modes_as_string = map(String, [modes, anti_modes])
# bits to ints (Julia greek compatibility, baybee)
γ, ε = parse.(Int, modes_as_string, base=2)

answer_1 = prod([γ, ε])


# --- pt 2 ---

function compound_rating(readout, compound)
    subreadout = readout
    ncols = size(subreadout)[2]
    jj = 1
    while size(subreadout)[1] > 1
        repcol = subreadout[:, jj]
        if compound == "oxygen" 
            keeps = repcol .== tiebreak_mode(repcol)
        elseif compound == "co2"
            keeps = repcol .!= tiebreak_mode(repcol)
        end
        subreadout = subreadout[keeps, :]
        # resolve indexing
        jj +=1 
        jj = jj <= ncols ? jj : 1
    end
    return parse(Int, subreadout |> vec |> String, base=2)
end

prod([compound_rating(report, "oxygen") compound_rating(report, "co2")])

