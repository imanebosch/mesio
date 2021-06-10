# ----------------------------------------
# THE ATM PROBLEM
# EXTENSIVE FORM 
# ----------------------------------------

param c; # cost per euro in ATM
param q; # cost per euro when demand exceeds
param l; # minimum capacity
param u; # maximum capacity
param s; # num of scenarios
param nCUT >= 0 integer; # num max of cuts

set SCENE := {1..s}; # set of scenarios

param p {SCENE}; # Probability of scenario i
param chi {SCENE}; # Demand of scenario i

#------------------------------
#STOCHASTIC PROGRAMMING PROBLEM
#------------------------------
#used to calculate RP
var x >= l <= u;
var y {SCENE} >= 0;

minimize P: c*x + sum{i in SCENE} (p[i]*q*y[i]);
subject to Exceed {i in SCENE}: x+y[i]>=chi[i];

#------------------------------
#STOCHASTIC PROBLEM FOR FIXED X
#------------------------------
#used to calculate EEV
param Xpar;

minimize EP: c*Xpar + sum{i in SCENE} (p[i]*q*y[i]);
subject to Exceedpar {i in SCENE}: Xpar+y[i]>=chi[i];

#------------------------------
#DETERMINISTIC PROBLEM
#------------------------------
#useed to calculate WS
var Y >=0;
var X >= l <= u;
param Chi;

minimize DP: c*X + q*Y;
subject to Excees: X+Y>=Chi;

#END-----------------------------------------------------
#########################################################