#include <fstream>
#include <iostream>
#include "structures/ItemList.hpp"

using namespace std;

class FileManager{
    public:
        FileManager(string path);
        ItemList read_csv(string file);
    private:
        string path;
};
