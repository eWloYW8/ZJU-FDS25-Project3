import random

# Generate a random number of nodes (n) between 3 and 500
n = random.randint(3, 500)

# Calculate the maximum number of roads (edges) possible in a complete graph with n nodes
max_roads = n * (n - 1) // 2

# Generate a random number of roads (m) between 1 and max_roads
m = random.randint(1, max_roads)

# Generate a random number of special nodes (k) between 1 and 5
k = random.randint(1, 5)

# Create a list of node indices from 0 to n-1
nodes = list(range(n))

# Shuffle the nodes to randomize their order
random.shuffle(nodes)

# Initialize an empty set to store unique edges
edges = set()

# Initialize a parent list for union-find operations (used for ensuring connectivity)
parent = list(range(n))

# Function to find the root of a node in the union-find structure
def find(u):
    while parent[u] != u:  # Traverse up the tree until the root is found
        parent[u] = parent[parent[u]]  # Path compression for optimization
        u = parent[u]
    return u

# Ensure the graph is connected by adding a spanning tree
for i in range(1, n):
    u = nodes[i-1]  # Take the previous node
    v = nodes[i]    # Take the current node
    edges.add(tuple(sorted((u, v))))  # Add an edge between them (sorted to avoid duplicates)

# Add additional random edges until the total number of edges equals m
while len(edges) < m:
    c1 = random.randint(0, n-1)  # Randomly select the first node
    c2 = random.randint(0, n-1)  # Randomly select the second node
    if c1 != c2:  # Ensure the two nodes are not the same
        edge = tuple(sorted((c1, c2)))  # Create a sorted tuple to represent the edge
        if edge not in edges:  # Add the edge only if it doesn't already exist
            edges.add(edge)

# Create a list to store roads with their lengths
roads = []
for c1, c2 in edges:
    length = random.randint(1, 100)  # Assign a random length between 1 and 100 to each road
    roads.append((c1, c2, length))  # Add the road as a tuple (node1, node2, length)

# Shuffle the roads to randomize their order
random.shuffle(roads)

# Generate a random number of queries (T) between 1 and 500
T = random.randint(1, 500)

# Create a list to store queries
queries = []
for _ in range(T):
    src = random.randint(0, n-1)  # Randomly select a source node
    dst = random.randint(0, n-1)  # Randomly select a destination node
    queries.append((src, dst))  # Add the query as a tuple (source, destination)

# Print the number of nodes, edges, and special nodes
print(n, m, k)

# Print all roads in the format: node1 node2 length
for road in roads:
    print(f"{road[0]} {road[1]} {road[2]}")

# Print the number of queries
print(T)

# Print all queries in the format: source destination
for query in queries:
    print(f"{query[0]} {query[1]}")