#ifndef USER_LIST
#define USER_LIST

#include <fstream>
#include <iostream>
#include <unordered_map>
#include <utility>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

class UserList{
    public:
        UserList();
        int get_user_number(string &username);
        void add_rating(string &username, int item_n, int rating);
        //vector<double> get_uservec(string &username, vector<double> vector);
        //vector<double> get_user_vector(vector<pair<int,int> > ratings);
        void read_ratings(string &filename);
        void add_item_avg(int item_n, int rat);
        double get_item_avg(int item_n);
        void add_user_avg(int user_n, int rat);
        double get_user_avg(int user_n);
        vector<pair<int,int> > get_user_rat(int user_n);
    private:
        // maps a user's number to a vector of its ratings
        unordered_map<int, vector<pair<int, int> > > user_ratings;
        // user vectors
        unordered_map<int, vector<double> > user_vecs;
        // mean rating of each item
        unordered_map<int, pair<int,int> > item_avgs;
        // mean rating of each user
        unordered_map<int, pair<int,int> > user_avgs;
};

#endif
