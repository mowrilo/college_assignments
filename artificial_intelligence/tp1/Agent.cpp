#include "Agent.hpp"

using namespace std;

Agent::Agent(string env_file, string type, string heur, pair<int,int> init_state, pair<int,int> goal_state){
//    try{
        env.make_env(env_file);
        this->init = init_state;
        this->goal = goal_state;
//        Environment new_env(string("no"));
//        this->env = new_env;
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
//        else {
//            throw e;
//        }
        if (heur.compare("manhattan") == 0){
            this->heuristic = 1;
        }
        else if (heur.compare("octile") == 0){
            this->heuristic = 2;
        }
        else{
            this->heuristic = 0;
        }
//    }
//    catch(e){
//        cout << "This algorithm does not exist here! \nTry:\n\t'ids' - Iterative Deepening Search\n\t'ucs' - Uniform-Cost Search\n\t'greedy_bfs' - Greedy Best-First Search\n\t'a_star' - A*\n";
//    }
}

// maybe save the values in a hash table to speed up
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
    return heur;
}

double Agent::calculate_weight(State &a){
    if (this->policy == 1){
        return a.get_depth();
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
        // parent weight - parent heuristic + 
        // distance(this,parent) + this heuristic
        pair<int,int> parent_coord = a.get_parent();
        int parent_number = get_state_number(parent_coord);
        State parent_state = visited_states.find(parent_number)->second;
        //cout << "aqui\n";
        double this_weight = parent_state.get_weight() - get_heuristic(parent_state);
        this_weight += get_distance(a, parent_state) + get_heuristic(a);
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
    //cout << "expanded " << coords.first << "\t" << coords.second << "\n";
    visited_states.insert({this_numb,a});
    vector<pair<int,int> > neighbors = get_neighbors(coords);
    pair<int,int> gen_goal(-2,-2);
    for (vector<pair<int,int> >::iterator it = neighbors.begin(); it != neighbors.end(); it++){
        if (*it == this->goal){
            gen_goal = *it;
        }
        //cout << "Neighbor: " << it->first << " " << it->second << "\n";
        char pos = env.query_state(*it);
        int numb = get_state_number(*it);
        //cout << " Pos: " << pos << " numb: " << numb << "\n";
        unordered_map<int,State>::iterator it_hash = visited_states.find(numb);
        if ((pos == '.') && (it_hash == visited_states.end())){
            //cout << "AEEE\n";
            unordered_map<int,double>::iterator it_front = frontier_costs.find(numb);
            State new_state(*it, coords, a.get_depth() + 1); 
            double new_weight = calculate_weight(new_state);
            new_state.set_weight(new_weight);
            if (it_front == frontier_costs.end()){
                queue.push(new_state);
                frontier_costs.insert({numb,new_weight});
            }
            else{
                if (new_weight < it_front->second){
//                    substitute_frontier(new_state);
                }
            }
        }
    }
    return gen_goal;
}

//void Agent::substitute_frontier(State &s){
//    pair<int,int> coords = s.get_coordinates();
//    priority_queue

vector<pair<int,int> > Agent::get_neighbors(pair<int,int> &coords){
    vector<pair<int,int> > neighbors;
    int width = env.get_width();
    int height = env.get_height();
    for (int i = -1; i<2; i++){ // i ranges from -1 to 1,
        for (int j = -1; j<2; j++){ // and so do j, to calculate the surrounding states
            if (j!=0 || i!=0){
                if (env.query_state({coords.first+i,coords.second+j}) == '.'){//(coords.first < height) && (coords.first >= 0) && (coords.second < width) && (coords.second >= 0)){
                    neighbors.push_back({coords.first+i,coords.second+j});
                }
            }
        }
    }
    return neighbors;
}

// explain in the documentation that the environemt is
// not part of the agent.
//void Agent::set_env(Environment env){
//    this->env = env;
//}

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

void Agent::search(){
    State current(this->init, {-1,-1}, 0);
    bool queue_empty = false;
    pair<int,int> current_coords = current.get_coordinates();
    while (current_coords != this->goal){
        pair<int,int> found_goal = expand_state(current);//expand current;
        if (found_goal.first >= 0){//depending on the algorithm, stop if generates goal;
            if (this->policy %2 == 1){
                State new_goal(found_goal,current.get_coordinates(),current.get_depth()+1);
                current = new_goal;
                break;
            }
        }
        if (queue.empty()){
            queue_empty = true;
            break;
        }//check queue empty;
        current = state_to_expand();
        current_coords = current.get_coordinates();
    }
    if (!queue_empty){
        cout << "Found the goal!!\n";
        stack<State> path = traceback(current);
        //for (int i=0; i<path.size(); i++){
        //    State st = path.top();
        //    path.pop();
        //    pair<int,int> coo = st.get_coordinates();
        //    cout << coo.first << "\t" << coo.second << "\n";
        //}
        env.print_path(path);
    }
    else{
        cout << "The goal was not found!!!\n";
    }
}

stack<State> Agent::traceback(State s){
    stack<State> trace;
    //cout << "Tracing back...\n";
    while(s.get_coordinates() != this->init){
        trace.push(s);
        pair<int,int> parent_coords = s.get_parent();
        int parent_number = get_state_number(parent_coords);
        //cout << "parent number: " << parent_number << "\n";
        unordered_map<int,State>::iterator it = visited_states.find(parent_number);
        s = it->second;
    }
    trace.push(s);
    return trace;
}
