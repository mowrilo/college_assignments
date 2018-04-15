#include <string>
#include <vector>
#include <set>
#include <unordered_map>
#include <fstream>

using namespace std;

class ItemList{
    public:
        ItemList();
        void add_rating(string user, string item, int rating);
        int get_userid(string user);
        void add_user(string user);
        //void sort_ratings(); //sorts the items's ratings by user id
        set<pair<int,int> > get_itemratings(string item);
        int size();
        int n_users();
        void write_csv(string file);
    private:
        unordered_map<string,int> UserId;
        unordered_map<int,string> IdUser;
        int n_id;
        unordered_map<string, set<pair<int, int> > > ItemRatings;
};
