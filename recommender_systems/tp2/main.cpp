#include <iostream>
#include <fstream>

#include "rapidjson/document.h"
#include "ItemList.hpp"

using namespace std;
using namespace rapidjson;

int main(){
    ItemList list;
    string all = "English, French, German, Portuguese";
    vector<string> asdasd =  list.split_comma(all);
    string asd("i0001234");
    int a = list.get_item_number(asd);
    cout << "number: " << a <<" \n\n";
    Document doc;
    string filename = "data/content.csv";
    ifstream f(filename);
    string line;
    getline(f,line);
    getline(f,line);
    cout << "Original line: " << line << "\n\n\n\n\n";
    //list.parse_item(line);
    int pos = line.find(',');
    line = line.substr(pos+1);
    cout << line << "\n";
    const char* line2 = line.c_str();
    doc.Parse(line2);
    //Value& s = doc["Year"];
    //int yr = s.GetInt();
    //cout << "\n\nYear: " << yr << "\n";
    return 0;
}
