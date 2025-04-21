#include <cstdio> // For standard input/output functions
#include <vector> // For using the std::vector container
#include <cstring> // For memset function
#include "Graph.h" // Custom header file for Graph-related classes and functions

int main() {
    int n, m, k; // n: number of nodes, m: number of edges, k: threshold for node appearance
    scanf("%d %d %d", &n, &m, &k); // Read the number of nodes, edges, and threshold
    Graph* graph = new Graph(n); // Create a new Graph object with n nodes
    graph->init_from_stdin(m); // Initialize the graph by reading m edges from standard input
    
    int T; // Number of test cases
    bool flag = false; // Flag to track if any node meets the condition
    int start, destination; // Variables to store the start and destination nodes for each test case
    scanf("%d", &T); // Read the number of test cases
    for (int i = 0; i < T; i++) { // Loop through each test case
        scanf("%d %d", &start, &destination); // Read the start and destination nodes
        GraphShortestPathSolution* solution = new GraphShortestPathSolution(graph, start); // Create a solution object for shortest path from the start node
        solution->solve(); // Solve the shortest path problem
        std::vector<int> count_path_to_start = solution->count_path_to_start(destination); // Count paths to the start node
        std::vector<int> count_path_to_destination = solution->count_path_to_destination(destination); // Count paths to the destination node
        for (int j = 0; j < n; j++) { // Check all nodes to see if they meet the condition
            if (count_path_to_start[j] != -1 && j != start && j != destination && count_path_to_start[j]*count_path_to_destination[j] >= k) {
                if (flag) printf(" "); // Print a space if this is not the first node meeting the condition
                else flag = true; // Set the flag to true if this is the first node meeting the condition
                printf("%d", j); // Print the node number
            }
        }
        if (!flag) { // If no node meets the condition, print "None"
            printf("None");
        }
        printf("\n"); // Print a newline after processing the test case
        flag = false; // Reset the flag for the next test case
    }

    delete graph;
    return 0;
}