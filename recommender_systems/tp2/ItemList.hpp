// this structure keeps the json structures 
// of the movies and metadata.
//
// planning to keep: year, genre, director, imdb rating, language, country
// year: 1894-2016
// imdbrating: 0-10
// genre: one-hot
// director: not using... (too many)
// language: one-hot
// country: one-hot

#ifndef ITEM_LIST
#define ITEM_LIST



class ItemList{
    public:
        ItemList();
        int get_itemnumber(string &item_name);
        vector<double> get_vector(string &item_name);
    private:
        // maps the item's name to its json structure
        unordered_map<int, Document> contents;
        map<string, int> genre_n;
        // maps the item to its vector of features
        unordered_map<int, vector<double> > features;
};

#endif
