#include <string>
#include "structures/ItemList.hpp"

using namespace std;

class SimilarityList{
    public:
        void calculate_sims(ItemList list, int n);

    private:
        unordered_map<string, vector<pair<
