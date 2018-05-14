// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#ifndef HEAP_STRUC
#define HEAP_STRUC

#include <algorithm>
#include <iostream>
#include <utility>
#include <stack>
#include <vector>

#include "State.hpp"

using namespace std;

class StateQueue{
    public:
        StateQueue();
        void set_ids(bool ids);
        void push(State s);
        void pop();
        State top();
        void change_state(State s);
        bool empty();
    
    private:
        vector<State> vec;
        bool is_ids;
        stack<State> st;
};

#endif
