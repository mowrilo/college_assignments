#ifndef STATE_CLASS
#define STATE_CLASS

#include <utility>

using namespace std;

class State{
    public:
        State(pair<int,int> coord, pair<int,int> par, int depth, double cost);
        pair<int,int> get_parent();
        void set_weight(double wei);
        bool operator<(const State &a) const;
        double get_weight();
        int get_depth();
        double get_cost();
        pair<int,int> get_coordinates();
    private:
        pair<int,int> coordinates;
        pair<int,int> parent;
        int depth;
        double weight;
        double cost;
};

#endif
