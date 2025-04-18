#include <cstdio> // For standard input/output functions
#include <vector> // For using the std::vector container
#include <cstring> // For memset function
#include <string> // For using the std::string container
#include <fstream> // For file stream and istreambuf_iterator
#include <ctime> // For time-related functions
#include "Graph.h" // Custom header file for Graph-related classes and functions
#include <unistd.h> // For access() function to check file accessibility
#include <omp.h> // For OpenMP parallelization

// Define the TTY constant based on the operating system
#ifdef _WIN32
    #define TTY "CON"
#else
    #define TTY "/dev/tty"
#endif

// Define the maximum number of nodes in the graph
#define MAX_OUTPUT 10000

clock_t start_time, stop_time;  /* clock_t is a built-in type for processor time (ticks) */
double duration;      /* Records the run time (seconds) of a function */

int main(int argc, char *argv[]) {
    // Check if the number of arguments is less than 2
    if (argc != 3) {
        // Print usage information
        printf("Usage: %s <input sample> <output sample>\n", argv[0]);
        return 1;
    }

    if(access(argv[1], R_OK) == -1) { // Check if the input file is readable
        printf("Input file %s is not accessible\n", argv[1]);
        return 1;
    }

    if(access(argv[2], R_OK) == -1) { // Check if the output file is readable
        printf("Output file %s is not accessible\n", argv[2]);
        return 1;
    }

    freopen(argv[1], "r", stdin); // Redirect standard input to read from the specified file
    freopen("test.out", "w", stdout); // Redirect standard output to a file named "test.out"

    // Record the start time (in ticks) before the main logic begins
    start_time = clock();

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
    
    // Record the stop time (in ticks) after the main logic completes
    stop_time = clock();

    freopen(TTY, "r", stdin); // Redirect standard input back to the terminal
    freopen(TTY, "w", stdout); // Redirect standard output back to the terminal

    
    std::string output((std::istreambuf_iterator<char>(std::ifstream("test.out").rdbuf())), std::istreambuf_iterator<char>()); // Read the output from "test.out" into a string
    std::string output_sample((std::istreambuf_iterator<char>(std::ifstream(argv[2]).rdbuf())), std::istreambuf_iterator<char>()); // Read the expected output from the specified file into a string

    remove("test.out"); // Remove the temporary output file "test.out"

    // Replace all occurrences of "\r\n" with "\n" in the output and output_sample strings
    size_t pos;
    while ((pos = output.find("\r\n")) != std::string::npos) {
        output.replace(pos, 2, "\n");
    }
    while ((pos = output_sample.find("\r\n")) != std::string::npos) {
        output_sample.replace(pos, 2, "\n");
    }

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
        duration = ((double)(stop_time - start_time)) / CLOCKS_PER_SEC;

        // Print the duration of the program execution
        printf("%lf\n", duration);
    } else {
        printf("Wrong\n"); // If they don't match, print "Wrong"
    }
    
    delete graph;
    return 0;
}