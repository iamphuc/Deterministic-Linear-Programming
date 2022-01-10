# Deterministic Linear Programming

## Development
This work was the group assignment I and my partner did in the Fall Semester 2021 for OPM 682 Revenue Management course taught by [Prof. Dr. Cornelia Schön](https://www.bwl.uni-mannheim.de/schoen/ "Prof. Dr. Cornelia Schön"), University of Mannheim.

## Description of Problem
We, assuming the role of management team at a hotel on a small island in the North Sea, are tasked to determine the optimal number of guests to accept for each package such that the revenue of the hotel is maximized.

The table below summarizes our 5 different packages and the corresponding prices and expected demands.

|No.|Package|Price|Expected Demand|
|:---:|:---|:---:|:---:|
|1|3-night stay (day 1 to 4)|900|60|
|2|2-night stay (day 1 to 3)|300|60|
|3|2-night stay (day 2 to 4)|400|50|
|4|1-night stay (day 3 to 4)|200|40|
|5|1-night stay (day 1 to 2)|200|80|

The hotel is open only for 4 days (=3 nights) in June each year when the sailing championship takes place. The hotel is closed during the rest of the year. 

Further, drawing on his experience that people who book a 1-night package spend much more money at the sailing events (i.e., food, souvenirs, etc), the mayor instructs the hotel management to assign at least 100 rooms to the 1-night package.

*Side note: At this point, I encourage readers to think about the problem by themselves. Even if you cannot come up with the analytical approach on your own, it is still good becoming aware of what goes into the problem. The following collapsed sections will guide you through how I and my partner tackled this problem.* 

## Model Construction

Based on the given information, it's worthwhile to note that the total expected demands for the 5 different packages exceed the hotel capacity. In addition, there is a variance in the length of stay required by the 5 different packages. This can be thought of as having inventory of different products that can only be serviced at specific time interval. In the world of revenue management, this is a network revenue management problem. 

To solve this problem, we input the variables, the objective function, and the consraints into AMPL as follows.
<details><summary>CLICK ME</summary>
  <p>
    
    The underlying sets:
    set J;    #set of products j=1,...,5
    set L;    #set of legs l= "FN","SN","TN" representing First Night, Second Night, and Third Night respectively;
    
    The parameters:
    param p {j in J};           # prices of all products
    param a {l in L, j in J};   # resource use binary identifier
    param c {l in L};           # capacities for all legs l
    param ED {j in J};          # expected demand of each product
    
    The variables:
    var y {j in J};             # number of each product sold
    
    Objective function:
    maximize Revenue: sum {j in J} p[j]*y[j];
    
    The constraints:
    # Capacity constraints
    subject to CAP {l in L}: sum {j in J} a[l,j] * y[j] <= c[l];
    # Demand constraints
    subject to Demand {j in J}: y[j] <= ED[j];
    # Mayor's guidance constraint
    subject to Mayor: y[4] + y[5] >= 100;
    # Non-negativity constraints
    subject to NN {j in J}: y[j] >= 0;
    
    problem alternative1: {j in J} y[j], Revenue, {l in L} CAP[l], {j in J} Demand[j], {j in J} NN[j];
    problem alternative2: {j in J} y[j], Revenue, {l in L} CAP[l], {j in J} Demand[j], Mayor, {j in J} NN[j];
    
   <p>
   </details>

We created two alternatives. The first one does not include the constraint caused by the Mayor's guideline. We were interested in understanding if the hotel management should follow the Mayor's guideline (i.e., is revenue under Mayor's restriction greater than the amount under no restriction?).

## Implementation
There are 2 approaches to program this problem into AMPL. The first approach is manual and the second one is automated. 

The first approach is manual for two reasons. First, the objective function is comprised of actual parameters (i.e., price) and variables (5 variables in total corresponding to 5 packages). Second, you also have to manually figure out the constraint inequalities. The hotel capacility constraint can be confusing and easy to make mistake. Therefore, this practice is error-prone and is inadvisble especially when you want to "play around" with the numbers later on. 

The second approach is automated the problem construction and the data are seperated (the .mod and the .dat files). The .run is also a seperated file where you can specify which solver to use and which problem to solve. In our case, there are two problem alternatives to be solved (with and without Mayor's guideline).

All implementation files are uploaded. The ones that have "_automated_" are designated to the second approach. 

## Interpretation of Results
We found that:
- If the hotel doesn't follow the Mayor's guidance, the total revenue reaches **$104,000**.
- If the hotel is to follow the Mayor's guidance, the total revenue reaches **$103,000**
==> Therefore, in maximizing the revenue, the hotel management team should ignore the Mayor's restriction.



