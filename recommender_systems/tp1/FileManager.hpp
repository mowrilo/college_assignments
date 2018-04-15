#include <fstream>
#include <iostream>
#include "structures/ItemList.hpp"

using namespace std;

class FileManager{
    public:
        FileManager(string path);
        ItemList read_csv(string file);
        //void write_csv(ItemList list, string file);
    private:
        string path;
};
