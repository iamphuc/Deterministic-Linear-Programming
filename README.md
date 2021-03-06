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

Based on the given information, it's worthwhile to note that the total expected demands for the 5 different packages exceed the hotel capacity. In addition, there is a variance in the length of stay required by the 5 different packages. This can be thought of as having inventory of different products that can only be serviced at specific time interval. In the world of revenue management, this is a **network revenue management problem**. 

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

=> Therefore, in maximizing the revenue, the hotel management team should ignore the Mayor's restriction.

To understand where the difference is coming from, let's look at the optimal number of packages sold per each package type.

|No.|Package|Without Mayor's guideline|Subject to Mayor's guideline|
|:---:|:---|:---:|:---:|
|1|3-night stay (day 1 to 4)|60|60|
|2|2-night stay (day 1 to 3)|40|30|
|3|2-night stay (day 2 to 4)|50|50|
|4|1-night stay (day 3 to 4)|40|40|
|5|1-night stay (day 1 to 2)|50|60|

<details><summary>CLICK ME</summary>
  <p>

    The hotel would have to give up 10 units of package 2 (higher pricec package) for 10 additional units of package 5 
    (lower price package) so that the minimum of 100 units single night packages (package 4 and package 5) can be met. 
    This tradeoff resutls in a lower revenue for the hotel.
    
   <p>
   </details>

We can also look at the consumption breakdown of the mutual resource (bedrooms) on each leg (night). 

Capacity consumption breakdown (without Mayor's guideline):
|Nights|Package 1|Package 2|Package 3|Package 4|Package 5|Sum|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|First Night|60|40|0|0|50|150|
|Second Night|60|40|50|0|0|150|
|Third Night|60|0|50|40|0|150|

Capacity consumption breakdown (subject to Mayor's guideline):
|Nights|Package 1|Package 2|Package 3|Package 4|Package 5|Sum|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|First Night|60|30|0|0|60|150|
|Second Night|60|30|50|0|0|140|
|Third Night|60|0|50|40|0|150|

<details><summary>CLICK ME</summary>
  <p>

    Because the demand for any single package is less than the capacity and because prices are descending by 
    the package order from 1 to 5, it makes sense when all demand for package 1 (60 units) is sold first on 
    the first night. It then follows that all demand for package 2 (60 units) would be sold because 
    the remaining capacity after selling pacakge 1 is 90 units (150 - 60 = 90 units) However, 4o rooms were 
    sold to package 2. The reason lies in the third night. Because package 2 does not require capacity 
    on the third night, demand for package 3 is given priority after all demand from package 1 (60 units) is served. 
    Demands for package 2 (60 units) are then left with only 40 rooms (150 - 60 - 50 = 40 rooms).
    
    This result is robust across different cases (with Mayor's guidance versus without Mayor's guidance) because 
    the guidance does not affect the sale of package 1 and package 3. Intuitively, it makes sense to reserve 
    just 100 rooms for the sale of package 4 and package 5 because prices of these two packages are much lower 
    than prices of package 1, package 2, and package 3. However, the usage of package 4 and package 5 does not 
    concentrate on one night. Demand for package 5 arrives on the first night while demand for package 4 
    arrives on the third night. Therefore, the hotel is able to serve more of the higher price packages. 
    That makes the difference between the two cases only $1,000.
    
   <p>
   </details>

## Bid Prices
Bid prices refer to threshold values that are set for each leg of a network, such that the hotel accepts a request for a particular package, if and only if there is available capacity, and the price exceeds the sum of the bid prices for all resources (bedrooms in consecutive nights) used by the package. In essence, bid prices reflect the minimum value of the next bedroom sold.

If we had the probability distribution that governs the demand, we would be able to simulate the demand uncertainty, and solve a randomized linear program (RLP) to find bid prices. However, the only information provided is the expected demand for each package. Thus, we can use the optimal shadow prices as bid price approximations. The shadow price associated with each constraint shows the amount of change in objective function value if we increase the right hand side of the constraint by an infinitesimal change. The table below shows the breakdown of bid prices approximation in both alternatives.

|Nights|Without Mayor's guideline|Subject to Mayor's guideline|
|:---:|:---:|:---:|
|First Night|200|300|
|Second Night|100|0|
|Third Night|0|00|

Conclusion A:
1. In the first alternative, the opportunity cost of the bedroom resources in the first, second, and third nights are 200, 100, and 0, respectively. 
2. When the hotel is made to follow the Mayor's guideline, the opportunity cost of the first night will increase to 300, but the internal prices for two other nights are 200.

Conclusion B:
1. In both alternatives, the hotel is willing to accept requests for package no. 1,3,4 if there would be available capacity. Because the prices for these packages exceed the sum of bid prices for all associated resources.
2. When the hotel is made to follow the Mayor's guideline, the opportunity cost of the required resources for the package no. 5 exceeds its price. Thus, it is clear that the hotel will accommodate the Mayor's request by selling package 4 (1-night stay: day 3 to day 4) which only uses third night capacity with zero opportunity cost.
3. In both alternatives, the opportunity cost of the required resources for the package no. 2 is equivalent to its price.

The below talbe compares prices of packages with sum of the bid prices for all requried resources.
|No.|Package|Price|Associated Resources|Without Mayor's guideline|Subject to Mayor's guideline|
|:---:|:---:|:---:|:---:|:---:|:---:|
|1|3-night stay (day 1 to 4)|900|First, second, and third nights|300|300|
|2|2-night stay (day 1 to 3)|300|First and second nights|300|300|
|3|2-night stay (day 2 to 4)|400|Second and third nights|100|0|
|4|1-night stay (day 3 to 4)|200|Third night|0|0|
|5|1-night stay (day 1 to 2)|200|First night|200|300|

## License
This repository contains a [MIT LICENSE](https://github.com/iamphuc/Deterministic-Linear-Programming/blob/main/LICENSE)
