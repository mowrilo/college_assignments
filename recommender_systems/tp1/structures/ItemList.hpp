#ifndef item_list
#define item_list

#include <string>
#include <vector>
#include <set>
#include <unordered_map>
#include <map>
#include <fstream>
#include <iostream>

using namespace std;

class ItemList{
    public:
        ItemList();
        void add_rating(string user, string item, int rating);
        int get_userid(string user);
        string get_username(int userid);
        void add_user(string user);
        unordered_map<int,int> get_itemratings(string item);
        int size();
        int n_users();
        void write_csv(string file);
        double get_user_avg(string user);
        double get_item_avg(string item);
        double general_avg();
        void compute_general_avgs();
        double get_genavg_item();
        double get_genavg_user();
        set<string> get_user_list(string user);
        vector<string> get_items();
    private:
        unordered_map<string,int> UserId;
        unordered_map<int,string> IdUser;
        double general_avg_item;
        double general_avg_user;
        int n_id;
        pair<double,double> gen_avg;
        unordered_map<string, unordered_map<int, int> > ItemRatings;
        map<string, pair<double,int> > UserAvg;
        map<string, pair<double,int> > ItemAvg;
        map<string, set<string> > UserList;
};

#endif
