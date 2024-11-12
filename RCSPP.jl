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
p = Matrix{Int}(undef, n, T)
# Initialization
d[D[r]["num"], 1] = 0

# Loop for iteration
for k in 1:T-1
    for (key_i, dict_i) in D
        i = dict_i["num"]
        for (key_j, list_j) in dict_i["next"]
            j = D[key_j]["num"]
            cij = list_j[1]
            if d[i, k] + cij < d[j, k+1]
                d[j, k+1] = d[i, k] + cij
                p[j, k+1] = i
            end
        end
    end
end

# Return the optimal solution
println(d)
println(p)

# Find the shortest path with T stops
function shortest_path_T(s, D, E)
    prev = p[D[s]["num"], T]

    L = [prev, D[s]["num"]]
    for k in (T-1):-1:1
        previous = p[prev, k]
        if previous == 0
            i = 1
        else
            pushfirst!(L, previous)
        end
        prev = previous
    end

    println("And it visits those nodes : ")
    for value in L
        print(E[value], "  ")
    end
end

dist_min_T = d[D[s]["num"], T]
println("The shortest path in ", T, " nodes to ", s, " is of length : ", dist_min_T)
shortest_path_T(s, D, E)
println(" ")

# Find the absolute shortesr path 
function shortest_path(s, D, E)
    dist_argmin = argmin(d[D[s]["num"], :])
    prev = p[D[s]["num"], dist_argmin]

    M = [prev, D[s]["num"]]
    for k in (dist_argmin-1):-1:(T-dist_argmin+1)
        previous = p[prev, k]
        pushfirst!(M, previous)
        prev = previous
    end

    println("And it visits those nodes : ")
    for value in M
        print(E[value], "  ")
    end
end

dist_min = minimum(d[D[s]["num"], :])
println("The shortest path to ", s, " is of length : ", dist_min)
shortest_path(s, D, E)

