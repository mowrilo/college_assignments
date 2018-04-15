#include <iostream>
#include "FileManager.hpp"
//#include "structures/ItemList.hpp"

/*  TODO:
 *      Build similarity list
 *      Calculate predictions
 */

int main(int argc, char* argv[]){
    char *ratings = argv[1];
    char *targets = argv[2];
    FileManager fm("./data");
    ItemList in_list = fm.read_csv("ratings.csv");
    in_list.write_csv("./data/testratings.csv");
    return 0;
}
