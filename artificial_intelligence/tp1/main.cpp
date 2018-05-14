// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#include <chrono>
#include <iostream>
#include <string>

#include "Agent.hpp"
#include "Environment.hpp"

using namespace std;

int main(int argc, char* argv[]){
    string file = argv[1];
    // ucs, ids, greedy_bfs, a_star
    string search_type = argv[2];
    string heuristic = argv[3];
    int line_init = atoi(argv[4]);
    int col_init = atoi(argv[5]);
    int line_goal = atoi(argv[6]);
    int col_goal = atoi(argv[7]);
    Agent ag(file, search_type, heuristic, {line_init,col_init}, {line_goal,col_goal});
    // Uncomment to measure the search time
    //auto start = chrono::high_resolution_clock::now();
    ag.start_search();
    //auto end = chrono::high_resolution_clock::now();
    //auto time = end - start;
    //cout << "\nSearch took " << chrono::duration_cast<chrono::microseconds>(time).count() << " to run.\n";
    return 0;
}
