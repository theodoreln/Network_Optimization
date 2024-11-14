using JuMP, Gurobi

# Graph parameters
n = 4
K = 3
U = [0 4 1 0;
    9 0 5 3;
    8 6 0 2;
    0 6 6 0]
C = [0 4 4 0;
    8 0 7 2;
    7 4 0 6;
    0 4 4 0]
d = [2 3 5]
s = [3 1 4]
t = [1 3 1]

# Dicts letters to numbers
let_to_numb = Dict("A" => 1, "B" => 2, "C" => 3, "D" => 4)
numb_to_let = Dict(1 => "A", 2 => "B", 3 => "C", 4 => "D")

# Model edge formulation
model_edge = Model(Gurobi.Optimizer)

@variable(model_edge, x[1:n, 1:n, 1:K], Bin)

@objective(model_edge, Min, sum(d[k] * sum(C[i, j] * x[i, j, k] for i = 1:n, j = 1:n) for k = 1:K))

@constraint(model_edge, [k = 1:K, j = 1:n; !(j in s) && !(j in t)], sum(x[i, j, k] for i = 1:n) - sum(x[j, i, k] for i = 1:n) == 0)
@constraint(model_edge, [k = 1:K], sum(x[i, s[k], k] for i = 1:n) - sum(x[s[k], i, k] for i = 1:n) == -1)
@constraint(model_edge, [k = 1:K], sum(x[i, t[k], k] for i = 1:n) - sum(x[t[k], i, k] for i = 1:n) == 1)
@constraint(model_edge, [i = 1:n, j = 1:n], sum(d[k] * x[i, j, k] for k = 1:K) <= U[i, j])

optimize!(model_edge)

println("Solution with edge formulation, binary : ")
println("Optimal Objective Value: $(objective_value(model_edge))")
println("Solution is: ")
for k = 1:K
    println("Path $k : $(JuMP.value.(x[:, :, k]))")
end

# LP relaxation of the edge formulation
relax_integrality(model_edge)
optimize!(model_edge)

println("Solution with edge formulation, LP relaxation : ")
println("Optimal Objective Value: $(objective_value(model_edge))")
println("Solution is: ")
for k = 1:K
    println("Path $k : $(JuMP.value.(x[:, :, k]))")
end

# Model path formulation
# Route dictionnary
R = Dict(1 => [[3, 1], [3, 2, 1], [3, 4, 2, 1]],
    2 => [[1, 2, 3], [1, 2, 4, 3]],
    3 => [[4, 2, 1], [4, 3, 1], [4, 2, 3, 1], [4, 3, 2, 1]])
nb_routes = Dict(1 => 3, 2 => 2, 3 => 4)
# Cost dictionnary
C_route = Dict(1 => [14, 24, 36], 2 => [33, 30], 3 => [60, 55, 90, 80])
# Let's compute a[k,r,i,j] for each route r in R[k] that is 1 if the path r goes through edge (i,j) and 0 otherwise
a = Dict{Int,Array{Array{Int,2},1}}()
for k in keys(R)
    a[k] = []
    for r in R[k]
        a_r = zeros(Int, n, n)
        for l in 1:(length(r)-1)
            i = r[l]
            j = r[l+1]
            a_r[i, j] = 1
        end
        push!(a[k], a_r)
    end
end

# Model path formulation
model_path = Model(Gurobi.Optimizer)

# Variables
@variable(model_path, x_1[1:nb_routes[1]], Bin)
@variable(model_path, x_2[1:nb_routes[2]], Bin)
@variable(model_path, x_3[1:nb_routes[3]], Bin)

# Objective
@objective(model_path, Min, sum(C_route[1][r] * x_1[r] for r = 1:nb_routes[1]) + sum(C_route[2][r] * x_2[r] for r = 1:nb_routes[2]) + sum(C_route[3][r] * x_3[r] for r = 1:nb_routes[3]))

# Constraints
@constraint(model_path, [i = 1:n, j = 1:n], sum(a[1][r][i, j] * x_1[r] * d[1] for r = 1:nb_routes[1]) + sum(a[2][r][i, j] * x_2[r] * d[2] for r = 1:nb_routes[2]) + sum(a[3][r][i, j] * x_3[r] * d[3] for r = 1:nb_routes[3]) <= U[i, j])
@constraint(model_path, sum(x_1[r] for r = 1:nb_routes[1]) == 1)
@constraint(model_path, sum(x_2[r] for r = 1:nb_routes[2]) == 1)
@constraint(model_path, sum(x_3[r] for r = 1:nb_routes[3]) == 1)

optimize!(model_path)

println("Solution with path formulation, binary : ")
println("Optimal Objective Value: $(objective_value(model_path))")
println("Solution is: ")
println("Path 1 : $(JuMP.value.(x_1))")
println("Path 2 : $(JuMP.value.(x_2))")
println("Path 3 : $(JuMP.value.(x_3))")

# LP relaxation of the path formulation
relax_integrality(model_path)
optimize!(model_path)
println("Solution with path formulation, LP relaxation : ")
println("Optimal Objective Value: $(objective_value(model_path))")
println("Solution is: ")
println("Path 1 : $(JuMP.value.(x_1))")
println("Path 2 : $(JuMP.value.(x_2))")
println("Path 3 : $(JuMP.value.(x_3))")
