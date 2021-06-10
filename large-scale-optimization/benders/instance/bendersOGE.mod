set N;
set O within N;
set A within N cross N; #fixed links
set Ahat within N cross N; #additional links
set AA:=A union Ahat; #all the links

param xc {N};
param yc {N};
param t {i in N,l in O};
param c {(i,j) in AA, l in O} := 10+((xc[i]-xc[j])^2+(yc[i]-yc[j])^2)^(3/2);
param f {(i,j) in Ahat} := 2*(abs(xc[i]-xc[j])+5*abs(yc[i]-yc[j]));
param yb {(i,j) in Ahat};
param rho>0;
param Niter;
param nCUT;
param restric {(i,j) in Ahat, l in O,k in 1..nCUT};
param ybk {(i,j) in Ahat, k in 1..nCUT};

node I {i in N, l in O}: net_out=t[i,l]; # if positive ==> injection, 
                                         # if negative ==> extraction
arc xl {(i,j) in AA, l in O}>=0: from I [i,l], to I [j,l];

var y{(i,j) in Ahat} binary;

#original problem
minimize z: 
   sum {(i,j) in Ahat} f[i,j]*y[i,j]+
   sum{l in O} (sum {(i,j) in AA} c[i,j,l]*xl[i,j,l]);

subject to capsl {(i,j) in Ahat, l in O}:
    xl[i,j,l]<=rho*y[i,j];

#Subproblem
minimize zd: sum{l in O} (sum {(i,j) in AA} c[i,j,l]*xl[i,j,l]);

subject to caps {(i,j) in Ahat, l in O}:
    xl[i,j,l]<=rho*yb[i,j];

#Master problem (yb)
param u {i in N, l in O,k in 1..nCUT}<=0;
var zmp;

minimize ZMP: zmp;

subject to Bcut {k in 1..nCUT}:
zmp>=(sum {(i,j) in Ahat} f[i,j]*y[i,j])+
   (sum{i in N, l in O} t[i,l]*u[i,l,k])+
   rho*(sum{(i,j) in Ahat, l in O} restric[i,j,l,k]*(1-ybk[i,j,k])*y[i,j]);