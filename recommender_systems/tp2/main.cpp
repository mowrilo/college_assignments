#include <iostream>
#include <fstream>

#include "rapidjson/document.h"

using namespace std;
using namespace rapidjson;

int main(){
    Document doc;
    string filename = "data/content.csv";
    ifstream f(filename);
    string line;
    getline(f,line);
    getline(f,line);
    int pos = line.find(',');
    line = line.substr(pos+1);
    cout << line << "\n";
    const char* line2 = line.c_str();
    doc.Parse(line2);
    Value& s = doc["Year"];
    string yr = s.GetString();
    cout << "\n\nYear: " << yr << "\n";
    return 0;
}
