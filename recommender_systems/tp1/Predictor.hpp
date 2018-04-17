#include "structures/ItemList.hpp"
#include <string>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <sstream>
#include <unordered_set>
#include <functional>

using namespace std;

class Predictor{
    public:
        Predictor(string filename);
        void predict_all(ItemList &first_list);
        double adjusted_cosine(ItemList &list, string item1, string item2);
        double regular_cosine(unordered_map<int,int> &ratings1, double norm1, unordered_map<int,int> &ratings2, double norm2);
        double calculate_norm(unordered_map<int,int> &rat);
    private:
        string file_to_predict;
        unordered_map<string, unordered_map<string, double> > similars; //maps each item to a list
        unordered_map<string, double> norms;
};
