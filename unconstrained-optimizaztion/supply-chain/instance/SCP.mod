#SUPPLY CHAIN STRATEGY WITH PRICING

#SETS
set FACT; #Production plants
set MARK; #Markets
set PROD; #Products
set TIME; #Time period
set RESO; #Resource

#PARAMATERS
param avail {RESO,FACT,TIME} >= 0; 
param inv0 {FACT,PROD} >= 0;
param rate {RESO,FACT,PROD} >= 0;
param demand_current {MARK,PROD,TIME} >= 0;  
param price_current {PROD} >= 0;  
param demand_response {MARK,PROD};  
param price_min;  
param price_max; 
param make_cost {FACT,PROD,TIME} >= 0;  
param inv_cost {FACT,PROD} >= 0;  
param trans_cost {FACT,MARK,PROD} >= 0;  

#VARIABLES
var pricet {MARK,PROD} >= 0; 
var sellt {FACT,MARK,PROD,TIME} >= 0; 
var prodt {FACT,PROD,TIME} >= 0; 
var invent {FACT,PROD,{0} union {TIME}} >= 0; 
var demant {MARK,PROD,TIME} >= 0; 

#AUX VARIABLES TO DEFINE THE OBJECTIVE FUNCTION
var Revenue = sum {p in PROD, t in TIME,i in FACT,j in MARK} 
   	pricet[j,p] * sellt[i,j,p,t];  	
var Prod_cost = sum {p in PROD, t in TIME,i in FACT}
   	make_cost[i,p,t]*prodt [i,p,t];
var Inv_cost = sum {p in PROD, t in TIME,i in FACT}
   inv_cost[i,p]*invent[i,p,t];  
var Trans_cost = sum {p in PROD, t in TIME,i in FACT,j in MARK} 
	trans_cost[i,j,p]*sellt[i,j,p,t];

#OBJECTIVE FUNCTION
maximize Profit:
	Revenue-Prod_cost-Inv_cost-Trans_cost;

#CONSTRAINTS
subject to Balance {i in FACT, p in PROD, t in TIME}: #inventory balance equation
   prodt[i,p,t]+invent[i,p,t-1]-(sum {j in MARK} sellt[i,j,p,t]) = invent[i,p,t]; 
subject to Ini {i in FACT, p in PROD}: #initial inventory 
	invent[i,p,0]=inv0[i,p];
subject to Resource {r in RESO,i in FACT,t in TIME}: #resource availability restrictions
   (sum {p in PROD} (1/rate[r,i,p])*prodt[i,p,t])<=avail[r,i,t];
subject to Satdemand {p in PROD,t in TIME, j in MARK}: #demand and supply equilibrium
   (sum {i in FACT} sellt[i,j,p,t])=demant[j,p,t];   
subject to Demand {p in PROD,t in TIME, j in MARK}: #demand elasticity
   demant[j,p,t]=demand_current[j,p,t]+(demand_response[j,p]*(pricet[j,p]-price_current[p])); 
subject to Pricelb {p in PROD, j in MARK}: #price lower bound
   pricet[j,p] >= price_min*((sum {k in MARK} pricet[k,p])/card(MARK));
subject to Priceub {p in PROD, j in MARK}: #price upper bound
   pricet[j,p] <= price_max*((sum {k in MARK} pricet[k,p])/card(MARK));
   