set VARIABLE = 1 .. 5 by 1;       #variables and output set
set EXPLANATORY = 1 .. 4 by 1;    #explanatory variables set
set OBSERVATION = 1 .. 50 by 1;   #observations set

#creation of weights set
set I = 1 .. 4 by 1; 
set O = 5 .. 6 by 1;
set L = 7 .. 7 by 1;
set D = {I,O};
set P = {O,L};
set M = D union P; #weights set

param obser {OBSERVATION,VARIABLE} >= 0; #observations parameter
var weight {M} >= -27500; #lower bound for weights to avoid calculations errors

#initial variables
let weight[1,5]:=1;
let weight[1,6]:=3;
let weight[2,5]:=-2;
let weight[2,6]:=-2;
let weight[3,5]:=1;
let weight[3,6]:=-5;
let weight[4,5]:=0.42;
let weight[4,6]:=-0.4;
let weight[5,7]:=-1;
let weight[6,7]:=1;

#objective function
minimize Total:
	sum {i in OBSERVATION} 
	
	((1
	/
	(1+exp(-
	(
	weight[6,7] * 1/(1+exp(-(sum {j in EXPLANATORY} weight[j,6] * 1/(1+exp(-obser[i,j])))))
	+
	weight[5,7] * 1/(1+exp(-(sum {j in EXPLANATORY} weight[j,5] * 1/(1+exp(-obser[i,j])))))
	)
	))
	)
	-
	obser[i,5])^2




	
	



 

