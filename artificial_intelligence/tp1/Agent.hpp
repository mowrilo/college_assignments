// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#ifndef AGENT_CLASS
#define AGENT_CLASS

#include <cmath>
#include <deque>
#include <queue>
#include <stack>
#include <unordered_map>

#include "Environment.hpp"
#include "StateQueue.hpp"
#include "State.hpp"

#define INT_MAX 2147483647

using namespace std;

class Agent{
    public:
        Agent(string env_file, string type, string heur, pair<int,int> init_state, pair<int,int> goal_state);
        double calculate_weight(State &a);
        State state_to_expand();
        // The state has: coordinates, parent, depth
        pair<int,int> expand_state(State &a); // if the goal is expanded, return true
        vector<pair<int,int> > get_neighbors(pair<int,int> &coords);
        stack<State> traceback(State s); //traces back the path to the root
        int get_state_number(pair<int,int> &s);
        double get_heuristic(State &s);
        // search returns -1 if goal is found; returns the max depth reached otherwise
        int search(int max_depth);
        void forget_all();
        void start_search();
        double get_distance(State &a, State &b);
    private:
        // which type of search, according to the input
        //      1 - Iterative Deepening Search (IDS)
        //      2 - Uniform-Cost Search (UCS)
        //      3 - Greedy Best-First Search
        //      4 - A*
        int policy;
        int heuristic;
        Environment env;
        // A FIFO queue, as well as a LIFO stack, can
        // be implemented using a priority queue
        // The stack can be implemented using the 
        // depth of the node as weight.
        //priority_queue<State, deque<State> > queue;
        StateQueue queue;
        unordered_map<int,State> visited_states;
        unordered_map<int,double> frontier_costs;
        pair<int,int> init;
        pair<int,int> goal;
};


#endif
