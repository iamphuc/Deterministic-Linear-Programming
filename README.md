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

*Side note: At this point, I encourage readers to think about the problem by themselves. Even if you can't come up with the analytical approach on your own, it's still good becoming aware of what goes into the problem. The following collapsed sections will guide you through how I and my partner tackled this problem.* 
