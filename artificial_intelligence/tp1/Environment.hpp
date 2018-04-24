#ifndef ENV_CLASS
#define ENV_CLASS

#include <new>
#include <string>
#include <iostream>
#include <fstream>

using namespace std;

class Environment{
    public:
        Environment(string &file_name);
        char query_state(int position);
        pair<int,int> convert_coordinates(int position);
        int get_dimension(string &line);
        ~Environment();
    private:
        char **grid;
        string name;
        int height;
        int width;
};

#endif
