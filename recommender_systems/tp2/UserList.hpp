#ifndef USER_LIST
#define USER_LIST

#include <unordered_map>
#include <string>

class UserList{
    public:
        UserList();
        extract_number(string &username);
        add_rating(string &username, string &item, int rating);
        add_uservec(string &username, vector<double> vector);
    private:
        // maps a user's number to a vector of its ratings
        unordered_map<int, vector<pair<int, int> > user_ratings;
        // user vectors
        unordered_map<int, vector<double> > user_vecs;
};

#endif
