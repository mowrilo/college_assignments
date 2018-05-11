#include "UserList.hpp"

using namespace std;

UserList::UserList(){}

int UserList::get_user_number(string &username){
    username.erase(username.begin());
    stringstream ss(username);
    int n;
    ss >> n;
    return n;
}

void UserList::add_rating(string &username, int item_n, int rating){
    int user_n = get_user_number(username);
    unordered_map<int, vector<pair<int, int> > >::iterator it = user_ratings.find(user_n);
    if (it == user_ratings.end()){
        vector<pair<int,int> > empty;
        empty.push_back({item_n,rating});
        user_ratings.insert({user_n,empty});
    }
    else{
        it->second.push_back({item_n,rating});
    }
}

//void UserList::add_uservec(string &username, vector<double> vector){
//
//}

//vector<double> get_

void UserList::read_ratings(string &filename){
    ifstream f(filename);
    string line;
    getline(f,line);
    while(getline(f,line)){
        string user_name = line.substr(0,8);
        string item_name = line.substr(9,8);
        int pos_comma = line.find(',',18);
        string rat_str = line.substr(18,pos_comma-18);
        stringstream ss(rat_str);
        int rat;
        ss >> rat;
        //cout << user_name << "  " << item_name << "  " << rat << "\n";
        //ItemList a;
        int item_n = get_user_number(item_name);
        add_rating(user_name, item_n, rat);
    }
}
