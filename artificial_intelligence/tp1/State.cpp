#include "State.hpp"

using namespace std;

State::State(pair<int,int> coords, pair<int,int> par, int dep){
    this->coordinates = coords;
    this->parent = par;
    this->depth = dep;
}

pair<int,int> State::get_parent(){
    return this->parent;
}

void State::set_weight(double wei){
    this->weight = wei;
}

bool State::operator<(const State &a) const{
    return weight > a.weight;
}

double State::get_weight(){
    return this->weight;
}

int State::get_depth(){
    return this->depth;
}

pair<int,int> State::get_coordinates(){
    return this->coordinates;
}
