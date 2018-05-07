#include <iostream>
#include <string>

#include "Agent.hpp"
#include "Environment.hpp"

using namespace std;

int main(int argc, char* argv[]){
    string file = argv[1];//"/home/murilo/Documentos/ia/tp1-IA/maps/map1.map";
    // ucs, ids, greedy_bfs, a_star
    string search_type = argv[2];//"a_star";
    string heuristic = argv[3];//"manhattan";
    int line_init = atoi(argv[4]);
    int col_init = atoi(argv[5]);
    int line_goal = atoi(argv[6]);
    int col_goal = atoi(argv[7]);
    Agent ag(file, search_type, heuristic, {line_init,col_init}, {line_goal,col_goal});
    ag.start_search();
    return 0;
}
