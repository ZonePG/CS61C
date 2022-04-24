#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (head == NULL) {
        return 0;
    }

    node *tortoise = head;
    node *hare = head;

    do {
        hare = hare->next;
        if (hare == NULL) {
            return 0;
        }
        hare = hare->next;

        tortoise = tortoise->next;

        if (hare == tortoise) {
            return 1;
        }
    } while (tortoise && hare);
    
    return 0;
}