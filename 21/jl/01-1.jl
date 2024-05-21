# --------------------------------
#  Day 1: Sonar Sweep
# --------------------------------

# --- data ---

using DelimitedFiles
depths = vec(readdlm("data/01.txt", Int))


# --- pt. 1 ---

increases = diff(depths) .> 0
sum(increases)


# --- pt. 2 ---

using RollingFunctions

roll_depths    = rolling(sum, depths, 3)
roll_increases = diff(roll_depths) .> 0
sum(roll_increases)


# --- refactor ---

function positive_diffs(x)
    diff(x) .> 0
end

sum(positive_diffs(depths))
sum(positive_diffs(roll_depths))
