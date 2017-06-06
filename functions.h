#include"Normals.h"
#include "Path.h"

#ifndef FUNCTIONS_H
#define FUNCTIONS_H

using namespace std;


//functions prototypes


double call_price (double spot,
                   double strike,
                   double vol,
                   double r,
                   unsigned long T);

double call_delta (double spot,
                   double strike,
                   double vol,
                   double r,
                   double T);

double call_gamma (double spot,
                   double strike,
                   double vol,
                   double r,
                   double T);

double PnL_cal_delta(Path Hedged,
                    double strike,
                    double vol2);

double PnL_cal_gamma (Path Hedged,
                      double strike1,
                      double strike2,
                      double vol2);



#endif // FUNCTIONS_H
