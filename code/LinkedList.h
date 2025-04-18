#pragma once

#include <stdlib.h>

typedef struct LinkedListNode {
    int data;
    struct LinkedListNode* next;
} LinkedListNode;

typedef struct LinkedList {
    LinkedListNode* head;
    LinkedListNode* tail;
} LinkedList;

LinkedList* create_linked_list();

void add_to_linked_list(LinkedList* list, int data);

LinkedListNode* find_in_linked_list(LinkedList* list, int data);

void remove_from_linked_list(LinkedList* list, int data);

void free_linked_list(LinkedList* list);