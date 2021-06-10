
param m:=488; 	#casos: 596: 56, 597: 27, 598: 488
param n:=615;	#casos: 596: 138, 597: 51, 598: 615
set M := 1..m;
set N := 1..n;

param A {M, N}; 
param b {M}; 
param c {N};

var x {N} >= 0;

minimize fo: sum {j in N} c[j] * x[j];

subject to restr {i in M}: 
	sum {j in N} x[j]*A[i,j] = b[i]; 