/* Simulate the data */
/* we imagine we are examining factors that influence sales */
/* Sales (Dependent Variable)
Advertising (Independent Variable 1)
Price (Independent Variable 2)
Store_Size (Independent Variable 3)*/
DATA sales_data;
input Sales Advertising Price Store_size;
datalines;
    150 30 10 200
    200 45 12 220
    180 40 11 210
    220 50 10 250
    170 35 12 230
    160 30 11 240
    210 48 10 260
    190 40 11 250
    205 42 12 230
    175 35 11 240 
    ;
run;

/* explore the data */
/* descriptive statistics */
proc means data=sales_data;
run;

/* correlations */
proc corr data=sales_data;
var Sales Advertising Price Store_size;
run;

/* fit the multiple linear regression to the data */
proc reg data=sales_data;
model Sales=Advertising Price Store_size;
run;
quit;

