#include <iostream>
#include <string>

#include "Agent.hpp"
#include "Environment.hpp"

using namespace std;

int main(){
    string file = "/home/murilo/Documentos/ia/tp1-IA/maps/map1.map";
    // ucs, ids, greedy_bfs, a_star
    string search_type = "ucs";
    string heuristic = "manhattan";
    Agent ag(file, search_type, heuristic, {0,0}, {184,139});
    ag.start_search();
  //  Environment env;
  ////  env.make_env(file);
    return 0;
}
