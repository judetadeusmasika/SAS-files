/* Literacy data analysis; data visualization and regression analysis */

/* data importation */
proc import datafile='/home/u64071682/LABS/literacy.csv' dbms=csv out=literacy replace;
run;

/* data exploration, descriptive statistics */
proc means data=literacy;
var literacy;
run;

proc means data=literacy;
var literacy protestant hhsize f_young f_female f_urban f_native dist_berlin popn;
run;

proc means data=literacy(keep=literacy f_young f_urban protestant);
run;

/* selecting the variables you only want, creating a new dataset */
*data literacy_var;
*set literacy(keep=literacy protestant hhsize f_young f_urban f_native poland);
*run;

/* data visualization */
/* the distribution of the literacy, protestant and hhsize variables */

proc sgplot data=literacy;
histogram literacy;
density literacy;
title "The distributio of literacy level in Germany";
run;

proc sgplot data=literacy;
histogram protestant;
density protestant;
title "The distribution of protestantism in Germany";
run;

proc sgplot data=literacy;
histogram hhsize;
density hhsize;
title "The distribution of household size in Germany";
run;

/* scatter plots to obeserve the relationships */
proc sgplot data=literacy;
scatter x=protestant y=literacy / markerattrs=(symbol=circlefilled);
xaxis label='Percentage Protestant';
yaxis label='Literacy rate';
run;

proc sgplot data=literacy;
scatter x=literacy y=protestant / markerattrs=(symbol=circlefilled);
xaxis label='Literacy rate';
yaxis label='Percentage Protestant';
run;

proc sgplot data=literacy;
scatter x=f_female y=literacy / markerattrs=(symbol=circlefilled);
xaxis label='Percentage female population';
yaxis label='Literacy rate';
run;

proc sgplot data=literacy;
scatter x=f_urban y=literacy /markerattrs=(symbol=circlefilled);
xaxis label='Percentage living in urban areas';
yaxis label='Literacy rate';
run;

proc sgplot data=literacy;
scatter x=f_young y=literacy /markerattrs=(symbol=circlefilled);
xaxis label='Percentage younger than 10 years';
yaxis label='Literacy rate';
run;

proc sgplot data=literacy;
scatter x=f_native y=literacy / markerattrs=(symbol=circlefilled);
xaxis label='Percentage born locally';
yaxis label='Literacy rate';
run;

/* scatterplots grouping by the variable poland (polish region) */
proc sgplot data=literacy;
scatter x=protestant y=literacy /group=poland markerattrs=(symbol=circlefilled) transparency=0.2;
xaxis label='Percentage protestant';
yaxis label='Literacy rate';
title "Scatterplot of literacy against protestant by polish region";
keylegend / title="Polish Region";
run;

/* finally the boxplot of literacy rate, grouping for polish region */
proc sgplot data=literacy;
vbox literacy / category=poland;
xaxis label= 'Polish Region (0=Non Polish, 1=Polish)';
yaxis label='Literacy Rate';
run;

/* Regression analysis */
proc reg data=literacy;
model literacy=protestant hhsize f_young f_female f_urban f_native dist_berlin popn;
title "Regression analysis on literacy rate";
run;

