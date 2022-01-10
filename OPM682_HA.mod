##### Define variables #####
var x1;		# Number of Product 1 sold
var x2;		# Number of Product 2 sold
var x3;		# Number of Product 3 sold
var x4;		# Number of Product 4 sold
var x5;		# Number of Product 5 sold

##### Define objective function #####
maximize Revenue : 900 * x1 + 300 * x2 + 400 * x3 + 200 * x4 + 200 * x5;

##### Define constraints #####
subject to HOTEL_CAP_1ST_NIGHT:		x1 + x2 + x5 <= 150;
subject to HOTEL_CAP_2ND_NIGHT:		x1 + x2 + x3 <= 150;
subject to HOTEL_CAP_3RD_NIGHT:		x1 + x3 + x4 <= 150;
subject to MAYOR_GUIDANCE:			x4 + x5 >= 100;
subject to DEMAND1:					x1 <= 60;
subject to DEMAND2:					x2 <= 60;
subject to DEMAND3:					x3 <= 50;
subject to DEMAND4:					x4 <= 40;
subject to DEMAND5:					x5 <= 80;
subject to NN1:						x1 >= 0;
subject to NN2:						x2 >= 0;
subject to NN3:						x3 >= 0;
subject to NN4:						x4 >= 0;
subject to NN5:						x5 >= 0;




