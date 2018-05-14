// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#include "StateQueue.hpp"

using namespace std;

StateQueue::StateQueue(){};

void StateQueue::set_ids(bool ids){
    this->is_ids = ids;
}

void StateQueue::push(State s){
    if (is_ids){
        st.push(s);
    }
    else{
        vec.push_back(s);
        make_heap(vec.begin(), vec.end());
    }
}

void StateQueue::pop(){
    if (is_ids){
        st.pop();
    }
    else{
        vec.erase(vec.begin());
        make_heap(vec.begin(),vec.end());
    }
}

State StateQueue::top(){ 
    if (is_ids){
        State a = st.top();
        //cout << "COST: " << a.get_cost() << "\n";
        return st.top();
    }
    return vec.front();
}

void StateQueue::change_state(State s){
    vector<State>::iterator it = vec.begin();
    pair<int,int> coords = it->get_coordinates();
    while ((coords != s.get_coordinates()) && (it != vec.end())){
        it++;
        coords = it->get_coordinates();
    }
    if (it != vec.end()){
        vec.erase(it);
        push(s);
    }
}

bool StateQueue::empty(){
    if (is_ids){
        return st.empty();
    }
    return (vec.size() <= 0);
}
