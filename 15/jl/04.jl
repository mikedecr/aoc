using MD5

function find_prefix_in_md5_hash(key::String, pfx::String)::Int
    encode = bytes2hex ∘ md5
    n = -1
    found = false
    while !found
        n += 1
        h = encode(key * string(n))
        startswith(h, pfx) && return n
    end
end


key = "yzbqklnj" 

print(find_prefix_in_md5_hash(key, "00000"))
print(find_prefix_in_md5_hash(key, "000000"))

