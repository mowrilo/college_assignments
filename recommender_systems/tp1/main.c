#include <stdio.h>
#include "structures/hashmap.h"
#include "data_manager.h"
// read csv
// write csv
// item (most probably) or user based
// similarity calculation (adjusted cosine at first)
// neighborhood size ~ 30
// prediction method (weighted average)
// pruning??


int main(int argc,char* argv[]){
    char* ratings = argv[1];
    char* targets = argv[2];
    char* asd;
    //read_matrix(ratings, 1);
    char* a = "u9999999";
    int k = 0;
    for (int i=0; i<strlen(a); i++){
        k += (rand() % 10000) * a[i];
    }
    char *aa;
    aa = calloc(3,sizeof(char));
    aa[1] = 1;
    //Element *el = calloc(1,sizeof(Element));
    if (aa[1] == 0){printf("Occupied\n\n");}
    printf("tamanho: %zd\n",sizeof(char));
    //int bla = strlen(asd);
    printf("%c\n",aa[0]);
    return 0;
}
