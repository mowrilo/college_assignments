#include "UserList.hpp"

using namespace std;

UserList::UserList(){}

int ItemList::get_user_number(string &username){
    username.erase(username.begin());
    stringstream ss(username);
    int n;
    ss >> n;
    return n;
}

void add_rating(string &username, int item_n, int rating){
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

void add_uservec(string &username, vector<double> vector){

}


