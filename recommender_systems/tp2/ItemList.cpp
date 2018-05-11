#include "ItemList.hpp"

ItemList::ItemList(){
    set<string> empty;
    string test = "Genre";
    possible_values.insert({test, empty});
    possible_values.insert({"Language", empty});
    possible_values.insert({"Country", empty});
}

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
    Document* doc = new Document;
    //const char* item_c_str = item_json.c_str();
    doc->Parse(item_json.c_str());// parse a DOM tree
    //Value& s = doc["Year"];
    //string yr = s.GetString();
    //cout << "\n\nYear: " << yr << "\n";
    unordered_map<int, Document*>::iterator it = contents.find(item_n);
    if (it != contents.end()){
        contents.insert({item_n, doc});
    }
    //unordered_map<string, set<string> >::iterator it_pos = possible_values.find("Genre");
    for (unordered_map<string,set<string> >::iterator it_pos = possible_values.begin(); it_pos != possible_values.end(); it_pos++){
        if (it_pos->first.compare("Genre")){
            Value& s = (*doc)["Genre"];
            string str = s.GetString();
            vector<string> values = split_comma(str);
            string genro("Genre");
            put_possible_values(values, genro);
        }
        else if (it_pos->first.compare("Language")){
            Value& s = (*doc)["Language"];
            string str = s.GetString();
            vector<string> values = split_comma(str);
            string lang("Language");
            put_possible_values(values, lang);
        }
        else if (it_pos->first.compare("Country")){
            Value& s = (*doc)["Country"];
            string str = s.GetString();
            vector<string> values = split_comma(str);
            string count("Country");
            put_possible_values(values, count);
        }
    }
}

// gets the item number, retrieves its doc and builds 
// its feature vector. concatenates the one-hot vectors
// starting with the greatest. if the vector is already
// computed, it retrieves it.
vector<double> ItemList::compute_vector(string &item_name){
    int item_num = get_item_number(item_name);
    unordered_map<int, vector<double> >::iterator it_feat = features.find(item_num);
    if (it_feat != features.end()){
        return it_feat->second;
    }
    unordered_map<int, Document*>::iterator it = contents.find(item_num); 
    Document* doc = it->second;
    Value& s = (*doc)["Genre"];
    vector<double> vec = get_onehot("Genre", s.GetString());
    s = (*doc)["Language"];
    vector<double> aux = get_onehot("Language", s.GetString());
    vec.insert(vec.end(), aux.begin(), aux.end());
    s = (*doc)["Country"];
    aux = get_onehot("Country", s.GetString());
    vec.insert(vec.end(), aux.begin(), aux.end());
    s = (*doc)["Year"];
    double year = parse_double(s.GetString());
    vec.push_back((year - 1894)/(2016 - 1984));
    s = (*doc)["imdbRating"];
    double rat = parse_double(s.GetString());
    vec.push_back(rat/10);
    return vec;
}

void ItemList::put_possible_values(vector<string> values, string &field){
    unordered_map<string, set<string> >::iterator it = possible_values.find(field);
    for (vector<string>::iterator it_str = values.begin(); it_str != values.end(); it_str++){
        set<string>::iterator it_set = it->second.find(*it_str);
        if (it_set == it->second.end()){
            it->second.insert(*it_str);
        }
    }
}

vector<string> ItemList::split_comma(string all){
    int this_pos = 0;
    int comma_pos = 0;
    //cout << "String all: "<<all << "\n";
    vector<string> vec;
    while (comma_pos < string::npos){
        comma_pos = all.find(',',this_pos);
        //cout << "This: " << this_pos << "Comma: " << comma_pos << "\n";
        string aux = all.substr(this_pos,(comma_pos-this_pos));
        vec.push_back(aux);
        //cout << "Str aux: " << aux << "\n";
        this_pos = comma_pos+2;
    }
    return vec;
}

ItemList::~ItemList(){
    for (unordered_map<int,Document*>::iterator it = contents.begin(); it != contents.end(); it++){
        delete it->second;
    }
}
