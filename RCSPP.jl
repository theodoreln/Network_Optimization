### Resource Constrained Shortest Path Problem ###

### Definition of EURONET ###

# Dictionnary of nodes and related number
D = Dict("A" => Dict("num" => 1, "next" => Dict("B" => [1, 4], "F" => [5, 1])),
    "B" => Dict("num" => 2, "next" => Dict("C" => [1, 5], "D" => [3, 5], "F" => [2, 4])),
    "C" => Dict("num" => 3, "next" => Dict("F" => [3, 6])),
    "D" => Dict("num" => 4, "next" => Dict("A" => [4, 1], "E" => [8, 3])),
    "E" => Dict("num" => 5, "next" => Dict("A" => [2, 5], "B" => [1, 4])),
    "F" => Dict("num" => 6, "next" => Dict("C" => [5, 2], "E" => [7, 3])))
E = Dict(1 => "A", 2 => "B", 3 => "C", 4 => "D", 5 => "E", 6 => "F")
# Number of nodes 
n = length(D)
# Departure node
r = "D"
# Objective node
s = "F"
# Limited stops
T = 5

### Algorithm ###

# Creation of the table d and p 
d = fill(Inf, n, T)
p = E = Matrix{Int}(undef, n, T)
# Initialization
d[D[r]["num"], :] .= 0
p[D[r]["num"], :] .= D[r]["num"]

# Loop for iteration
for k in 1:T-1
    println(k)
    for (key_i, dict_i) in D
        i = dict_i["num"]
        for (key_j, list_j) in dict_i["next"]
            j = D[key_j]["num"]
            cij = list_j[1]
            println(i, j, cij)
            println(d[i, k] + cij, " ", d[j, k])
            if d[i, k] + cij < d[j, k]
                d[j, k+1] = d[i, k] + cij
                p[j, k+1] = i
            else
                if d[j, k+1] > d[j, k]
                    d[j, k+1] = d[j, k]
                    p[j, k+1] = p[j, k]
                end
            end
            println(d)
        end
    end
end

# Return the optimal solution
println("The shortest path to ", s, " is of length : ", d[D[s]["num"], T])
print(p)