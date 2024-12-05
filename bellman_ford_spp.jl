using Printf

# Function to implement the Bellman-Ford algorithm
function bellman_ford_with_paths(n, edges, source)
    dist = fill(Inf, n)  # Initialize distances as infinity
    dist[source] = 0  # Distance to the source is 0
    pred = fill(-1, n)  # Initialize predecessors for path tracking

    # Relax edges (n-1) times
    for _ in 1:(n-1)
        for (u, v, cost) in edges
            if dist[u] != Inf && dist[u] + cost < dist[v]
                dist[v] = dist[u] + cost
                pred[v] = u  # Update predecessor
            end
        end
    end

    # Check for negative-weight cycles
    for (u, v, cost) in edges
        if dist[u] != Inf && dist[u] + cost < dist[v]
            println("Graph contains a negative-weight cycle.")
            return nothing, nothing
        end
    end

    return dist, pred
end

# Function to reconstruct the path to a given node
function reconstruct_path(pred, node)
    path = []
    while node != -1
        push!(path, node)
        node = pred[node]
    end
    return reverse(path)  # Reverse the path to get it from source to destination
end

# Setup
n = 4  # Number of nodes

# Iteration 1

edges = [
    (1, 2, 4), (1, 3, 4),
    (2, 1, 8), (2, 3, 7), (2, 4, 2),
    (3, 1, 7), (3, 2, 4), (3, 4, 6),
    (4, 2, 4), (4, 3, 4)
]  # (u, v, cost)

source = 4  # Node C
terminal = 1  # Node A
d_k = 5  # Units to be transported

# Run Bellman-Ford from source
distances, predecessors = bellman_ford_with_paths(n, edges, source)

if distances !== nothing
    println("Shortest distances from node $source:")
    for i in 1:n
        @printf("Node %d: %.2f\n", i, distances[i])
    end

    println("\nPaths to each node from source:")
    for i in 1:n
        path = reconstruct_path(predecessors, i)
        println("Path to Node $i: ", path)
    end
end


# Iteration 2

edges = [
    (1, 2, 4), (1, 3, 4),
    (2, 1, 8), (2, 3, 7), (2, 4, 2),
    (3, 1, 7), (3, 2, 4), (3, 4, 6),
    (4, 2, 4), (4, 3, 4+7)
]  # (u, v, cost)

source = 1  # Node C
terminal = 3 # Node A
d_k = 3  # Units to be transported

# Run Bellman-Ford from source
distances, predecessors = bellman_ford_with_paths(n, edges, source)

if distances !== nothing
    println("Shortest distances from node $source:")
    for i in 1:n
        @printf("Node %d: %.2f\n", i, distances[i])
    end

    println("\nPaths to each node from source:")
    for i in 1:n
        path = reconstruct_path(predecessors, i)
        println("Path to Node $i: ", path)
    end
end

# Iteration 3

edges = [
    (1, 2, 4), (1, 3, 4),
    (2, 1, 8), (2, 3, 7), (2, 4, 2),
    (3, 1, 7), (3, 2, 4), (3, 4, 6),
    (4, 2, 4), (4, 3, 4)
]  # (u, v, cost)

source = 4  # Node C
terminal = 1 # Node A
d_k = 5  # Units to be transported

# Run Bellman-Ford from source
distances, predecessors = bellman_ford_with_paths(n, edges, source)

if distances !== nothing
    println("Shortest distances from node $source:")
    for i in 1:n
        @printf("Node %d: %.2f\n", i, distances[i])
    end

    println("\nPaths to each node from source:")
    for i in 1:n
        path = reconstruct_path(predecessors, i)
        println("Path to Node $i: ", path)
    end
end
