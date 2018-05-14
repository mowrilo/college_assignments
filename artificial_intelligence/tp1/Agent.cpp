// Trabalho Prático 1 - Inteligência Artificial (DCC028)
// Autor: Murilo Vale Ferreira Menezes (2013030996)

#include "Agent.hpp"

using namespace std;

Agent::Agent(string env_file, string type, string heur, pair<int,int> init_state, pair<int,int> goal_state){
    env.make_env(env_file);
    this->init = init_state;
    this->goal = goal_state;
    if (type.compare("ids") == 0){
        this->policy = 1;
    }
    else if (type.compare("ucs") == 0){
        this->policy = 2;
    }
    else if (type.compare("greedy_bfs") == 0){
        this->policy = 3;
    }
    else if (type.compare("a_star") == 0){
        this->policy = 4;
    }

    if (heur.compare("manhattan") == 0){
        this->heuristic = 1;
    }
    else if (heur.compare("octile") == 0){
        this->heuristic = 2;
    }
    else{
        this->heuristic = 0;
    }

    queue.set_ids(this->policy == 1);
}

double Agent::get_heuristic(State &s){
    double heur = 0;
    pair<int,int> coords = s.get_coordinates();
    double dx = abs(coords.first - this->goal.first);
    double dy = abs(coords.second - this->goal.second);
    if (this->heuristic == 1){ // manhattan distance
        heur = dx + dy;
    }
    else if (this->heuristic == 2){ // octile distance
        heur = max(dx,dy) + .5*min(dx,dy);
    }
    double w = 1;
    return w*heur;
}

double Agent::calculate_weight(State &a){
    if (this->policy == 1){
        return -a.get_depth();
    }
    else if (this->policy == 2){
        // cost is the cost of getting to the parent +
        // the cost of the parent to this node
        pair<int,int> parent_coord = a.get_parent();
        int parent_number = get_state_number(parent_coord);
        State parent_state = visited_states.find(parent_number)->second;
        double this_weight = get_distance(a, parent_state) + parent_state.get_weight();
        return this_weight;
    }
    else if (this->policy == 3){
        // get heuristic
        return get_heuristic(a);
    }
    else if (this->policy == 4){
        double this_weight = a.get_cost() + get_heuristic(a);
        return this_weight;
    }

}

State Agent::state_to_expand(){
    State exp = queue.top();
    queue.pop();
    return exp;
}

// the expansion of a state consists in taking a node from
// the open list (queue), putting its neighbors (that had not
// been already expanded) in the queue and then putting the 
// node in the closed list.
pair<int,int> Agent::expand_state(State &a){
    pair<int,int> coords = a.get_coordinates();
    int this_numb = get_state_number(coords);
    visited_states.insert({this_numb,a});
    vector<pair<int,int> > neighbors = get_neighbors(coords);
    pair<int,int> gen_goal(-2,-2);
    for (vector<pair<int,int> >::iterator it = neighbors.begin(); it != neighbors.end(); it++){
        if (*it == this->goal){
            gen_goal = *it;
        }
        char pos = env.query_state(*it);
        int numb = get_state_number(*it);
        unordered_map<int,State>::iterator it_hash = visited_states.find(numb);
        if ((pos == '.') && (it_hash == visited_states.end())){
            unordered_map<int,double>::iterator it_front = frontier_costs.find(numb);
            pair<int,int> coords_2 = *it;
            double dist = abs(coords_2.first - coords.first) + abs(coords_2.second - coords.second);
            if (dist == 2){
                dist = 1.5;
            }
            State new_state(*it, coords, a.get_depth() + 1,a.get_cost()+dist); 
            double new_weight = calculate_weight(new_state);
            new_state.set_weight(new_weight);
            if (it_front == frontier_costs.end()){
                queue.push(new_state);
                frontier_costs.insert({numb,new_weight});
            }
            else{
                if (new_weight < it_front->second){

                    if (this->policy % 2 == 0){
                        queue.change_state(new_state);
                    }
                    it_front->second = new_weight;
                }
            }
            
        }
    }
    return gen_goal;
}


vector<pair<int,int> > Agent::get_neighbors(pair<int,int> &coords){
    vector<pair<int,int> > neighbors;
    int width = env.get_width();
    int height = env.get_height();
    for (int i = -1; i<2; i++){ // i ranges from -1 to 1,
        for (int j = -1; j<2; j++){ // and so do j, to calculate the surrounding states
            if (j!=0 || i!=0){
                if (env.query_state({coords.first+i,coords.second+j}) == '.'){
                    if (i != 0 && j != 0){
                        char diag1 = env.query_state({coords.first+i,coords.second});
                        char diag2 = env.query_state({coords.first,coords.second+j});
                        if (diag1 == '.' && diag2 == '.'){
                            neighbors.push_back({coords.first+i,coords.second+j});
                        }
                    }
                    else{
                        neighbors.push_back({coords.first+i,coords.second+j});
                    }
                }
            }
        }
    }
    return neighbors;
}

int Agent::get_state_number(pair<int,int> &s){
    int width = env.get_width();
    return (s.second + width*s.first);
}

// calculate distance, provided that the two states
// are neighbors.
double Agent::get_distance(State &a, State &b){
    double dist = 1;
    pair<int,int> coord_a = a.get_coordinates();
    pair<int,int> coord_b = b.get_coordinates();
    if ((abs(coord_a.first - coord_b.first) + abs(coord_a.second - coord_b.second)) == 2){
        dist += .5;
    }
    return dist;
}

int Agent::search(int max_depth){
    State current(this->init, {-1,-1}, 0, 0);
    int depth_reached = 0;
    bool queue_empty = false;
    bool reached_max_depth = false;
    pair<int,int> current_coords = current.get_coordinates();
    while (current_coords != this->goal){
        if (current.get_depth() < max_depth){
            pair<int,int> found_goal = expand_state(current);//expand current;
            if (found_goal.first >= 0){//depending on the algorithm, stop if generates goal;
                if (this->policy %2 == 1){
                    double dist = abs(current_coords.first - found_goal.first) + abs(current_coords.second - found_goal.second);
                    State new_goal(found_goal,current.get_coordinates(),current.get_depth()+1, current.get_cost() + dist);
                    current = new_goal;
                    break;
                }
            }
        }

        if (queue.empty()){
            queue_empty = true;
            return depth_reached;
        }//check queue empty;
        current = state_to_expand();
        current_coords = current.get_coordinates();
        if (current.get_depth() > depth_reached){
            depth_reached = current.get_depth();
        }
        if (current_coords == this->goal){
            pair<int,int> dummy = expand_state(current);
        }
    }

    stack<State> path = traceback(current);
    // uncomment these lines to print the size of the structures
    //cout << "Total number of states expanded: " << visited_states.size() << "\n";
    //cout << "Total number of states in path: " << path.size() << "\n";
    pair<int,int> goal_coords = current.get_coordinates();
    cout << "<" << init.first << ", " << init.second << ", 0>\n";
    cout << "<" << goal_coords.first << ", " << goal_coords.second << ", " << current.get_cost() << ">\n\n";
        
    env.print_path(path);
    return -1;
}

void Agent::forget_all(){
    visited_states.clear();
    frontier_costs.clear();
    StateQueue empty_queue;
    empty_queue.set_ids(this->policy == 1);
    queue = empty_queue;
}

void Agent::start_search(){
    if (env.query_state({init.first, init.second}) == '@'){
        cout << "<" << init.first << ", " << init.second << ", 0>\n";
        cout << "<" << goal.first << ", " << goal.second << ", inf>";
        return;
    }
    int result = 1;
    if (this->policy == 1){// if IDS
        int depth = 1;
        bool no_improve = false;
        while ((result > 0) && (!no_improve)){
            forget_all();
            result = search(depth);
            if ((result < depth) && (result > 0)){ // if the max depth reached is lower than the limit
                no_improve = true;
                cout << "<" << init.first << ", " << init.second << ", 0>\n";
                cout << "<" << goal.first << ", " << goal.second << ", inf>";
            }
            depth++;
        }
    }
    else{
        // the maximum depth is infinity in practice.
        result = search(INT_MAX);
        if (result > 0){
            cout << "<" << init.first << ", " << init.second << ", 0>\n";
            cout << "<" << goal.first << ", " << goal.second << ", inf>";
        }
    }
}

stack<State> Agent::traceback(State s){
    stack<State> trace;
    while(s.get_coordinates() != this->init){
        trace.push(s);
        pair<int,int> parent_coords = s.get_parent();
        int parent_number = get_state_number(parent_coords);
        unordered_map<int,State>::iterator it = visited_states.find(parent_number);
        s = it->second;
    }
    trace.push(s);
    return trace;
}
