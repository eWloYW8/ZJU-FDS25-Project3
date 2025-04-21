#import "./template.typ": *
#import "@preview/lovelace:0.3.0": *

#show: project.with(
  theme: "project",
  style: "modified",
  course: none,
  title: "Hard Transportation Hub",
  date: "2025/04/21",
  author: none,
)

#state-block-theme.update("thickness")

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

Before sketching the main program flow, I will first introduce the main steps and algorithms in this project, which include the build of the graph, the Dijkstra algorithm, and the counting of shortest paths passing each node.

== The Build of the Graph

#note(name: [The Graph Data Structure])[
  A *graph* is a fundamental data structure consisting of:
  
  - Core Components
    - *Vertices (Nodes)*: Represent entities/objects
    - *Edges*: Represent relationships between vertices
      - May be *directed* or *undirected*
      - May have *weights* (numerical values)

  - Common Representations
    1. *Adjacency Matrix*
      - Square matrix where entry (i,j) represents edge between   vertex i and j
      - Efficient for dense graphs
      - O(1) edge lookup time

    2. *Adjacency List*
      - Array of linked lists
      - Each list stores neighbors of a vertex
      - Memory-efficient for sparse graphs

    Considering that the maximum number of nodes is 500, we choose the adjacency matrix representation for simplicity and efficiency.
]

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

This modified Dijkstra lays the foundation for counting shortest paths passing each node and identifying transportation hubs.

== Counting Shortest Paths Passing Each Node

To determine how many shortest paths pass through each node, the algorithm employs a two-phase dynamic programming approach that leverages the predecessor relationships captured during the Dijkstra traversal.

The core idea is to decompose any shortest path into two segments: from the source to the intermediate node, and from the intermediate node to the destination. The total number of paths passing through a node is then the product of these two independent counts.

The process can be summarized as follows:
1. Reverse Predecessor Graph: Construct a reverse graph where edges point from child nodes to their predecessors in the original shortest path tree.
2. Path Counting via Backtracking:
   - For each node, recursively count paths from the source using the original predecessor list.

   - For each node, recursively count paths to the destination using the reverse predecessor graph.

3. Combination via Multiplication: Multiply the two directional counts to obtain the total paths passing through each node.

#pseudocode-list[
  + *function* CountPaths(source, destination)
    + *for* each node i
      + path_to_start[i] ← 0
    + path_to_start[source] ← 1
    + *for* nodes in Dijkstra order
      + *for* each predecessor p in path_parent[i]
        ▪ path_to_start[i] += path_to_start[p]
      + *end*
    + *end*
    + reverse_graph ← empty adjacency list
    + *for* each node i
      + *for* each predecessor p in path_parent[i]
        ▪ add i to reverse_graph[p]
      + *end*
    + *end*
    + *for* each node i
      + path_to_dest[i] ← 0
    + path_to_dest[destination] ← 1
    + *for* nodes in reverse Dijkstra order
      + *for* each child c in reverse_graph[i]
        ▪ path_to_dest[i] += path_to_dest[c]
      + *end*
    + *end*
    + *for* each node j
      + passing_count[j] ← path_to_start[j] × path_to_dest[j]
    + *end*
]

This approach efficiently reuses shortest path information while avoiding explicit enumeration of all possible paths through memoization and topological ordering.


== The Main Program Flow

The main function controls the complete execution: from reading input and initializing the graph, to handling multiple test cases and printing the required results. It ensures that each query is handled independently with proper resource management. 

The core logic follows this sequence:

#pseudocode-list[
  + *function* Main()
    + Read graph parameters (n, m, k)
    + Initialize graph structure
    + Read T test cases
    + *for* each test case
      + Read (start, destination) pair
      + Initialize shortest path solver with source node
      + Execute Dijkstra's algorithm
      + Calculate path counts using bidirectional dynamic programming
      + Traverse all nodes to check path passing conditions
        ▪ *if* node is neither start nor destination
        ▪ *and* path_count ≥ threshold k
          ▪ Add to output list
      + *end*
      + *if* no qualifying nodes → Output "None"
      + *else* → Output space-separated node IDs
    + *end*
]


#pagebreak()

= *Chapter 3*: Testing Results

== Testing Infrastructure

- Test environment: Windows 11 64-bit and Debian 12 64-bit.
- Main program compiled with `g++ 14.2.0` using `-O2` optimization flag.

== Testcases

=== Testcase 1: Testcase in the problem description
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

=== Testcase 4: Extremely large number of shortest paths
The input contains a graph with a very high number of shortest paths (larger than INT_MAX) passing through a single node. The program should efficiently count and return the correct transportation hubs.

#table(
  columns: (1fr, 1fr),
  align: top,
  inset: 10pt,
  [Input], [Output],
  [
    #raw("132 260 5
0 1 1
0 2 1
1 3 1
1 4 1
2 3 1
2 4 1
...
128 130 1
129 131 1
130 131 1
1
0 131

(for complete sample, see:
code/test_sample/large_number_test.in)", block: true)
  ],
  [
    #raw(read("../code/test_sample/large_number_test.out"), block: true)
  ],
)

=== Testcase 5: High pressure random graph
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

We only analyze the complexity of the Dijkstra algorithm and the counting of shortest paths passing each node, as they are the most time-consuming parts of the program.

== The Dijkstra Algorithm

=== Time Complexity  
The time complexity of the provided Dijkstra's algorithm implementation is $O(V²)$, where $V$ is the number of nodes in the graph. This is because:  
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

== Counting Shortest Paths Passing Each Node

=== Time Complexity
The overall algorithm counts the number of shortest paths passing through each node by computing:

1. The number of shortest paths from each node to the `start` node.
2. The number of shortest paths from each node to the `destination` node (via reverse traversal).
3. The final count of paths passing through a node as the product of the above two quantities.

The main operations can be broken down as follows:

1. *Recursive Path Counting (Forward and Reverse)*:  
   Both `count_path_to_start` and `count_path_to_destination` use memoized depth-first search (DFS) to traverse the graph and count the number of paths. Each recursive traversal explores the directed acyclic graph formed by the shortest paths (stored in `path_parent`).  
   - In the worst case, if the graph has $E$ edges, and all of them are part of the shortest path DAG, then each recursive function visits each edge at most once.
   - Thus, the complexity of each counting phase is *$O(V + E)$*, where $V$ is the number of nodes and $E$ is the number of edges on shortest paths.

2. *Reverse Path Construction*:  
   The function `get_path_parent_reverse` builds a reverse graph of shortest paths using a DFS traversal over `path_parent`. Each edge is traversed at most once, leading to a complexity of *$O(V + E)$*.

3. *Final Path Count Calculation*:  
   After computing the forward and reverse path counts, the algorithm computes the number of paths passing through each node by multiplying the two counts for every node. This step takes *$O(V)$* time.

*Total Time Complexity*:  
Combining all parts, the total time complexity is:  *$O(V + E)$*


If the graph is dense and nearly all edges lie on shortest paths, the worst-case time complexity becomes: *$O(V^2)$*

=== Space Complexity
1. *Shortest Path DAGs* (`path_parent` and `path_parent_reverse`):  
   These store parent relationships for each node along shortest paths. In the worst case (e.g., multiple shortest paths between many pairs), each node may have up to $O(V)$ parents, leading to *$O(V²)$* space usage.

2. *Path Count Arrays*:  
   Arrays such as `count_path`, `visited`, and the final product array `count_path_passing_node` each require *$O(V)$* space.

3. *Call Stack (Recursive DFS)*:  
   The recursion depth is at most $O(V)$, so stack space usage is also bounded by *$O(V)$*.

*Total Space Complexity*: *$O(V^2)$*

=== Improvements
- Early termination when a threshold is exceeded helps mitigate performance degradation in cases with combinatorially many shortest paths.
- Path counting to start node and the reverse process can be executed in the same loop.

#pagebreak()

= *Appendix*: Source Code (in C)

The project is written in C++ and employs relatively abstract object-oriented encapsulation, which may make it somewhat obscure.

Even though the project is small, it uses CMake for management.

== CMakeLists.txt

`CMakeLists.txt` is the core configuration file for the CMake build system, defining project structure, compilation options, dependencies, and cross-platform build rules to generate native build environments (e.g., Makefiles or Visual Studio projects).

#codex(read("../code/CMakeLists.txt"), filename: [*File*: CMakeLists.txt], lang: "cmake")

== Graph.cpp / Graph.h

This module provides functionality for representing and analyzing graphs. It includes a `Graph` class to store graph data (nodes and weighted edges) and a `GraphShortestPathSolution` class to compute and count shortest paths from a given start node to any destination node in the graph. The implementation supports graphs with up to 500 nodes.

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