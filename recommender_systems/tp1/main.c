#include <stdio.h>
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
    read_matrix(ratings, 1);
    return 0;
}
