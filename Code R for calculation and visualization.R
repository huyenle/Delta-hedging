library('Hedging')
library('ggplot2')
library('tidyr')
library('moments')
library('dplyr')
setwd("C:\\Users\\Huyen Le\\Desktop\\OP")


###### assumptions ############
n = 12 * 4 * 5 * 6.5 * 6 #every 10 minutes
nSims = 10000


T = 1
mu = 0.15
sigma1 = 0.2
S0 = K1 = 100
K2 = 90
sigma2 = 0.3
r = 0.05

n = 12 * 4 * 5 * 6.5 * 6 #every 10 minutes
n2 = 12 * 4 *5 *6.5 #every hour
n3 = 12 * 4 *5 #everyday
n4 = 12 * 4 #every week

###### Hedging with implied vol ############

vol_real = sigma2

vol_implied = sigma1

####Continuous hedging n = 9630 ###
PnL_continuous = DeltaHedgePnL(
  nInt = n,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_implied,
  nSims
)

####hourly hedging ###

PnL_hourly = DeltaHedgePnL(
  nInt = n2,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_implied,
  nSims
)

####daily hedging ###

PnL_daily = DeltaHedgePnL(
  nInt = n3,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_implied,
  nSims
)
####weekly hedging ###

PnL_weekly = DeltaHedgePnL(
  nInt = n4,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_implied,
  nSims
)
##Combine and draw something###

PnL <- data.frame(PnL_continuous, PnL_hourly, PnL_daily, PnL_weekly)

names(PnL) <-
  paste(c("Continous", "Hourly", "Daily", "Weekly"), "hedging", sep = " ")

head(PnL)

PnL.plot <- gather(data = PnL, Frequency, PnL)

ggplot(PnL.plot, aes(x = PnL, fill = Frequency)) +
  ylab("Number of simulations") +
  geom_histogram(alpha = 0.5, binwidth = 0.01)+
  guides(fill = guide_legend(keywidth = 0.5, keyheight = 2, title = NULL))


ggplot(PnL.plot, aes(x = PnL, fill = Frequency)) +
  geom_histogram(binwidth = 0.01) +
  facet_wrap(~ Frequency, scales = "free_y") +
  ylab("Number of simulations")

##calculate some statistics##

head(PnL)

statistics <- rbind(apply(PnL, 2, mean),
                    apply(PnL, 2, sd),
                    apply(PnL, 2, kurtosis),
                    apply(PnL, 2, skewness))
row.names(statistics) <- c("mean", "std", "kurt", "skew")


###### Hedging with real vol ###########

####Continuous hedging n = 9630 ###
PnL2_continuous = DeltaHedgePnL(
  nInt = n,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)

####hourly hedging ###

PnL2_hourly = DeltaHedgePnL(
  nInt = n2,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)

####daily hedging ###
PnL2_daily = DeltaHedgePnL(
  nInt = n3,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)
####weekly hedging ###
PnL2_weekly = DeltaHedgePnL(
  nInt = n4,
  strike = K1,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)

##Combine and draw something###

PnL2 <- data.frame(PnL2_continuous, PnL2_hourly, PnL2_daily, PnL2_weekly)

names(PnL2) <-
  paste(c("Continous", "Hourly", "Daily", "Weekly"), "hedging", sep = " ")

head(PnL2)

PnL2.plot <- gather(data = PnL2[1:4], Frequency, PnL)

ggplot(PnL2.plot, aes(x = PnL, fill = Frequency)) +
  ylab("Number of simulations") +
  geom_histogram(alpha = 0.5, binwidth = 0.01)


ggplot(PnL2.plot, aes(x = PnL, fill = Frequency)) +
  geom_histogram(binwidth = 0.01) +
  facet_wrap(~ Frequency, scales = "free_y") +
  ylab("Number of simulations")

##calculate some statistics##

head(PnL2)

statistics2 <- rbind(apply(PnL2, 2, mean),
                    apply(PnL2, 2, sd),
                    apply(PnL2, 2, kurtosis),
                    apply(PnL2, 2, skewness))
row.names(statistics2) <- c("mean", "std", "kurt", "skew")

statistics2

######Gamma - Delta Hedging with real vol####
strike1 = K1
strike2 = K2

####combined with delta Continuous hedging n = 9630 ###
PnL3_continuous = DeltaGammaHedgePnL(
  nInt = n,
  strike1,
  strike2,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)

####hourly hedging ###
PnL3_hourly = DeltaGammaHedgePnL(
  nInt = n2,
  strike1,
  strike2,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)

####daily hedging ###
PnL3_daily = DeltaGammaHedgePnL(
  nInt = n3,
  strike1,
  strike2,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)
####week hedging ###
PnL3_weekly = DeltaGammaHedgePnL(
  nInt = n4,
  strike1,
  strike2,
  spot = S0,
  vol_real,
  r = r,
  expiry = T,
  vol_real,
  nSims
)


##Combine and draw something###

PnL3 <- data.frame(PnL3_continuous, PnL3_hourly, PnL3_daily, PnL3_weekly)

names(PnL3) <-
  paste(c("Continous", "Hourly", "Daily", "Weekly"), "hedging", sep = " ")

head(PnL3)

PnL3.plot <- gather(data = PnL3[1:4], Frequency, PnL)

ggplot(PnL3.plot, aes(x = PnL, fill = Frequency)) +
  ylab("Number of simulations") +
  geom_histogram(alpha = 0.5, binwidth = 0.01)

ggplot(PnL3.plot, aes(x = PnL, fill = Frequency)) +
  geom_histogram(binwidth = 0.01) +
  facet_wrap(~ Frequency, scales = "free_y") +
  ylab("Number of simulations")

head(PnL3)

statistics3 <- rbind(apply(PnL3, 2, FUN = function (x) mean(x, na.rm = T)),
                     apply(PnL3, 2, FUN = function (x) sd(x, na.rm = T)),
                     apply(PnL3, 2, FUN = function (x) kurtosis(x, na.rm = T)),
                     apply(PnL3, 2, FUN = function (x) skewness(x, na.rm = T)))
row.names(statistics3) <- c("mean", "std", "kurt", "skew")
statistics3

########

c<-data.frame(statistics2[2, 1:4 ], statistics3[2, 1: 4], c(n, n2, n3, n4))

names(c) <- c("Delta", "Delta-Gamma", "Frequency")


c <- gather(c, Type, Std, - Frequency)

ggplot(c, aes(x = Frequency, y = Std, col = factor(Type))) + geom_point()+geom_line()

############


