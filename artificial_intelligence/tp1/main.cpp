#include <iostream>
#include <string>

#include "Agent.hpp"
#include "Environment.hpp"

using namespace std;

int main(){
    string file = "/home/murilo/Documents/ia/tp1-IA/maps/map1.map";
    // ucs, ids, greedy_bfs, a_star
    string search_type = "greedy_bfs";
    string heuristic = "octile";
    Agent ag(file, search_type, heuristic, {0,0}, {247,245});
    ag.search();
  //  Environment env;
  ////  env.make_env(file);
    return 0;
}
