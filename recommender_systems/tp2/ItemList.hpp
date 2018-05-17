// this structure keeps the json structures 
// of the movies and metadata.
//
// planning to keep: year, genre, director, imdb rating, language, country
// year: 1894-2016
// imdbrating: 0-10
// genre: one-hot
// director: not using... (too many)
// language: one-hot
// country: one-hot
//
// 1. reads each line, parses and stores
// 2. reads the users into the user list
// 3. 

#ifndef ITEM_LIST
#define ITEM_LIST

#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <new>
#include <set>
#include <memory>
#include <string>
#include <sstream>
#include <unordered_map>
#include <vector>

#include "rapidjson/document.h"

using namespace std;
using namespace rapidjson;

class ItemList{
    public:
        ItemList();
        int get_item_number(string &item_name);
        double parse_double(string value);
        vector<double> get_vector(string &item_name);
        // parses the item's json and saves in its content hash
        void parse_item(string &item_json);
        vector<double> compute_vector(int item_num);//string &item_name);
        vector<double> get_vector(int item_num);
        void put_possible_values(vector<string> values, string &field);
        //bool has_value(string &field, string &value);
        //void add_value(string &field, string &value);
        void read_contents(string &filename);
        vector<string> split_comma(string &all);
        vector<double> get_onehot(string field, string value);    
        void get_vector_names();
        void compute_all_vectors();
        double get_avg_rating(int item_num);
        //~ItemList();
    private:
        // maps the item's name to its json structure
        unordered_map<int, shared_ptr<Document> > contents;
        unordered_map<string, int> genre_n;
        unordered_map<string, int> language_n;
        unordered_map<string, int> country_n;
        unordered_map<int, double> item_avgs;
        int n_positions;
        pair<double,double> total_avg;
        map<string, int> value_to_position;
        int max_yr;
        int min_yr;
        // maps a field of the features to its possible values
        // (one hot encoding)
        unordered_map<string, set<string> > possible_values;
        // maps the item to its vector of features
        unordered_map<int, vector<double> > features;
};

#endif
