// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#ifndef ENV_CLASS
#define ENV_CLASS

#include <new>
#include <string>
#include <iostream>
#include <fstream>
#include <stack>

#include "State.hpp"

using namespace std;

class Environment{
    public:
        Environment();
        void make_env(string &file_name);
        char query_state(pair<int,int> coordinates);
        pair<int,int> convert_coordinates(int position);
        void print_path(stack<State> &stack);
        int get_dimension(string &line);
        int get_height();
        int get_width();
        ~Environment();
    private:
        char **grid;
        string name;
        int height;
        int width;
};

#endif
