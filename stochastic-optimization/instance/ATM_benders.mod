# ----------------------------------------
# BENDERS DECOMPOSITION FOR
# THE ATM PROBLEM
# ----------------------------------------

param c; # cost per euro in ATM
param q; # cost per euro when demand exceeds
param l; # minimum capacity
param u; # maximum capacity
param s; # num of scenarios
param nCUT >= 0 integer; # num max of cuts

set SCENE := {1..s}; # set of scenarios

param p{SCENE}; # Probability of scenario i
param chi{SCENE}; # Demand of scenario i

###### SUBPROBLEM Q_D(X) ######
param X; 
var mu {SCENE} >= 0; # Dual variables

maximize SubP: sum{i in SCENE} (chi[i]-X)*mu[i];
subject to const1 {i in SCENE}: mu[i] <= p[i]*q;

##### MASTERPROBLEM BPr(X) #####

var x >= l <=u; # euros in ATM on Friday
param MU {SCENE, 1..nCUT}; 
param cut_type {1..nCUT} symbolic within {"point","ray"}; 
# symbolic: els valors els hi posarem durant l'execucio
var z;

minimize MP: c*x + z;

subject to Cut_Defn {k in 1..nCUT}:
   if cut_type[k] = "point" then z >= 
      sum {i in SCENE} (chi[i]-x)*MU[i,k];
      
#END-----------------------------------------------------
#########################################################

























