#include "hashmap.h" 

int *generate_weights(int n){
    int *weights = malloc(n*sizeof(int));
    for (int i=0; i<n; i++){
        weights[i] = rand() % 10000;
    }
    return weights;
}

int get_key(HashMap hm, char* value){
    int key = 0;
    for (int i=0; i<strlen(value); i++){
        key += (value[i] * hm.weights[i]);
    }
    return (key % TABLE_MAX);
}

void init_table(HashMap *hm){
    hm->size = 0;
    hm->weights = generate_weights(10);
    //hm->elements = calloc(TABLE_MAX,sizeof(Element));
    hm->positions = calloc(TABLE_MAX,sizeof(char));
}

void add_element(HashMap *hm, char *elem){
    int position = get_key(*hm, elem);
    char occupied = hm->positions[position];
    if (!occupied){
        hm->elements

}

int check_element(HashMap *hm, char *elem){
    return 0;
}
