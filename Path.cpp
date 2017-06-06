#include"Path.h"
#include<cmath>
#include <iostream>
#include"Random1.h"
#include "Normals.h"
#include "functions.h"


//definition of constructor
Path::Path( int nInt_,
            double spot_,
            double vol_,
            double r_,
            double expiry_){
		nInt = nInt_;
		spot = spot_;
		vol = vol_;
		r = r_;
		expiry = expiry_;
		generatePath();
}

//method definition
void Path::generatePath(){

    double thisDrift = (r * expiry - 0.5 * vol * vol * expiry) / double(nInt);
    double cumShocks = 0;
	thisPath.clear();
    thisPath.push_back(spot);

	for(int i = 0; i < nInt; i++){
		cumShocks += (thisDrift + vol * sqrt(expiry / double(nInt)) * GetOneGaussianByBoxMuller());
		thisPath.push_back(spot * exp(cumShocks));
	}
}


// deltas calculation
 vector<double> Path::getDeltasPath(double strike, double vol2){

    vector<double> DeltasPath;

    for (int i = 0; i < nInt; i++){

        double k = i;
        double t = expiry * (1 - k / nInt);

        DeltasPath.push_back(call_delta(thisPath[i], strike, vol2, r, t ));
  	};


  	DeltasPath.push_back(1.0); //for Delta at maturity

    //cout << DeltasPath.size()<<endl;

  	return(DeltasPath);



};



