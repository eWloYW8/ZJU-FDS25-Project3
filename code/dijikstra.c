#include "dijikstra.h"

dijikstra_info* setup_dijikstra_info(int n){
    dijikstra_info* info = (dijikstra_info*)malloc(sizeof(dijikstra_info));
    for (int i = 0; i < n; i++) {
        info->dist[i] = INT_MAX;
        info->prev[i] = create_linked_list();
        info->visited[i] = 0;
    }
    return info;
}

void free_dijikstra_info(dijikstra_info* info){
    for (int i = 0; i < GRAPH_N_MAX; i++) {
        free_linked_list(info->prev[i]);
    }
    free(info);
}

dijikstra_info* find_all_shortest_path(Graph* g, int start, int end) {
    dijikstra_info* info = setup_dijikstra_info(g->n);
    info->dist[start] = 0;
    
    LinkedList* queue = create_linked_list();
    add_to_linked_list(queue, start);
    
    while (queue->head != NULL) {
        LinkedListNode* current_node = queue->head;
        int current = current_node->data;
        remove_from_linked_list(queue, current);
        
        for (int i = 0; i < g->n; i++) {
            if (g->adj[current][i] > 0 && !info->visited[i]) {
                int new_dist = info->dist[current] + g->adj[current][i];
                if (new_dist < info->dist[i]) {
                    info->dist[i] = new_dist;
                    free_linked_list(info->prev[i]);
                    info->prev[i] = create_linked_list();
                    add_to_linked_list(info->prev[i], current);
                }
                else if (new_dist == info->dist[i]) {
                    LinkedListNode* existing_path = find_in_linked_list(info->prev[i], current);
                    if (existing_path == NULL) {
                        add_to_linked_list(info->prev[i], current);
                    }
                }
                add_to_linked_list(queue, i);
            }
        }
        info->visited[current] = 1;
    }
    
    free_linked_list(queue);
    return info;
}