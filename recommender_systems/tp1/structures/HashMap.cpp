#include <cstdlib>
#include "HashMap.hpp"

using namespace std;

HashMap::HashMap();//int nw=10){
    //for (int i=0; i<nw; i++){
    //    int w = rand() % MAX_WEIGHT;
    //    weights.push_back(w);
    //}
    current_id = 0;
    id_map = new unordered_map<string,int>;
}

bool HashMap::check_key(string key){
    unordered_map<string,int>::iterator it = id_map.find(key);
    if (it != id_map.end()){
        return true;
    }
    return false;
}

void HashMap::add_element(string element){
    bool already_exists = check_key(element);
    if (!already_exists){
        id_map.insert({element, current_id});
        current_id++;
    }
}

int HashMap::get_id(string element){
    unordered_map<string,int>::iterator it = id_map.find(key);
    if (it == id_map.end()){
        return -1;
    }
    return it->second;
}
