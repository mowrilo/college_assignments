#ifndef PREDICTOR
#define PREDICTOR

#include <cmath>
#include <iostream>

#include "UserList.hpp"
#include "ItemList.hpp"

using namespace std;

class Predictor{
    public:
        Predictor(string ratings, string content);
        void predict(string targets);
        double cosine_sim(int item1, int item2);
    private:
        string rat_file;
        string cont_file;
        ItemList i_list;
        UserList u_list;
};

#endif
