
param m;		# Number of observations
set M := 1..m by 1;	# Set of observations

param k;			# Number of clusters
param d {M,M};		# Distance matrix

var x {M,M} binary;	# Point i belongs to cluster j -> x[i,j]=1

# Objective Function
minimize DistMedian: 
	sum {i in M} sum {j in M} d[i,j]*x[i,j];

# Constraints
subject to onecluster {i in M}: 
	sum {j in M} x[i,j]=1;
	
subject to kclusters:
	sum {j in M} x[j,j]=k;
	
subject to existscluster {j in M}:
	m*x[j,j] >= sum {i in M} x[i,j];