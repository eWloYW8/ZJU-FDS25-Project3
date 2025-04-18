#include "LinkedList.h"

LinkedList* create_linked_list() {
    LinkedList* list = (LinkedList*)malloc(sizeof(LinkedList));
    list->head = NULL;
    list->tail = NULL;
    return list;
}

void add_to_linked_list(LinkedList* list, int data) {
    LinkedListNode* new_node = (LinkedListNode*)malloc(sizeof(LinkedListNode));
    new_node->data = data;
    new_node->next = NULL;
    
    if (list->head == NULL) {
        list->head = new_node;
        list->tail = new_node;
    } else {
        list->tail->next = new_node;
        list->tail = new_node;
    }
}

LinkedListNode* find_in_linked_list(LinkedList* list, int data) {
    LinkedListNode* current = list->head;
    while (current != NULL) {
        if (current->data == data) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

void remove_from_linked_list(LinkedList* list, int data) {
    LinkedListNode* current = list->head;
    LinkedListNode* previous = NULL;
    
    while (current != NULL && current->data != data) {
        previous = current;
        current = current->next;
    }
    
    if (current == NULL) return; // Data not found
    
    if (previous == NULL) {
        list->head = current->next; // Remove head
    } else {
        previous->next = current->next; // Remove middle or tail
    }
    
    if (current == list->tail) {
        list->tail = previous; // Update tail if necessary
    }
    
    free(current);
}

void free_linked_list(LinkedList* list) {
    LinkedListNode* current = list->head;
    LinkedListNode* next_node;
    
    while (current != NULL) {
        next_node = current->next;
        free(current);
        current = next_node;
    }
    
    free(list);
}