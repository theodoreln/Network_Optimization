# %% ITERATION 3
    # Add route x3[2]: DCA
    # Add route x3[3]: DBA

using JuMP, GLPK

# Create the model
model = Model(GLPK.Optimizer)

#LP solution
#=
@variable(model, 0 <= x1[1:3] <= 1, Int)  # x1[1], x1[2], x1[3], possible routes for commodity k=1, added one by one
@variable(model, 0 <= x2[1:3] <= 1, Int)  
@variable(model, 0 <= x3[1:3] <= 1, Int)
=#


# Decision variables
@variable(model, x1[1:3], Bin)  # Binary variables for x1[1], x1[2], x1[3]
@variable(model, x2[1:3], Bin)  # Binary variables for x2[1], x2[2], x2[3]
@variable(model, x3[1:3], Bin)  # Binary variables for x3[1], x3[2], x3[3]

# Objective function
@objective(model, Min, 14 * x1[1] + 30 * x2[1] + 90 * x3[1] + (90-35)*x3[2] + (90-35)*x3[3])

# Constraints
@constraint(model, con1, 3*x2[1] <= 4) # y_AB
# @constraint(model, con2,  <= 1) # y_AC
@constraint(model, con3, 5*x3[3] <= 9) # y_BA
@constraint(model, con4, 5*x3[1] <= 5) # y_BC
@constraint(model, con5, 3*x2[1] <= 3) # y_BD
@constraint(model, con6, 2*x1[1] + 5*x3[1] + 5*x3[2] <= 8) # y_CA
# @constraint(model, con7,  <= 6) # y_CB
# @constraint(model, con8,  <= 2) # y_CD
@constraint(model, con9, 5*x3[1] + 5*x3[3] <= 6) # y_DB
@constraint(model, con10, 3*x2[1] + 5*x3[2] <= 6) # y_DC

@constraint(model, y1, x1[1] == 1)                                     # Constraint (y_1)
@constraint(model, y2, x2[1] == 1)                                     # Constraint (y_2)
@constraint(model, y3, x3[1]+x3[2]+x3[3] == 1)                         # Constraint (y_3)

# Solve the model
optimize!(model)

# Print results
println("Objective value: ", objective_value(model))
for i in 1:3
    println("x1[$i] = ", value(x1[i]))
    println("x2[$i] = ", value(x1[i]))
    println("x3[$i] = ", value(x1[i]))
end

#Print dual values (not for integer solution)
#= 

# Print dual values of constraints y1, y2, y3
println("\nDual values for commodity constraints:")
println(dual(y1))
println(dual(y2))
println(dual(y3))



# Print dual values of constraints y_ij
println("\nDual values for edge capacities:")
println("y_AB: ", dual(con1))
# println("y_AC: ", dual(con2))  # Uncomment if con2 is defined
println("y_BA: ", dual(con3))  # Uncomment if con3 is defined
println("y_BC: ", dual(con4))
println("y_BD: ", dual(con5))
println("y_CA: ", dual(con6))
#println("y_CB: ", dual(con7))  # Uncomment if con7 is defined
#println("y_CD: ", dual(con8))  # Uncomment if con8 is defined
println("y_DB: ", dual(con9))
println("y_DC: ", dual(con10))

=#