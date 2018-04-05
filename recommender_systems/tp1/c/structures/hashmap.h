#include <stdlib.h>
#include <string.h>
#define TABLE_MAX 50033

typedef struct Element{
    char *name;
    int occupied;
    struct Element *next;
} Element;

typedef struct HashMap{
    Element *elements;
    int size;
    int *weights; 
    char *positions;
} HashMap;

int* generate_weights(int n);

int get_key(HashMap hm, char* value);

void init_table(HashMap *hm);

void add_element(HashMap *hm, char *elem);

int check_element(HashMap *hm, char *elem);
