#include "ItemList.hpp"

using namespace std;

ItemList::ItemList(){
    this->n_id = 0;
    pair<double,double> a(0,0);
    gen_avg = a;
}

int ItemList::get_userid(string user){
    unordered_map<string,int>::iterator it = UserId.find(user);
    if (it != UserId.end()){
        return it->second;
    }
    return -1;
}

void ItemList::add_user(string user){
    if (get_userid(user) < 0){
        UserId.insert({user,n_id});
        IdUser.insert({n_id,user});
        n_id++;
    }
}

void ItemList::compute_general_avgs(){
    double a = 0;
    map<string, pair<double,int> >::iterator it;
    for (it = ItemAvg.begin(); it!=ItemAvg.end(); it++){
        a += it->second.first/((double) it->second.second);
    }
    this->general_avg_item = a/((double) ItemAvg.size());
    a = 0;
    for (it = UserAvg.begin(); it!=UserAvg.end(); it++){
        a += it->second.first/((double) it->second.second);
    }
    this->general_avg_user = a/((double) UserAvg.size());
}

double ItemList::get_genavg_item(){
    return this->general_avg_item;
}

double ItemList::get_genavg_user(){
    return this->general_avg_user;
}

void ItemList::add_rating(string user, string item, int rating){
    gen_avg.first += (double) rating;
    gen_avg.second++;
    unordered_map<string, unordered_map<int,int> >::iterator it = ItemRatings.find(item);
    if (it == ItemRatings.end()){
        unordered_map<int, int> ratings;
        ItemRatings.insert({item,ratings});
        it = ItemRatings.find(item);
        ItemAvg.insert({item, {0,0}});
    }
    int user_id = get_userid(user);
    if (user_id < 0){
        set<string> empty;
        UserList.insert({user,empty});
        add_user(user);
        user_id = get_userid(user);
        UserAvg.insert({user, {0,0}});
    }
    it->second.insert({user_id,rating});
    map<string, set<string> >::iterator userlist_it = UserList.find(user);
    userlist_it->second.insert(item);

    map<string, pair<double,int> >::iterator user_it = UserAvg.find(user);
    user_it->second.first += rating;
    user_it->second.second += 1;
    map<string, pair<double,int> >::iterator item_it = ItemAvg.find(item);
    item_it->second.first += rating;
    item_it->second.second += 1;
}

string ItemList::get_username(int userid){
    unordered_map<int,string>::iterator it = IdUser.find(userid);
    return it->second;
}

set<string> ItemList::get_user_list(string user){
    map<string, set<string> >::iterator it = UserList.find(user);
    if (it == UserList.end()){
        set<string> empty;
        return empty;
    }
    return it->second;
}

vector<string> ItemList::get_items(){
    vector<string> items;
    for (map<string, pair<double,int> >::iterator it = ItemAvg.begin(); it != ItemAvg.end(); ++it){
        items.push_back(it->first);
    }
    return items;
}

double ItemList::get_user_avg(string user){
    map<string, pair<double,int> >::iterator it = UserAvg.find(user);
    if (it == UserAvg.end()){
        return -1;
    }
    double average = it->second.first/((double) it->second.second);
    return average;
}

double ItemList::general_avg(){
    return (gen_avg.first/gen_avg.second);
}

double ItemList::get_item_avg(string item){
    map<string, pair<double,int> >::iterator it = ItemAvg.find(item);
    if (it == ItemAvg.end()){
        return -1;
    }
    double average = it->second.first/((double) it->second.second);
    return average;
}

unordered_map<int,int> ItemList::get_itemratings(string item){
    unordered_map<string, unordered_map<int,int> >::iterator it = ItemRatings.find(item);
    if (it == ItemRatings.end()){
        unordered_map<int,int> empty;
        return empty;
    }
    return it->second;
}

int ItemList::size(){
    return ItemRatings.size();
}

int ItemList::n_users(){
    return UserId.size();
}

void ItemList::write_csv(string file){
    ofstream f (file);
    f << "UserId:ItemId,Prediction\n";
    unordered_map<string, unordered_map<int, int> >::iterator it;
    for (it = ItemRatings.begin(); it != ItemRatings.end(); ++it){
        string item = it->first;
        unordered_map<int,int> user_list = it->second;
        for (unordered_map<int,int>::iterator user_it = user_list.begin(); user_it != user_list.end(); ++user_it){
            int user_id = user_it->first;
            int rating = user_it->second;
            unordered_map<int,string>::iterator find_user = IdUser.find(user_id);
            string user = find_user->second;
            f << user << ":" << item << "," << rating << "\n";
        }
    }
}
