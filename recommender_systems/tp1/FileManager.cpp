#include "FileManager.hpp"
//#include "structures/ItemList.hpp"

using namespace std;

FileManager::FileManager(string path){
    this->path = path;
}

ItemList FileManager::read_csv(string file){
    string line;
    string complete_path = file;
    ifstream f(complete_path);
    ItemList list;
    if (f){
        getline(f,line);
        while (getline(f,line)){
            int colon = line.find(":");
            string user = line.substr(0,colon);
            int comma = line.find(",");
            string item = line.substr(colon+1,(comma-colon-1));
            line = line.substr(comma+1,(line.find(",",comma+1) - comma - 1));
            int rating = stoi(line);
            list.add_rating(user,item,rating);
        }
        f.close();
    }
    list.compute_general_avgs();
    return list;
}
