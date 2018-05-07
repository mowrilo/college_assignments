#include "State.hpp"

using namespace std;

State::State(pair<int,int> coords, pair<int,int> par, int dep, double cost){
    this->coordinates = coords;
    this->parent = par;
    this->depth = dep;
    this->cost = cost;
}

pair<int,int> State::get_parent(){
    return this->parent;
}

void State::set_weight(double wei){
    this->weight = wei;
}

bool State::operator<(const State &a) const{
    if (weight == a.weight){
        return cost < a.cost;
    }
    else{
        return weight > a.weight;
    }
}

double State::get_weight(){
    return this->weight;
}

int State::get_depth(){
    return this->depth;
}

double State::get_cost(){
    return this->cost;
}

pair<int,int> State::get_coordinates(){
    return this->coordinates;
}
