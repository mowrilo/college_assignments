#include "ItemList.hpp"

using namespace std;

ItemList::ItemList(){
    this->n_id = 0;
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

void ItemList::add_rating(string user, string item, int rating){
    unordered_map<string, set<pair<int,int> > >::iterator it = ItemRatings.find(item);
    if (it == ItemRatings.end()){
        set<pair<int, int> > ratings;
        ItemRatings.insert({item,ratings});
        it = ItemRatings.find(item);
    }
    int user_id = get_userid(user);
    if (user_id < 0){
        add_user(user);
        user_id = get_userid(user);
    }
    it->second.insert({user_id,rating});
}

set<pair<int,int> > ItemList::get_itemratings(string item){
    unordered_map<string, set<pair<int,int> > >::iterator it = ItemRatings.find(item);
    if (it == ItemRatings.end()){
        set<pair<int,int> > empty;
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
    //string complete_path = this->path + "/" + file;
    ofstream f (file);
    f << "UserId:ItemId,Prediction\n";
    unordered_map<string, set<pair<int, int> > >::iterator it;
    for (it = ItemRatings.begin(); it != ItemRatings.end(); ++it){
        string item = it->first;
        set<pair<int,int> > user_list = it->second;
        for (set<pair<int,int> >::iterator user_it = user_list.begin(); user_it != user_list.end(); ++user_it){
            int user_id = user_it->first;
            int rating = user_it->second;
            unordered_map<int,string>::iterator find_user = IdUser.find(user_id);
            string user = find_user->second;
            f << user << ":" << item << "," << rating << "\n";
        }
    }
}
