#import "./template.typ": *
#import "@preview/lovelace:0.3.0": *

#show: project.with(
  theme: "project",
  style: "modified",
  course: none,
  title: "Hard Transportation Hub",
  date: "2025/04/19",
  author: none,
)

= *Chapter 1*: Introduction

== Problem Description

Given a map of cities connected by bidirectional roads, each with a positive length, we are tasked with identifying *transportation hubs* for a number of city-to-city queries. A city is considered a transportation hub if it appears on *at least k different shortest paths* between a given pair of source and destination cities — excluding the source and destination themselves.

- All roads are bidirectional and unique.
- Only intermediate cities (excluding source and destination) are considered when counting transportation hubs.
- The shortest path between a city and itself is defined to be 0.

== Input Format

The input consists of the following:

1. Three integers:
   - `n`: the number of cities (indexed from 0 to n−1), where 3 ≤ n ≤ 500.
   - `m`: the number of bidirectional roads.
   - `k`: the minimum number of shortest paths on which a city must appear to be considered a transportation hub (2 ≤ k ≤ 5).

2. Followed by `m` lines, each describing a road in the form:
   ```
   c1 c2 length
   ```
   - `c1` and `c2` are the city indices.
   - `length` is the positive integer length of the road (≤ 100).

3. A positive integer `T` (≤ 500), the number of source-destination queries.

4. `T` lines follow, each containing a pair of city indices:
   ```
   source destination
   ```

== Output Format

For each query:

- Output the indices of all transportation hubs, sorted in ascending order, separated by single spaces.
- If no city qualifies as a hub, output `None`.

== Algorithm Background

To solve the transportation hub problem, we employ *Dijkstra's algorithm*, a well-known method for finding the shortest paths from a single source to all other nodes in a weighted graph with non-negative edge weights.

This algorithm ensures that we can efficiently compute the shortest distance between any pair of cities. By slightly extending Dijkstra's algorithm, we can also keep track of how many shortest paths pass through each city. This information is critical for identifying the cities that qualify as transportation hubs.

Due to its efficiency and accuracy in sparse graphs, Dijkstra's algorithm is well-suited for this problem.

#pagebreak()

= *Chapter 2*: Algorithm Specification

Before sketching the main program flow, I will first introduce the main steps and algorithms in this project, which include the build of the graph, the Dijkstra algorithm, the restore of the shortest path, and the identification of transportation hubs.

== The Build of the Graph

To represent the structure of cities and roads, the program uses an adjacency matrix to build the graph. The class `Graph` encapsulates this logic.

The graph is initialized with a fixed-size two-dimensional array `adj`, where `adj[i][j]` stores the length of the road between city `i` and city `j`. The matrix is symmetric since all roads are undirected.

At the beginning, all distances are set to `-1` to represent the absence of a road, except for the diagonal entries where `adj[i][i] = 0`, indicating zero distance from a city to itself.

Edges are then added by reading input from the standard input. Each road is defined by two city indices and a positive length. The `add_edge` function updates the adjacency matrix symmetrically to reflect the bidirectional nature of roads.

This setup allows for efficient distance lookups between any two cities, which is crucial for the shortest path calculations later in the algorithm.

// Graph construction pseudocode
#pseudocode-list[
  + *function* BuildGraph(n: int, m: int)
    + *for* i in 0 to n - 1
      + *for* j in 0 to n - 1
        + *if* i == j *then*
          + adj[i][j] ← 0 // self-loop
        + *else*
          + adj[i][j] ← -1 // no edge initially
        + *end*
      + *end*
    + *for* count in 1 to m
      + read (u, v, length)
      + adj[u][v] ← length
      + adj[v][u] ← length // undirected edge
    + *end*
  + *end*
]

== The Dijkstra Algorithm

To compute the shortest paths from a given source city to all others, the program uses a customized implementation of *Dijkstra's algorithm*. It also tracks multiple shortest paths by storing all valid predecessors for each node.

The algorithm starts by initializing the distance from the source to itself as 0, while all other distances are set to -1, indicating they are initially unreachable. Then, for each unvisited node, it repeatedly selects the one with the minimum known path length and updates its neighbors accordingly.

Unlike the classical Dijkstra, this version maintains a list of *predecessor nodes* for every city, which is essential for counting how many shortest paths pass through a given node.

Below is the core pseudocode that captures the algorithm's main logic:

#pseudocode-list[
  + *function* Dijkstra(start: int)
    + *for* each node i
      + visited[i] ← false
      + path_length[i] ← -1
    + path_length[start] ← 0
    + *for* each neighbor i of start
      + path_length[i] ← weight(start, i)
      + path_parent[i] ← [start]
    + visited[start] ← true
    + *repeat n times*
      + min_node ← node with smallest path_length among unvisited
      + *if* min_node == -1 *then* break
      + visited[min_node] ← true
      + *for* each neighbor j of min_node
        + *if* not visited and edge exists
          + new_length ← path_length[min_node] + weight(min_node, j)
          + *if* path_length[j] == -1 or new_length < path_length[j] *then*
            + path_length[j] ← new_length
            + path_parent[j] ← [min_node]
          + *else if* new_length == path_length[j] *then*
            + path_parent[j].append(min_node)
          + *end*
        + *end*
      + *end*
    + *end*
]

This modified Dijkstra lays the foundation for backtracking all shortest paths and counting node appearances to identify transportation hubs.

== Backtracking All Shortest Paths

Once the shortest path lengths and their respective predecessors are computed, the next step is to reconstruct *all possible shortest paths* from the start node to a given destination. This is achieved through recursive backtracking.

Each node maintains a list of its predecessor nodes on any shortest path. To build all paths to the destination, we recursively construct all paths to its predecessors and append the destination node to each of them.

This approach ensures that every shortest route from the start node to the destination is captured.

The pseudocode below illustrates the recursive backtracking logic:

#pseudocode-list[
  + *function* GetAllShortestPaths(destination: int) → list of paths
    + *if* destination == start *then*
      + *return* [[start]]
    + *if* not solved or path_length[destination] == -1 *then*
      + *return* []
    + all_paths ← []
    + *for* each parent in path_parent[destination]
      + sub_paths ← GetAllShortestPaths(parent)
      + *for* each sub_path in sub_paths
        + sub_path.append(destination)
        + all_paths.append(sub_path)
      + *end*
    + *end*
    + *return* all_paths
  + *end*
]

This method provides the foundation for analyzing node appearances on all shortest paths, enabling the identification of transportation hubs.

== The Identification of Transportation Hubs

After all shortest paths between a pair of cities are generated, the final step is to identify which cities qualify as *transportation hubs*. According to the definition, a city is considered a hub if it appears on at least $k$ of the shortest paths — excluding the start and end cities themselves.

To achieve this, the program counts how many times each city appears across all shortest paths. If the count reaches the given threshold $k$, the city is considered a hub and is included in the output for that source-destination query.

The pseudocode below outlines this identification process:

#pseudocode-list[
  + *function* FindHubs(all_paths, start, destination, k)
    + count[node] ← 0 for all nodes
    + *for* each path in all_paths
      + *for* each node in path
        + count[node] += 1
      + *end*
    + *end*
    + hubs ← []
    + *for* each node j
      + *if* count[j] ≥ k and j ≠ start and j ≠ destination
        + hubs.append(j)
      + *end*
    + *end*
    + *if* hubs is empty
      + print "None"
    + *else*
      + print hubs in ascending order
    + *end*
  + *end*
]

This procedure ensures that only cities that serve as true intermediaries in multiple shortest paths are labeled as transportation hubs, filtering out source and destination nodes.

== The Main Program Flow

The main function controls the complete execution: from reading input and initializing the graph, to handling multiple test cases and printing the required results. It ensures that each query is handled independently with proper resource management.

Below is a streamlined pseudocode version focusing only on the main orchestration logic:

// pseudocode of the main function
#pseudocode-list[
  + Read n, m, k
  + Create graph with n nodes
  + Read m edges into the graph
  + Read T test cases
  + *for* each (start, destination) pair
    + Create shortest path solver from `start`
    + Run Dijkstra's algorithm
    + Retrieve all shortest paths to `destination`
    + Count appearances of nodes in all paths
    + Identify transportation hubs based on count
    + Print results
    + Reset counters for next case
  + *end*
]

#pagebreak()

= *Chapter 3*: Testing Results

== Testing Infrastructure

- Test environment: Windows 11 64-bit and Debian 12 64-bit.
- Main program compiled with `g++ 14.2.0` using `-O2` optimization flag.

== Testcases

=== Testcase 1: Testcase in the origin problem description
The input and output are provided in the problem description.

#table(
  columns: (1fr, 1fr),
  align: top,
  inset: 10pt,
  [Input], [Output],
  [
    #raw(read("../code/test_sample/origin_test.in"), block: true)
  ],
  [
    #raw(read("../code/test_sample/origin_test.out"), block: true)
  ],
)

=== Testcase 2: Unconnected Graph
The input contains a graph with unconnected components. The program should handle this gracefully and return `None` for any queries involving unconnected nodes.

#table(
  columns: (1fr, 1fr),
  align: top,
  inset: 10pt,
  [Input], [Output],
  [
    #raw(read("../code/test_sample/unconnected_test.in"), block: true)
  ],
  [
    #raw(read("../code/test_sample/unconnected_test.out"), block: true)
  ],
)

=== Testcase 3: The start node is the same as the end node
The input contains a query where the start and end nodes are the same. The program should return `None` since no transportation hub can exist in this case.

#table(
  columns: (1fr, 1fr),
  align: top,
  inset: 10pt,
  [Input], [Output],
  [
    #raw(read("../code/test_sample/same_start_end_test.in"), block: true)
  ],
  [
    #raw(read("../code/test_sample/same_start_end_test.out"), block: true)
  ],
)

=== Testcase 4: High pressure random graph
The input contains a large random graph with many nodes and edges generated by a python generator script.

The testcase generation algorithm is as follows:

// pseudocode demo, require `lovelace` package
#pseudocode-list[
  + generate random number `n` in [3, 500]
  + calculate `max_roads = n * (n - 1) / 2`
  + generate random number `m` in [1, max_roads]
  + generate random number `k` in [1, 5]
  + initialize node list from 0 to n-1
  + shuffle node list for randomness
  + initialize empty set `edges` and parent array for union-find
  + *define* function `find(u)`:
    + *while* `parent[u] != u`
      + perform path compression and move up
    + *end*
    + *return* root of `u`
  + *for* i = 1 to n-1 *do*
    + connect node[i-1] and node[i] to ensure connectivity
    + add edge to `edges`
  + *while* number of edges < m
    + randomly select c1 and c2 from nodes
    + *if* c1 ≠ c2 and (c1, c2) not in `edges`
      + add edge (sorted) to `edges`
  + *for each* edge in `edges`
    + assign a random weight in [1, 30]
    + store as (node1, node2, length)
  + shuffle all roads
  + generate T in [1, 500]
  + *repeat* T times
    + randomly select `src` and `dst`
    + store as a query pair
  + output n, m, k
  + output all roads
  + output T
  + output all queries
]

The testcase are incredibly large, so the input and output are not shown here. You can find them in the `code/test_sample/random_*.in` and `code/test_sample/random_*.out` files.

The program passes all the test cases shown above with high performance, including the random ones.

#pagebreak()

= *Chapter 4*: Analysis and Comments

We only analyze the complexity of the Dijkstra algorithm and the Backtracking process, as they are the most time-consuming parts of the program.

== The Dijkstra Algorithm

=== Time Complexity  
The time complexity of the provided Dijkstra's algorithm implementation is O(V²), where $V$ is the number of nodes in the graph. This is because:  
1. The algorithm uses two nested loops over all nodes ($V$ iterations each).  
2. For each node, it scans all other nodes to find the unvisited node with the smallest path length (O(V) per iteration).  
3. Updating neighbors also iterates over all nodes (O(V) per iteration), leading to a total of $O(V²)$ operations.  


=== Space Complexity  
The space complexity is O(V²) due to:  
1. The adjacency matrix `graph->adj` requiring $O(V²)$ space.  
2. The `path_parent` array storing a list of parents for each node, which could reach $O(V²)$ in the worst case (e.g., multiple shortest paths).  
3. Additional arrays like `path_length` and `visited` using $O(V)$ space.  

The adjacency matrix dominates the space usage, making the overall complexity quadratic in the number of nodes.

=== Improvements
- Using a priority queue to optimize the selection of the next node to visit can reduce the time complexity to O((V + E) log V), where $E$ is the number of edges.

== Backtracking Paths

=== Time Complexity  
The time complexity of the Path Backtracking process is O(P × V), where $P$ is the number of shortest paths from the start to the destination, and $V$ is the number of nodes. This is because:  
1. For each parent of the destination node, the function recursively generates all sub-paths to that parent. If a node has multiple parents (e.g., in a grid-like graph), this leads to combinatorial branching.  
2. Appending the destination node to each sub-path takes $O(V)$ time per path.  
In the worst case (e.g., a fully connected graph where every node is a parent of its successors), the number of paths $P$ grows exponentially with $V$, resulting in O(2^V × V) time complexity.

=== Space Complexity  
The space complexity is O(P × V) due to:  
1. Storing all generated paths in memory, where each path contains up to $O(V)$ nodes.  
2. The recursion stack depth can reach $O(V)$ (for paths spanning all nodes).  
In scenarios with exponentially many shortest paths (e.g., graphs with redundant shortest paths), the space complexity becomes O(2^V × V).  
Additionally, the `path_parent` structure (precomputed in Dijkstra’s algorithm) contributes $O(V^2)$ space, but this is considered part of the input and not the algorithm’s working space.

=== Improvements
- Maybe the process can be skiped if the number of paths is too large, and we can just count the number of nodes in the path.

= *Appendix*: Source Code (in C)

The project is written in C++ and employs relatively abstract object-oriented encapsulation, which may make it somewhat obscure.

Even though the project is small, it uses CMake for management.

== CMakeLists.txt

`CMakeLists.txt` is the core configuration file for the CMake build system, defining project structure, compilation options, dependencies, and cross-platform build rules to generate native build environments (e.g., Makefiles or Visual Studio projects).

#codex(read("../code/CMakeLists.txt"), filename: [*File*: CMakeLists.txt], lang: "cmake")

== Graph.cpp / Graph.h

This module provides functionality for representing and analyzing graphs. It includes a `Graph` class to store graph data (nodes and weighted edges) and a `GraphShortestPathSolution` class to compute and retrieve all shortest paths from a given start node to any destination node in the graph. The implementation supports graphs with up to 500 nodes.

#codex(read("../code/Graph.h"), filename: [*File*: Graph.h], lang: "cpp")

#codex(read("../code/Graph.cpp"), filename: [*File*: Graph.cpp], lang: "cpp")

== main.cpp

This module provides the main entry point for the simplification program, handling input processing, graph analysis, and result output. It reads the graph structure (nodes, weighted edges) and test cases from standard input, then computes nodes that appear in shortest paths above a specified threshold.

#codex(read("../code/main.cpp"), filename: [*File*: main.cpp], lang: "cpp")

== test.cpp

This module implements an automated testing framework for graph analysis, handling input/output validation, correctness checking, and performance measurement. It extends the main program with file-based testing capabilities and cross-platform compatibility.

#codex(read("../code/test.cpp"), filename: [*File*: test.cpp], lang: "cpp")

== samplegen.py

This is a python script to generate a large ramdom testcase. It does not need any arguments, but should be run with Python interpreter.

#codex(read("../code/samplegen.py"), filename: [*File*: samplegen.py], lang: "python")

== README.md / README.txt / README.pdf

The README file, nothing to introduce.

= *Declaration*

I hereby declare that all the work done in this project titled "Hard Transportation Hub" is of my independent effort.