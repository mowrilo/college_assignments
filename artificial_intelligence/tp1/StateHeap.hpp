#ifndef HEAP_STRUC
#define HEAP_STRUC

#include <vector>

#include "State.hpp"

using namespace std;

class StateHeap{
    public:
        StateHeap();
        void push(State s);
        void pop();
        State top();
        void change_state(State s);
    
    protected:
        void min_heapify();
        int left(int pos);
        int right(int pos);
        int parent(int pos);
    
    private:
        vector<State> vec;
};

#endif
