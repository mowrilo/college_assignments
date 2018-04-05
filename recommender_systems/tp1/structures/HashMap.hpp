#include <vector>
#include <unordered_map>
#include <string>
#include <vector>

#define MAX_WEIGHT 1000

using namespace std;

class HashMap{
    public:
        HashMap();//int nw=10);
        //void generate_weights();
        bool check_key(string key);
        void add_element(string element);
        int get_id(string element);
    private:
        unordered_map<string, int> id_map;
        int current_id;
        //vector<int> weights;
        //int n_weights;
}
