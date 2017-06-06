#ifndef PATH_H

#define PATH_H


#include<vector>

using namespace std;

class Path{
public:

	//constructor
	Path(int nInt_,
		 double spot_,
		 double vol_,
		 double r_,
		 double expiry_
		);

	//destructor
	~Path(){};

	//methods
	void generatePath();
	vector<double> getDeltasPath(double strike, double vol2);

	//members
	std::vector<double> thisPath;

	int nInt;
	double strike;
	double spot;
	double vol;
	double r;
	double expiry;

};


#endif // PATH_H
