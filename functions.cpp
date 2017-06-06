#include<cmath>
#include<iostream>
#include<vector>
#include"functions.h"
#include"Normals.h"
#include "Path.h"

using namespace std;

double call_price (double spot,
                   double strike,
                   double vol,
                   double r,
                   unsigned long T)

{

    double d1  = (log(spot / strike) + (r + vol * vol / 2) * T) / (vol * sqrt(T));

    double d2 = d1 - vol * sqrt(T);

    double Nd1 = CumulativeNormal(d1);

    double Nd2 = CumulativeNormal(d2);

    double  discount = exp(-r * T);

    double price = spot * Nd1 - strike * Nd2 * discount;

    return(price);
}


double call_delta (double spot,
                   double strike,
                   double vol,
                   double r,
                   double T)
{
    double d1  = (log(spot / strike) + (r + vol * vol / 2.0) * T) / (vol * sqrt(T));

    double Nd1 = CumulativeNormal(d1);

    return(Nd1);
}

double call_gamma (double spot,
                   double strike,
                   double vol,
                   double r,
                   double T)
{
  const double OneOverRootTwoPi = 0.398942280401433;
  double d1  = (log(spot / strike) + (r + vol * vol / 2.0) * T) / (vol * sqrt(T));
  double gamma = exp (-d1 * d1 / 2.0) * OneOverRootTwoPi / (spot * vol * sqrt(T));

  return(gamma);
}

//calculate the Pnl for each PATH of simulated
double PnL_cal_delta (Path Hedged, double strike, double vol2)
  {
    double spot = Hedged.spot;
    double vol = vol2;
    double r = Hedged.r;
    double expiry = Hedged.expiry;
    double nInt = Hedged.nInt;

    vector<double> DeltasPath = Hedged.getDeltasPath(strike, vol2);

    vector<double> thisPath = Hedged.thisPath;

    //initial position

    double PnL = DeltasPath[0] * thisPath[0] - call_price(spot, strike, vol, r, expiry);

    // accumulating PnL
    double dt = expiry / nInt;

    for ( int i = 1; i <= nInt; i ++)
      {
        PnL = PnL * exp( r * dt) + (DeltasPath[i] - DeltasPath[i - 1]) * thisPath[i];
      };

    double Cn;

    if (thisPath.back() > strike) {Cn = thisPath.back() - strike;} else Cn = 0;

    //close out position

    PnL += Cn - DeltasPath.back() * thisPath.back();

    return(PnL);
};


//PnL for Gamma Delta Hedging
double PnL_cal_gamma(Path Hedged, double strike1, double strike2, double vol2)
{
  double spot = Hedged.spot;
  double r = Hedged.r;
  double expiry = Hedged.expiry;
  double nInt = Hedged.nInt;
  vector<double> thisPath = Hedged.thisPath;

  double vol = vol2;

  double PnL_delta1 = PnL_cal_delta(Hedged, strike1, vol2);

  double PnL_delta2 = PnL_cal_delta(Hedged, strike2, vol2);

  double gamma1 = call_gamma(spot,strike1, vol, r, expiry);

  double gamma2 = call_gamma(spot,strike2, vol, r, expiry);

  return (PnL_delta1 - gamma1/gamma2 * PnL_delta2);

}
