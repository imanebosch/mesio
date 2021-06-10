param m; 					#number of observations
param n; 					#number of variables
param k := n+1; 			#number of variables + class
param v; 					#penalization for missclassifiers

set M = 1..m by 1;
set N = 1..n by 1;

param x {M,1..k}; 			#matrix of observations and class
param K {M,M};				#kernel matrix parameter



var w {N}; 					#weights
var s {M} >=0; 				#missclassification variable
var y; 						#distance	
var lambda {M} >= 0;		#lambdas dual formulation



##### PRIMAL FORMULATION #####

minimize P: 
	(1/2)*(sum {i in N} w[i]*w[i]) + (v * sum {j in M} s[j]);

subject to 
	res_1 {i in M}: x[i,k]*(sum {j in N} w[j]*x[i,j] - y) + s[i] >= 1; 

##### DUAL FORMULATION #####

maximize D: 
	(sum {i in M} lambda[i]) - 
	(1/2)*(sum {i in M, j in M} lambda[i]*x[i,k]*lambda[j]*x[j,k]*K[i,j]);

subject to res_2: 
	sum {i in M} lambda[i]*x[i,k] = 0;

subject to res_3 {i in M}: 
	lambda[i] <= v; 
