#include "FileManager.hpp"
//#include "structures/ItemList.hpp"

using namespace std;

FileManager::FileManager(string path){
    this->path = path;
}

ItemList FileManager::read_csv(string file){
    string line;
    string complete_path = this->path + "/" + file;
    ifstream f(complete_path);
    ItemList list;
    if (f){
        getline(f,line);
        while (getline(f,line)){
            //cout << line << "\n";
            //cout << "a\n";
            int colon = line.find(":");
            string user = line.substr(0,colon);
            int comma = line.find(",");
            string item = line.substr(colon+1,(comma-colon-1));
            //comma = line.find(",",comma);
            line = line.substr(comma+1,(line.find(",",comma+1) - comma - 1));
            int rating = stoi(line);
            //cout << user << "  " << item << "  " << rating << "\n\n";
            list.add_rating(user,item,rating);
        }
        f.close();
        //cout << "AEHOOOO\n\n\n\n\n";
    }
    //ItemList a;
    cout << "List size: " << list.size() << "\nN Users: " << list.n_users() << "\n";
    return list;
}

//void FileManager::write_csv(ItemList list, string file){
//    string complete_path = this->path + "/" + file;
//    ofstream f (complete_path);
//    f << "UserId:ItemId,Prediction\n";
//    unordered_map<string, set<pair<int, int> > >::iterator it;
//    for (it = list.ItemRatings.begin(); it != list.ItemRatings.end(); ++it){
//        string item = it->first;
//        set<pair<int,int> > user_list = it->second;
//        for (set<pair<int,int> >::iterator user_it = user_list.begin(); user_it != user_list.end(); ++user_it){
//            int user_id = user_it->first;
//            int rating = user_it->second;
//            unordered_map<int,string>::iterator find_user = list.IdUser.find(user_id);
//            string user = find_user->second;
//            f << user << ":" << item << "," << rating << "\n";
//        }
//    }
//}
