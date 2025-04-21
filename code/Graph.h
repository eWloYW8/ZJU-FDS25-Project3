#pragma once
#include <vector>

// Define the maximum number of nodes in the graph
#define GRAPH_MAX_N 500

// Graph class represents a graph with adjacency matrix representation
class Graph {
public:
    int n; // Number of nodes in the graph
    int adj[GRAPH_MAX_N][GRAPH_MAX_N]; // Adjacency matrix to store edge lengths

    // Constructor to initialize the graph with a given number of nodes
    Graph(int n);

    // Adds an edge between nodes u and v with a specified length
    void add_edge(int u, int v, int length);

    // Initializes the graph by reading edges from standard input
    // m represents the number of edges
    void init_from_stdin(int m);
};

// GraphShortestPathSolution class is used to solve the shortest path problem
class GraphShortestPathSolution {
public:
    Graph *graph; // Pointer to the graph object
    int start; // Starting node for the shortest path calculation
    int visited[GRAPH_MAX_N]; // Array to track visited nodes during pathfinding
    std::vector<int> path_parent[GRAPH_MAX_N]; // Stores parent nodes for each node in the shortest path
    int path_length[GRAPH_MAX_N]; // Stores the shortest path length to each node
    bool solved; // Flag to indicate if the shortest path solution has been computed

    // Constructor to initialize the solution object with a graph and starting node
    GraphShortestPathSolution(Graph *graph, int start);

    // Solves the shortest path problem using an appropriate algorithm
    void solve();

    // Retrieves all shortest paths to a specified destination node
    // Returns a vector of paths, where each path is represented as a vector of nodes
    std::vector<std::vector<int>> get_all_shortest_path(int destination);

    // Converts the paths to a matrix representation
    std::vector<std::vector<int>> shortest_paths_to_matrix(int destination); 

    // Counts the number of paths from each node to the start node
    std::vector<int> count_path_to_start(int destination);

    // Retrieves the reverse paths from the start node to a given `destination` node 
    std::vector<int>* get_path_parent_reverse(int destination);

    // Counts the number of paths from each node to the destination node
    std::vector<int> count_path_to_destination(int destination);

private:
    // Recursive helper function to fill the matrix with path lengths
    void _shortest_paths_to_matrix(std::vector<std::vector<int>> &matrix, int destination);

    // Recursive helper function to count the number of paths from each node to the start node
    int _count_path_to_start(int destination, std::vector<int> &count_path);

    // Recursive helper function to retrieve the reverse paths from the start node to a given `destination` node 
    void _get_path_parent_reverse(int destination, std::vector<int> *path_parent_reverse, std::vector<int> &visited);

    // Recursive helper function to count the number of paths from each node to the destination node
    int _count_path_to_destination(int destination, int current, std::vector<int> &count_path, std::vector<int> *path_parent_reverse);
};
