#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/* Predictions are based on a 0-10 scale.
 * Imputations may be: 0, mean, -1
 * Orientation: 0 - user, 1 - item
 */

//float***
void read_matrix(char* filename, int orientation){
    int a = strlen(filename);
    printf("Length: %d\n%s\n",a,filename);
   // FILE *f = fopen(filename,'r');
   // float*** = malloc(sizeof(float**));
}
