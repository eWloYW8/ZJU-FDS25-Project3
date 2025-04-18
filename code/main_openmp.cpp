#include <cstdio> // For standard input/output functions like scanf and printf
#include <vector> // For using the std::vector container
#include <cstring> // For C-style string manipulation (not used in this code)
#include <string> // For using the std::string class
#include "Graph.h" // Custom header file for the Graph class
#include <omp.h> // For OpenMP parallelization

int main() {
    int n, m, k; // n: number of nodes, m: number of edges, k: threshold for node occurrence
    scanf("%d %d %d", &n, &m, &k); // Read graph parameters from standard input
    Graph* graph = new Graph(n); // Create a new Graph object with n nodes
    graph->init_from_stdin(m); // Initialize the graph by reading m edges from standard input
    
    int T; // Number of test cases
    scanf("%d", &T); // Read the number of test cases
    std::vector<std::pair<int, int>> testCases(T); // Vector to store start and destination nodes for each test case
    for (int i = 0; i < T; ++i) {
        scanf("%d %d", &testCases[i].first, &testCases[i].second); // Read each test case
    }
    
    std::vector<std::string> results(T); // Vector to store results for each test case
    
    // Parallelize the loop using OpenMP
    #pragma omp parallel for
    for (int i = 0; i < T; ++i) {
        int start = testCases[i].first; // Start node for the current test case
        int dest = testCases[i].second; // Destination node for the current test case
        std::vector<int> local_count(n, 0); // Vector to count occurrences of nodes in all shortest paths
        bool flag = false; // Flag to indicate if any node meets the threshold condition
        std::string result; // String to store the result for the current test case
        
        // Solve the shortest path problem for the current start node
        GraphShortestPathSolution* solution = new GraphShortestPathSolution(graph, start);
        solution->solve(); // Compute shortest paths from the start node
        std::vector<std::vector<int>> all_paths = solution->get_all_shortest_path(dest); // Get all shortest paths to the destination node
        delete solution; // Free the memory allocated for the solution object
        
        // Count occurrences of each node in all shortest paths
        for (const auto& path : all_paths) {
            for (int node : path) {
                if (node >= 0 && node < n) { // Ensure the node index is valid
                    local_count[node]++;
                }
            }
        }
        
        // Check if any node (excluding start and destination) meets the threshold condition
        for (int j = 0; j < n; ++j) {
            if (local_count[j] >= k && j != start && j != dest) {
                if (flag) { // If this is not the first node meeting the condition, add a space
                    result += " ";
                } else {
                    flag = true; // Set the flag to true for the first node meeting the condition
                }
                result += std::to_string(j); // Append the node index to the result string
            }
        }
        
        // If no node meets the condition, set the result to "None"
        if (!flag) {
            results[i] = "None";
        } else {
            results[i] = result; // Otherwise, store the result string
        }
    }
    
    // Print the results for all test cases
    for (const auto& res : results) {
        printf("%s\n", res.c_str());
    }
    
    delete graph; // Free the memory allocated for the graph object
    return 0; // Exit the program
}