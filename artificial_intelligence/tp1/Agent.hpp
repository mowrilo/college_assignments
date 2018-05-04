#ifndef AGENT_CLASS
#define AGENT_CLASS

#include <cmath>
#include <deque>
#include <queue>
#include <stack>
#include <unordered_map>

#include "Environment.hpp"
#include "State.hpp"

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
        //void set_env(Environment env);
        double get_heuristic(State &s);
        void search();
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
        priority_queue<State, deque<State> > queue;
        unordered_map<int,State> visited_states;
        unordered_map<int,double> frontier_costs;
        pair<int,int> init;
        pair<int,int> goal;
};


#endif
