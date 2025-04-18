#include <cstdio> // For standard input/output functions
#include <vector> // For using the std::vector container
#include <cstring> // For memset function
#include <string> // For using the std::string container
#include <fstream> // For file stream and istreambuf_iterator
#include <ctime> // For time-related functions
#include "Graph.h" // Custom header file for Graph-related classes and functions

// Define the TTY constant based on the operating system
#ifdef _WIN32
    #define TTY "CON"
#else
    #define TTY "/dev/tty"
#endif

// Define the maximum number of nodes in the graph
#define MAX_OUTPUT 10000

clock_t start, stop;  /* clock_t is a built-in type for processor time (ticks) */
double duration;      /* Records the run time (seconds) of a function */

int main(int argc, char *argv[]) {
    // Check if the number of arguments is less than 2
    if (argc != 3) {
        // Print usage information
        printf("Usage: %s <input sample> <output sample>\n", argv[0]);
        return 1;
    }


    freopen(argv[1], "r", stdin); // Redirect standard input to read from the specified file
    freopen("test.out", "w", stdout); // Redirect standard output to a file named "test.out"
    
    // Record the start time (in ticks) before the main logic begins
    start = clock();

    int n, m, k; // n: number of nodes, m: number of edges, k: threshold for node appearance
    scanf("%d %d %d", &n, &m, &k); // Read the number of nodes, edges, and threshold
    Graph* graph = new Graph(n); // Create a new Graph object with n nodes
    graph->init_from_stdin(m); // Initialize the graph by reading m edges from standard input
    
    int T; // Number of test cases
    int count[GRAPH_MAX_N] = {0}; // Array to count the appearance of nodes in shortest paths
    bool flag = false; // Flag to track if any node meets the condition
    int start, destination; // Variables to store the start and destination nodes for each test case
    scanf("%d", &T); // Read the number of test cases
    for (int i = 0; i < T; i++) { // Loop through each test case
        scanf("%d %d", &start, &destination); // Read the start and destination nodes
        GraphShortestPathSolution* solution = new GraphShortestPathSolution(graph, start); // Create a solution object for shortest path from the start node
        solution->solve(); // Solve the shortest path problem
        std::vector<std::vector<int>> all_paths = solution->get_all_shortest_path(destination); // Get all shortest paths to the destination node
        for (auto path : all_paths) { // Iterate through all shortest paths
            for (auto node : path) { // Iterate through each node in the path
                count[node]++; // Increment the count for the node
            }
        }
        for (int j = 0; j < n; j++) { // Check all nodes to see if they meet the condition
            if (count[j] >= k && j != start && j != destination) { // Node must appear at least k times and not be the start or destination
                if (flag) { // If a node has already been printed, print a space before the next node
                    printf(" ");
                } else {
                    flag = true; // Set the flag to true after printing the first node
                }
                printf("%d", j); // Print the node
            }
        }
        if (!flag) { // If no node meets the condition, print "None"
            printf("None");
        }
        printf("\n"); // Print a newline after processing the test case
        memset(count, 0, sizeof(count)); // Reset the count array for the next test case
        flag = false; // Reset the flag for the next test case
    }

    // Record the stop time (in ticks) after the main logic completes
    stop = clock();

    freopen(TTY, "r", stdin); // Redirect standard input back to the terminal
    freopen(TTY, "w", stdout); // Redirect standard output back to the terminal

    
    std::string output((std::istreambuf_iterator<char>(std::ifstream("test.out").rdbuf())), std::istreambuf_iterator<char>()); // Read the output from "test.out" into a string
    std::string output_sample((std::istreambuf_iterator<char>(std::ifstream(argv[2]).rdbuf())), std::istreambuf_iterator<char>()); // Read the expected output from the specified file into a string

    remove("test.out"); // Remove the temporary output file "test.out"

    // Remove trailing newlines from both output and output_sample
    while (!output.empty() && output.back() == '\n') {
        output.pop_back();
    }
    while (!output_sample.empty() && output_sample.back() == '\n') {
        output_sample.pop_back();
    }

    if (output == output_sample) { // Compare the output with the expected output
        printf("Correct\n"); // If they match, print "Correct"
        
        // Calculate the duration of the program execution in seconds
        // CLOCKS_PER_SEC is a constant representing the number of ticks per second
        duration = ((double)(stop - start)) / CLOCKS_PER_SEC;

        // Print the duration of the program execution
        printf("%lf\n", duration);
    } else {
        printf("Wrong\n"); // If they don't match, print "Wrong"
    }
}