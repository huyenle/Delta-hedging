#include<iostream>
#include <fstream>
#include<vector>
#include"Path.h"
#include<ctime>
#include<cstdlib>
#include "functions.h"

#include <Rcpp.h>
using namespace Rcpp;



using namespace std;



// [[Rcpp::export]]

NumericVector DeltaHedgePnL(int nInt,
                            double strike,
                            double spot,
                            double vol_real,
                            double r,
                            double expiry,
                            double vol_implied,
                            double nSims)
{

  srand( time(NULL));

  std::vector<double> result;

  for (int i = 0; i < nSims; i++){

    Path* myPath = new Path(nInt, spot, vol_real, r, expiry);

    double PnL_delta = PnL_cal_delta(*myPath, strike, vol_implied);

    result.push_back(PnL_delta);
  };


  NumericVector results = Rcpp::wrap(result);

  return results;
};

// [[Rcpp::export]]
NumericVector DeltaGammaHedgePnL(int nInt,
                            double strike1,
                            double strike2,
                            double spot,
                            double vol_real,
                            double r,
                            double expiry,
                            double vol_implied,
                            double nSims)
{

  srand( time(NULL));

  std::vector<double> result;

  for (int i = 0; i < nSims; i++){

    Path* myPath = new Path(nInt, spot, vol_real, r, expiry);

    double PnL_Gamma = PnL_cal_gamma(*myPath, strike1, strike2, vol_implied);

    result.push_back(PnL_Gamma);
  };


  NumericVector results = Rcpp::wrap(result);

  return results;
}
