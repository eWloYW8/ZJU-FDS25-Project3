#pragma once
#include "LinkedList.h"

#define GRAPH_N_MAX 500

typedef struct Graph {
    int adj[GRAPH_N_MAX][GRAPH_N_MAX];
    int n;
} Graph;

typedef struct dijikstra_info {
    int dist[GRAPH_N_MAX];
    LinkedList* prev[GRAPH_N_MAX];
    int visited[GRAPH_N_MAX];
} dijikstra_info;

dijikstra_info* setup_dijikstra_info(int n);

void free_dijikstra_info(dijikstra_info* info);

dijikstra_info* find_all_shortest_path(Graph* g, int start, int end);