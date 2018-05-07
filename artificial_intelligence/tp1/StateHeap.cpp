#include "StateHeap.hpp"

using namespace std;

StateHeap::StateHeap(){}

void StateHeap::push(State s){
    vec.push_back(s);
    push_heap(vec.begin(), vec.end());
}

void StateHeap::pop(){
    pop_heap(vec.begin(), vec.end());
    vec.pop_back();
}

State StateHeap::top(){
    return vec.front();
}

void StateHeap::change_state(State s){
    vector<State>::iterator it = vec.begin();
    pair<int,int> coords = it->get_coordinates();
    while ((coords != s.get_coordinates()) && (it != vec.end())){
        it++;
        coords = it->get_coordinates();
    }
    if (it != vec.end()){
        vec.erase(it);
        vec.push_back(s);
        push_heap(vec.begin(), vec.end());
    }
}

bool StateHeap::empty(){
    return (vec.size() <= 0);
}
