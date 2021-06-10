set nusos; #nodos
set centr within nusos; #nodes origen destino
set links within ( nusos cross nusos ); #arcos
set origens within centr; #nodos origen
set destins within centr; #nodes destino
set odpair within ( origens cross destins ); #arcos origen
set destperorig { i in origens } :=
setof { (i1, j1) in odpair : i = i1 } j1; # Conjunto de destinos segun origen

####PARAMETROS AÑADIDOS AL MODELO#############
param rho; #numero máximo de cardinalidad de Ws
param Col default 0; #variable auxiliar (cardinalidad de Ws)
param W {links, 0..rho} default 0; #para almacenar soluciones de W
param Ws {links,1..rho} default 0; #para almacenar soluciones de Ws
param Wx {links} default 0; #para almacenar soluciones de Wx
param Y {0..rho} default 0; #Auxiliar para determinar que elementos tiene W
###########################################################

param g{odpair} >0;		# Unitats a traslladar entre les parelles o-d
param t0{links};		# param. per algoritme (gradient f)
param c{links};			# parametre Funcio Objectiu (en problemes anteriors: costs de cada arc)
param cap{links};		# parametre F.O (en problemes anteriors: capacitat)
param Tdreta { i in nusos, k in origens }:=
if i in destperorig[k] then -1.0*g[k, i] 
# Entradas o salidas de flujo - si sale del nodo
else
if i = k then sum {j in destperorig[k]} g[k, j] 
# Entradas o salidas de flujo + si entra en el nodo
else 0;  
# Si el nodo es de paso

node N {i in nusos, k in origens}: net_out = Tdreta[i, k];

arc v_k { (i, j) in links, k in origens } >= 0,
from N[i, k], to N[j, k] ;

var v { (i, j) in links };

subject to flux_total { (i, j) in links }:
v[i, j] = sum { k in origens } v_k[i, j, k];

minimize Vg: sum { (i, j) in links } v[i, j]*t0[i, j];

########PROBLEMA MODIFICADO############
var beta {0..rho} >=0; #variables para convex hull de master problem tantas como elementos W
minimize Vnl: sum {(i, j) in links } c[i,j]*v[i,j] + sum {(i, j) in links } 0.5*cap[i,j]*v[i,j]^2; 
#Definicion de la region factible del master problem: Convex Hull de elemenos en W
subject to convhull1 {(i,j) in links}: v[i,j] = sum{p in 0..rho} W[i,j,p]*beta[p];
subject to convhull2: sum{p in 0..rho} beta[p]=1; #condicion de convex hull
subject to active {p in 0.. rho}: beta[p]<=Y[p]; #fuerza a cero si no hay elemento en W




