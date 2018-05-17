#include "ItemList.hpp"

ItemList::ItemList(){
    max_yr = 0;
    min_yr = 99999;
    total_avg.first = 0;
    total_avg.second = 0;
    //set<string> empty;
    //string test = "Genre";
    //possible_values.insert({test, empty});
    //possible_values.insert({"Language", empty});
    //possible_values.insert({"Country", empty});
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
    string item_name = item_json.substr(0,8);
    int item_n = get_item_number(item_name);
    item_json = item_json.substr(9);
    //cout << "Item json: "<< item_json << "\n";
    shared_ptr<Document> doc(new Document);
    //Document doc;
    (*doc).Parse(item_json.c_str());// parse a DOM tree
    unordered_map<int, shared_ptr<Document> >::iterator it = contents.find(item_n);
    if (it == contents.end()){
        contents.insert({item_n, doc});
    }
    Value& res = (*doc)["Response"];
    string response = res.GetString();
    //vector<string> used_fields;
    //used_fields.push_back("Genre");
    //used_fields.push_back("Language");
    //used_fields.push_back("Country");
    if (response.compare("True") == 0){

        Value& cont_yr = (*doc)["Year"];
        double this_yr = parse_double(cont_yr.GetString());
        //this_yr = (double) ((int) this_yr/10)*10;
        //cout << "Year: " << this_yr << "\n";
        if (this_yr > this->max_yr){
            this->max_yr = this_yr;
        }
        if (this_yr < this->min_yr){
            this->min_yr = this_yr;
        }
        // put possible value of genre
        Value& cont_genr = (*doc)["Genre"];
        string this_genres = cont_genr.GetString();
        vector<string> genres_split = split_comma(this_genres);
        for (vector<string>::iterator str_it = genres_split.begin(); str_it != genres_split.end(); str_it++){
            unordered_map<string,int>::iterator it_field = genre_n.find(*str_it);
            if (it_field == genre_n.end()){
                genre_n.insert({*str_it,1});
            }
            else{
                it_field->second++;
            }
        }
        
        // put possible value of language
        Value& cont_lang = (*doc)["Language"];
        string this_lang = cont_lang.GetString();
        vector<string> lang_split = split_comma(this_lang);
        for (vector<string>::iterator str_it = lang_split.begin(); str_it != lang_split.end(); str_it++){
            unordered_map<string,int>::iterator it_field = language_n.find(*str_it);
            if (it_field == language_n.end()){
                language_n.insert({*str_it,1});
            }
            else{
                it_field->second++;
            }
        }
        
        // put possible value of country
        Value& cont_count = (*doc)["Country"];
        string this_count = cont_count.GetString();
        vector<string> count_split = split_comma(this_count);
        for (vector<string>::iterator str_it = count_split.begin(); str_it != count_split.end(); str_it++){
            unordered_map<string,int>::iterator it_field = country_n.find(*str_it);
            if (it_field == country_n.end()){
                country_n.insert({*str_it,1});
            }
            else{
                it_field->second++;
            }
        }
        
        Value& imdb_rat = (*doc)["imdbRating"];
        double this_rat = parse_double(imdb_rat.GetString());
        item_avgs.insert({item_n,this_rat});
        total_avg.first += this_rat;
        total_avg.second += 1;
    }
    //cout << "Done!\n";
    //for (unordered_map<string,set<string> >::iterator it_pos = possible_values.begin(); it_pos != possible_values.end(); it_pos++){
    //    if (it_pos->first.compare("Genre")){
    //        Value& s = (*doc)["Genre"];
    //        string str = s.GetString();
    //        vector<string> values = split_comma(str);
    //        string genro("Genre");
    //        put_possible_values(values, genro);
    //    }
    //    else if (it_pos->first.compare("Language")){
    //        Value& s = (*doc)["Language"];
    //        string str = s.GetString();
    //        vector<string> values = split_comma(str);
    //        string lang("Language");
    //        put_possible_values(values, lang);
    //    }
    //    else if (it_pos->first.compare("Country")){
    //        Value& s = (*doc)["Country"];
    //        string str = s.GetString();
    //        vector<string> values = split_comma(str);
    //        string count("Country");
    //        put_possible_values(values, count);
    //    }
    //}
}

double ItemList::get_avg_rating(int item_num){
    unordered_map<int,double>::iterator it = item_avgs.find(item_num);
    if (it == item_avgs.end()){
        
        return total_avg.first/total_avg.second;
    }
    return it->second;
}

void ItemList::read_contents(string &filename){
    ifstream f(filename);
    string line;
    getline(f,line);
    while(getline(f,line)){
       //string item_name = line.substr(0,8);
       //cout << "Item: " << item_name << "\n";
       //int item_n = get_item_number(item_name);
       //string item_json = line.substr(9);
       //cout << "Json: " << item_json << "\n";
       parse_item(line);
    }
    //cout << "::Statistics:\n\tPossible genres: " << genre_n.size() << "\n\tPossible languages: " << language_n.size() << "\n\tPossible countries: " << country_n.size() << "\n\tMax year: " << max_yr << "\n\tMin year: " << min_yr << "\n";
    get_vector_names();
    compute_all_vectors();
}

void ItemList::get_vector_names(){
    // get thresholds
    int genre_th = 1;
    int language_th = 1;
    int country_th = 1;
    // loop through genres
    int n_pos = 0;
    for (unordered_map<string,int>::iterator it = genre_n.begin(); it != genre_n.end(); it++){
        if (it->second >= genre_th && (it->first.compare("N/A") != 0)){
            value_to_position.insert({it->first,n_pos});
            n_pos++;
        }
    }
    // loop through languages
    for (unordered_map<string,int>::iterator it = language_n.begin(); it != language_n.end(); it++){
        if (it->second >= language_th && (it->first.compare("N/A") != 0)){
            value_to_position.insert({it->first,n_pos});
            n_pos++;
        }
    }
    // loop through countries
    for (unordered_map<string,int>::iterator it = country_n.begin(); it != country_n.end(); it++){
        if (it->second >= country_th && (it->first.compare("N/A") != 0)){
            value_to_position.insert({it->first,n_pos});
            n_pos++;
        }
    }

    this->n_positions = n_pos;
    //cout << "Positions: " << n_pos << "\n\n";
    //for (map<string,int>::iterator asd=value_to_position.begin(); asd!=value_to_position.end(); asd++){
    //    cout << "Field: " << asd->first << "\t\tPosition: " << asd->second << "\n";
    //}
}

vector<double> ItemList::get_vector(int item_num){
    unordered_map<int, vector<double> >::iterator it_feat = features.find(item_num);
    if (it_feat != features.end()){
        return it_feat->second;
    }
    vector<double> empty;
    return empty;
}

// gets the item number, retrieves its doc and builds 
// its feature vector. concatenates the one-hot vectors
// starting with the greatest. if the vector is already
// computed, it retrieves it.
vector<double> ItemList::compute_vector(int item_num){//string &item_name){
    //int item_num = get_item_number(item_name); 
    //cout << "Preprocessing...\n";
    unordered_map<int, shared_ptr<Document> >::iterator it = contents.find(item_num); 
    shared_ptr<Document> doc = it->second;
    ////doc = make_shared<Document>(it->second);
    vector<double> vec(this->n_positions,0.0);
    //cout << "Npos: " << this->n_positions << "\n";
    Value& s = (*doc)["Response"];
    string val = s.GetString();
    if (val.compare("False") == 0){
        vector<double> empty;
        return empty;
    }

    s = (*doc)["Genre"];
    val = s.GetString();
    vector<string> vals = split_comma(val);
    int is_other = 1;
    for (vector<string>::iterator vals_it=vals.begin(); vals_it != vals.end(); vals_it++){
        map<string,int>::iterator pos_it = value_to_position.find(*vals_it);
    //    cout << "Pos: " << pos_it->second << "\n";
    //    cout << "vec size: " << vec.size() << "\n";
        if (pos_it != value_to_position.end()){
            is_other = 0;
            vec[pos_it->second] = 1;
        }
        //else if ((*vals_it).compare("N/A"))
    }
    vec.push_back(is_other);

    s = (*doc)["Language"];
    val = s.GetString();
    vals = split_comma(val);
    is_other = 1;
    for (vector<string>::iterator vals_it=vals.begin(); vals_it != vals.end(); vals_it++){
        map<string,int>::iterator pos_it = value_to_position.find(*vals_it);
        if (pos_it != value_to_position.end()){
            is_other = 0;
            vec[pos_it->second] = 1;
        }
    }
    vec.push_back(is_other);

    s = (*doc)["Country"];
    val = s.GetString();
    vals = split_comma(val);
    is_other = 1;
    for (vector<string>::iterator vals_it=vals.begin(); vals_it != vals.end(); vals_it++){
        map<string,int>::iterator pos_it = value_to_position.find(*vals_it);
        if (pos_it != value_to_position.end()){
            is_other = 0;
            vec[pos_it->second] = 1;
        }
    }
    vec.push_back(is_other);
    
    s = (*doc)["Year"];
    double year = parse_double(s.GetString());
    //year = (double) (((int) year/10)%100);
    //if (year <= 1)  year += 100;
    //year /= 10;
    //double decade = 
    vec.push_back((year - this->min_yr)/(this->max_yr - this->min_yr));
    //s = (*doc)["imdbRating"];
    //double rat = parse_double(s.GetString());

    //vec.push_back(3.5*rat/10);
    
    features.insert({item_num,vec});
    return vec;
}

void ItemList::compute_all_vectors(){
    //cout << "Contents size: " << contents.size() << "\n";
    for (unordered_map<int, shared_ptr<Document> >::iterator it = contents.begin(); it != contents.end(); it++){
        //cout << "AROLDO!!\n";

        //stringstream ss;
        //ss << 'i';
        //ss << setfill('0') << setw(7) << it->first;
        //string item_name = ss.str();
        vector<double> aux = compute_vector(it->first);
    }
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

vector<string> ItemList::split_comma(string &all){
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

double ItemList::parse_double(string value){
    stringstream ss(value);
    double val;
    ss >> val;
    return val;
}

vector<double> ItemList::get_onehot(string field, string value){
    vector<double> asd(12);
    return asd;
}

//ItemList::~ItemList(){
//    for (unordered_map<int,shared_ptr<Document> >::iterator it = contents.begin(); it != contents.end(); it++){
//        delete it->second;
//    }
//}
