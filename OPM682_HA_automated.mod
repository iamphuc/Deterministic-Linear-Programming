

# Define the underlying sets
set J; #set of products j=1,...,5
set L; #set of legs l=firstnight,secondnight,thirdnight

# Define parameters
param p {j in J}; 			# prices of all products
param a {l in L, j in J}; 	# resource use binary identifier 
param c {l in L};			# capacities for all legs l
param ED {j in J}; 			# expected demand of each product

# Define variables
var y {j in J};				# number of each product sold

# Define objective function
maximize Revenue: sum {j in J} p[j]*y[j];

# Define constraints
# Capacity constraints
subject to CAP {l in L}: sum {j in J}  a[l,j] * y[j] <= c[l];
# Demand constraints
subject to Demand {j in J}: y[j] <= ED[j];
# Mayor's guidance constraints
subject to Mayor: y[4] + y[5] >= 100;
# Non-negativity constraints
subject to NN {j in J}: y[j] >= 0;

problem alternative1: {j in J} y[j], Revenue, {l in L} CAP[l], {j in J} Demand[j], {j in J} NN[j];
problem alternative2: {j in J} y[j], Revenue, {l in L} CAP[l], {j in J} Demand[j], Mayor, {j in J} NN[j];