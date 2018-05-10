#include "ItemList.hpp"

ItemList::ItemList(){}

// there are 7 characters of numbers
int ItemList::get_item_number(string &item_name){
    item_name.erase(item_name.begin());
    stringstream ss(item_name);
    int n;
    ss >> n;
    return n;
}

vector<double> ItemList::get_vector(string &item_name){

}

void ItemList::parse_item(string &item_json){
    //cout << "snvsdnfsdiuofsn\n\n" << item_json << "\n\n\n\n";
    string item_name = item_json.substr(0,8);
    //cout << "item name:\n\n" << item_name << "\n\n";
    int item_n = get_item_number(item_name);
    item_json.erase(0,9);
    //cout << "Item number: " << item_n << " \n Item JSON: " << item_json << "\n";
    Document doc;
    //const char* item_c_str = item_json.c_str();
    doc.Parse(item_json.c_str());// parse a DOM tree
    //Value& s = doc["Year"];
    //string yr = s.GetString();
    //cout << "\n\nYear: " << yr << "\n";
    unordered_map<int, Document>::iterator it = contents.find(item_n);
    if (it != contents.end()){
        contents.insert({item_n, doc});
    }
}

vector<double> compute_vector 
