#include "Predictor.hpp"

using namespace std;

Predictor::Predictor(string filename){
    this->file_to_predict = filename;
}

double Predictor::calculate_norm(unordered_map<int,int> &rat){
    double norm = 0;
    for (unordered_map<int,int>::iterator it = rat.begin(); it != rat.end(); it++){
        norm += ((double) it->second)*((double) it->second);
    }
    return sqrt(norm);
}

double Predictor::regular_cosine(unordered_map<int,int> &smaller, double norm1, unordered_map<int,int> &bigger, double norm2){
    double num = 0;

    if (smaller.size() != 0){
       for (unordered_map<int,int>::iterator it = smaller.begin(); it != smaller.end(); ++it){
           unordered_map<int,int>::iterator it_big = bigger.find(it->first);
           if (it_big != bigger.end()){
               num += ((double) it->second)*((double) it_big->second);
           }
       }
       num = num/(norm1*norm2);
       if (norm1 == 0 || norm2 == 0){
           num = 0;
       }
    }
    return num;
}

ItemList Predictor::predict_all(ItemList &first_list){
    ifstream f(file_to_predict);
    string line;
    string content ((std::istreambuf_iterator<char>(f)),
                                   (std::istreambuf_iterator<char>()));
    istringstream iss(content);
    int k = 30;
    ostringstream oss;
    getline(iss,line);
    oss << "UserId:ItemId,Prediction\n";
    if (f){
        while(getline(iss,line)){
            int colon = line.find(":");
            string user = line.substr(0,8);
            string item = line.substr(colon+1,8);
		    unordered_map<int,int> ratings1 = first_list.get_itemratings(item);
		    unordered_map<string,double>::iterator norm_it = norms.find(item);
            double norm1 = 0;
            if (norm_it == norms.end()){
                norm1 = calculate_norm(ratings1);
                norms.insert({item,norm1});
            }
            else{
                norm1 = norm_it->second;
            }

            unordered_map<string, unordered_map<string,double> >::iterator it_sim = similars.find(item);
            if (it_sim == similars.end()){
                unordered_map<string,double> empty;
                similars.insert({item,empty});
                it_sim = similars.find(item);
            }
            //cout << user  << "  "<< item << "\n";
            //unordered_map<string,double> this_similars = similars.find(item)->second;
            set<string> this_users_list = first_list.get_user_list(user);
            //cout << "this_users_list: " << this_users_list.size() <<"\n";
            vector<pair<double, string> > similarities;
            for (set<string>::iterator it = this_users_list.begin(); it != this_users_list.end(); it++){
                unordered_map<string, unordered_map<string,double> >::iterator find_item = similars.find(*it);
                //if (find_item != this_similars.end()){
                //it_sim = similars.find(*it);
                if (find_item == similars.end()){
                    unordered_map<string,double> empty;
                    similars.insert({*it,empty});
                    find_item = similars.find(*it);
                }
                unordered_map<string,double>::iterator this_similars = it_sim->second.find(*it);
                double sim = 0;
                if (this_similars != it_sim->second.end()){
                    sim = this_similars->second;
                }
                else{
			        unordered_map<int,int> ratings2 = first_list.get_itemratings(*it);
                //if (ratings2.size() > 0){
                    // unordered_map<string,double>
			        norm_it = norms.find(*it);
                    double norm2 = 0;
                    if (norm_it == norms.end()){
                        norm2 = calculate_norm(ratings2);
                        norms.insert({*it,norm2});
                    }
                    else{
                        norm2 = norm_it->second;
                    }
                    //double sim = find_item->second;//sl.regular_cosine(first_list,item,*it);
		            //double sim = 0;
                       	if (norm1 > 0 && norm2 > 0){
	                        // unordered_map<int,int> smaller;
    	                    // unordered_map<int,int> bigger;
  	                        if (ratings1.size() < ratings2.size()){
  	                            sim = regular_cosine(ratings1, norm1, ratings2, norm2);
  	                        }
  	                        else{
                                sim = regular_cosine(ratings2, norm1, ratings1, norm2);
 	                        }
	                        // //double sim = 0;
	                        // //cout  << "smaller size: " << smaller.size() <<"\n";
	                        // if (smaller.size() != 0){
	                        //     for (unordered_map<int,int>::iterator it = smaller.begin(); it != smaller.end(); ++it){
	                        //         unordered_map<int,int>::iterator it_big = bigger.find(it->first);
	                        //         if (it_big != bigger.end()){
	                        //             sim += ((double) it->second)*((double) it_big->second);
	                        //         }
	                        //     }
	                        //     sim = sim/(norm1*norm2);
	                        //     //if (norm1 == 0 || norm2 == 0){
	                        //     //    sim = 0;
	                        //     //}
   	                        // }
                        }
                        it_sim->second.insert({*it,sim});
                        find_item->second.insert({item,sim});
                    }
                    pair<double,string> par(sim,*it);
                    similarities.push_back(par);
                //}
                //cout << "sim to: " << *it << " Sim val: " << sim.first << "\n";
            //}
            }
            sort(similarities.rbegin(),similarities.rend());
            if (similarities.size() > k){
                vector<pair<double,string> > newvec(similarities.begin(),(similarities.begin() + k));
                similarities = newvec;
            }
            //cout << "sim size: " << similarities.size() <<"\n";
            double num = 0, den = 0;
            for (vector<pair<double, string> >::iterator it = similarities.begin(); it != similarities.end(); ++it){
                int user_id = first_list.get_userid(user);
                unordered_map<int,int> itemratings = first_list.get_itemratings(it->second);
                unordered_map<int,int>::iterator item_it = itemratings.find(user_id);
                double rat = itemratings.find(user_id)->second;
                double avg = first_list.get_item_avg(it->second);
                //cout << "user avg: " << avg  << " sim: " << it->first << " Rating: " << rat << " user_id: " << user_id << "\n";
                num += (((double) rat) - avg)* it->first;
                den += abs(it->first);
            }
            double this_avg = first_list.get_item_avg(item);
            if (this_avg < 0){
                this_avg = first_list.get_user_avg(user);
                if (this_avg < 0){
                    this_avg = first_list.get_genavg_item();//first_list.general_avg();
                }
            }

            double prediction = this_avg;
            if (den > 0){
                prediction += (num/den);
            }
            if (prediction > 10){
                prediction = 10;
            }
            else if (prediction < 0){
                prediction = 0;
            }
            //cout << this_avg << "  " << num << "  " << den << "  " << prediction << "\n";
            //final_predictions.add_rating(user,item,prediction);
            oss << user << ":" << item << "," << prediction << "\n";
        }
        //ofile.close();
        //final_predictions.write_csv("./data/predictions.csv");
        f.close();
    }
    cout << oss.str();
    ItemList novo;
    return novo;
}
