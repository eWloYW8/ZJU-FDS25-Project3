#include "Graph.h"
#include <cstdio>

// Constructor for the Graph class
// Initializes a graph with `n` nodes and sets up the adjacency matrix
// `adj[i][j]` is initialized to 0 if `i == j` (self-loop), otherwise -1 (no edge)
Graph::Graph(int n) : n(n) {
    for (int i = 0; i < GRAPH_MAX_N; i++) {
        for (int j = 0; j < GRAPH_MAX_N; j++) {
            adj[i][j] = (i == j) ? 0 : -1; // Initialize adjacency matrix
        }
    }
}

// Adds an undirected edge between nodes `u` and `v` with a given `length`
void Graph::add_edge(int u, int v, int length) {
    adj[u][v] = adj[v][u] = length; // Symmetric assignment for undirected graph
}

// Reads edges from standard input and initializes the graph
// `m` is the number of edges to read
void Graph::init_from_stdin(int m) {
    int c1, c2, length;
    for (int i = 0; i < m; i++) {
        scanf("%d %d %d", &c1, &c2, &length); // Read edge data
        add_edge(c1, c2, length); // Add edge to the graph
    }
}

// Constructor for the GraphShortestPathSolution class
// Initializes the shortest path solution for a given `graph` starting from `start` node
GraphShortestPathSolution::GraphShortestPathSolution(Graph *graph, int start)
    : graph(graph), start(start) {
    for (int i = 0; i < graph->n; i++) {
        visited[i] = 0; // Mark all nodes as unvisited
        path_length[i] = -1; // Initialize path lengths to -1 (unreachable)
    }
    path_length[start] = 0; // Distance to the start node is 0
    solved = false; // Mark the solution as unsolved
}

// Solves the shortest path problem using Dijkstra's algorithm
void GraphShortestPathSolution::solve() {
    // Initialize path lengths for direct neighbors of the start node
    for (int i = 0; i < graph->n; i++) {
        if (graph->adj[start][i] != -1) { // If there's an edge from start to `i`
            path_length[i] = graph->adj[start][i]; // Set path length
            path_parent[i].push_back(start); // Set start as the parent
        }
    }

    visited[start] = 1; // Mark the start node as visited

    // Iterate over all nodes to find the shortest paths
    for (int i = 0; i < graph->n; i++) {
        int min_length = -1; // Minimum path length found so far
        int min_node = -1; // Node corresponding to the minimum path length

        // Find the unvisited node with the smallest path length
        for (int j = 0; j < graph->n; j++) {
            if (!visited[j] && path_length[j] != -1 && 
                (min_length == -1 || path_length[j] < min_length)) {
                min_length = path_length[j];
                min_node = j;
            }
        }

        if (min_node == -1) break; // No more reachable nodes

        visited[min_node] = 1; // Mark the node as visited

        // Update path lengths for neighbors of the current node
        for (int j = 0; j < graph->n; j++) {
            if (!visited[j] && graph->adj[min_node][j] != -1) { // If there's an edge
                int new_length = path_length[min_node] + graph->adj[min_node][j]; // Calculate new path length
                if (path_length[j] == -1 || new_length < path_length[j]) {
                    path_length[j] = new_length; // Update path length
                    path_parent[j].clear(); // Clear previous parents
                    path_parent[j].push_back(min_node); // Add new parent
                } else if (new_length == path_length[j]) {
                    path_parent[j].push_back(min_node); // Add alternative parent
                }
            }
        }
    }
    solved = true; // Mark the solution as solved
}

// Retrieves all shortest paths from the start node to a given `destination` node
std::vector<std::vector<int>> GraphShortestPathSolution::get_all_shortest_path(int destination) {
    if (destination == start) {
        return {{start}}; // Base case: path to itself
    }
    if (!solved || path_length[destination] == -1) {
        return {}; // No solution or destination unreachable
    }
    std::vector<std::vector<int>> all_paths; // Container for all paths
    for (auto parent : path_parent[destination]) { // Iterate over all parents of the destination
        std::vector<std::vector<int>> sub_paths = get_all_shortest_path(parent); // Recursively get paths to the parent
        for (auto &sub_path : sub_paths) {
            sub_path.push_back(destination); // Append the destination to each sub-path
            all_paths.push_back(sub_path); // Add the completed path to the result
        }
    }
    return all_paths; // Return all paths
}

// Converts the paths to a matrix representation
std::vector<std::vector<int>> GraphShortestPathSolution::shortest_paths_to_matrix(int destination) {
    std::vector<std::vector<int>> matrix(graph->n, std::vector<int>(graph->n, 0)); // Initialize the matrix with 0 (no path)
    _shortest_paths_to_matrix(matrix, destination); // Fill the matrix with path lengths
    return matrix; // Return the matrix representation of paths
}

// Recursive helper function to fill the matrix with path lengths
void GraphShortestPathSolution::_shortest_paths_to_matrix(std::vector<std::vector<int>> &matrix, int destination) {
    if (destination == start) {
        return; // Base case: path to itself
    }
    for (auto parent : path_parent[destination]) { // Iterate over all parents of the destination
        matrix[parent][destination] = 1;
        _shortest_paths_to_matrix(matrix, parent); // Recursively fill the matrix for each parent
    }
}