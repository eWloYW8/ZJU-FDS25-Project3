#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "LinkedList.h"
#include "dijikstra.h"


Graph* setup_graph(int n){
    int c1, c2, length;
    Graph* graph = (Graph*)malloc(sizeof(Graph));
    graph->n = n;
    for(int i = 0; i < n; i++){
        scanf("%d %d %d",&c1,&c2,&length);
        graph->adj[c1][c2] = graph->adj[c2][c1] = length;
    }
}

int main(){
    int n, m, k;
    scanf("%d %d %d",&n,&m,&k);
    Graph* graph = setup_graph(n);
}