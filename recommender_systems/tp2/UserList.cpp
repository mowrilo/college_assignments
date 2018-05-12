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
        int item_n = get_user_number(item_name);
        int user_n = get_user_number(user_name);
        add_item_avg(item_n, rat);
        add_user_avg(user_n, rat);
        //cout << user_name << "  " << item_name << "  " << rat << "\n";
        //ItemList a;
        add_rating(user_name, item_n, rat);
    }
}

void UserList::add_item_avg(int item_n, int rat){
    unordered_map<int, pair<int,int> >::iterator it = item_avgs.find(item_n);
    if (it == item_avgs.end()){
        pair<int,int> aux(rat,1);
        item_avgs.insert({item_n,aux});
    }
    else {
        it->second.first += rat;
        it->second.second += 1;
    }
}

void UserList::add_user_avg(int user_n, int rat){
    unordered_map<int, pair<int,int> >::iterator it = user_avgs.find(user_n);
    if (it == user_avgs.end()){
        pair<int,int> aux(rat,1);
        user_avgs.insert({user_n,aux});
    }
    else {
        it->second.first += rat;
        it->second.second += 1;
    }
}

double UserList::get_item_avg(int item_n){
    unordered_map<int, pair<int,int> >::iterator it = item_avgs.find(item_n);
    if (it == item_avgs.end()){
        return -1;
    }
    double avg = ((double) it->second.first)/((double) it->second.second);
    return avg;
}

double UserList::get_user_avg(int user_n){
    unordered_map<int, pair<int,int> >::iterator it = user_avgs.find(user_n);
    if (it == user_avgs.end()){
        return -1;
    }
    double avg = ((double) it->second.first)/((double) it->second.second);
    return avg;
}

vector<pair<int,int> > UserList::get_user_rat(int user_n){
    unordered_map<int, vector<pair<int,int> > >::iterator it = user_ratings.find(user_n);
    if (it == user_ratings.end()){
        vector<pair<int,int> > empty;
        return empty;
    }
    else{
        return it->second;
    }
}

