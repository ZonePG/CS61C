#include "list.h"

/* Add a node to the end of the linked list. Assume head_ptr is non-null. */
void append_node (node** head_ptr, int new_data) {
	/* First lets allocate memory for the new node and initialize its attributes */
	/* YOUR CODE HERE */

	/* If the list is empty, set the new node to be the head and return */
	if (*head_ptr == NULL) {
		/* YOUR CODE HERE */
        *head_ptr = (node *) malloc(sizeof(node));
        (*head_ptr)->next = NULL;
        (*head_ptr)->val = new_data;
		return;
	}
	node* curr = *head_ptr;
	while (curr->next != NULL) {
		curr = curr->next;
	}
	/* Insert node at the end of the list */
	/* YOUR CODE HERE */
    node *newNode = (node *) malloc(sizeof(node));
    newNode->next = NULL;
    newNode->val = new_data;
    curr->next = newNode;
}

/* Reverse a linked list in place (in other words, without creating a new list).
   Assume that head_ptr is non-null. */
void reverse_list (node** head_ptr) {
	node* prev = NULL;
	node* curr = *head_ptr;
	node* next = NULL;
	while (curr != NULL) {
		/* INSERT CODE HERE */
        next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
	}
	/* Set the new head to be what originally was the last node in the list */
	*head_ptr = prev;
}



