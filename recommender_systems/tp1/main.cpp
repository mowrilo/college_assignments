#include <iostream>
#include "FileManager.hpp"
#include <set>
#include "Predictor.hpp"
#include <string>
#include <ctime>


int main(int argc, char* argv[]){
    string ratings(argv[1]);
    string targets(argv[2]);
    FileManager fm("");
    time_t t1,t2;
    time(&t1);
    ItemList in_list = fm.read_csv(ratings);
    Predictor p(targets);
    p.predict_all(in_list);
    time(&t2);
    double secs = difftime(t1,t2);
    cout << "Time elapsed: " << secs << "\n";
    return 0;
}
