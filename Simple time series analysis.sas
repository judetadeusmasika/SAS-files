/* TIME SERIES ANALYSIS */
/* Load the GoldSilver times series data into the program */
PROC IMPORT DATAFILE='/home/u64071682/LABS/GoldSilver.csv' 
DBMS=CSV OUT=goldsilver REPLACE;
RUN;

/* check the structure of the data  */
PROC CONTENTS DATA=goldsilver varnum;
run;

/* check the basic summary statistics */
PROC MEANS DATA=goldsilver n mean stddev min max;
var gold silver;
run;

/* correlation between gold and silver */
PROC CORR DATA=goldsilver;
var gold silver;
run;

/* visualize trends of gold and silver over time */
PROC SGPLOT DATA=goldsilver;
series x=date y=gold / lineattrs=(color=yellow thickness=2) legendlabel='Gold spot price';
series x=date y=silver / lineattrs=(color=gray thickness=2) legendlabel='Silver spot price';
xaxis label='Date';
yaxis label='Spot Price';
run;

/* Histograms and density plots of gold and silver */
PROC SGPLOT DATA=goldsilver;
HISTOGRAM gold;
DENSITY gold;
TITLE 'Histogram and density plot of Gold spot prices';
xaxis label='Gold prices';
yaxis label='Frequency';
run;

PROC SGPLOT DATA=goldsilver;
HISTOGRAM silver;
DENSITY silver;
TITLE 'Histogram and density plot of Silver spot prices';
xaxis label='Silver prices';
yaxis label='Frequency';
run;

/* decompose the time series data */
/* PROC TIMESERIES DATA=goldsilver outdecomp=decomp; */
/* id date interval=month; */
/* var gold; */
/* decomp trend cycle seasonal; */
/* run; */
/*  */
/* PROC TIMESERIES DATA=goldsilver outdecomp=decomp1; */
/* id date interval=month; */
/* var silver; */
/* decomp trend cycle seasonal; */
/* run; */
/*  */
/* plot the decomposition results */
/* PROC SGPLOT DATA=decomp; */
/* series x=date y=trend / lineattrs=(color=blue thickness=2) legendlabel='Trend component'; */
/* series x=date y=cycle / lineattrs=(color=red thickness=2) legendlabel='Cyclic component'; */
/* series x=date y=seasonal / lineattrs=(color=gray thickness=2) legendlabel='Seasonal component'; */
/* xaxis label='Date'; */
/* yaxis label='Gold price components'; */
/* run; */

/* scatter plot of gold and silver to display the relationship */
PROC SGPLOT DATA=goldsilver;
SCATTER x=silver y=gold / MARKERATTRS=(symbol=circlefilled);
xaxis label='Silver prices';
yaxis label='Gold prices';
run; /* the scatter plot is not so good but it displays a positive reltionship*/

/* Pivot longer in sas*/
PROC TRANSPOSE DATA=goldsilver out=data_long name=Metal;
by date;
var gold silver;
run;

/* rename the col1 column (transposed value) to price */
data work.data_long;
     set work.data_long;
     rename col1=Price;
run;

/* preview the formatted data */
proc print data=data_long (obs=10);
run;

/* the boxplot for gold and silver prices */
proc sgplot data=data_long;
vbox price / category=metal;
xaxis label='Metal';
yaxis label='Price';
title 'The boxplot of Gold and Silver prices';
run;

/* Plotting the cross correlation function (CCF)*/
proc arima data=goldsilver;
identify var=gold crosscorr=silver;
run;

/* test for stationarity of the variables gold and silver */
/* gold price */
PROC ARIMA DATA=goldsilver;
IDENTIFY VAR=gold STATIONARITY=(ADF=1);
RUN;

/* silver price */
PROC ARIMA DATA=GOLDSILVER;
IDENTIFY VAR=SILVER STATIONARITY=(ADF=1);
RUN;

/* Differencing the variables to ensure they are stationary*/
 DATA diff_goldsilver;
 SET goldsilver;
 diff_gold = dif(gold);
 diff_silver = dif(silver);
 run;
 
/* perform the ADF test once again on the differenced variables */
/* gold */
PROC ARIMA DATA=diff_goldsilver;
IDENTIFY VAR=diff_gold STATIONARITY=(ADF=1);
RUN;

/* silver */
PROC ARIMA DATA=diff_goldsilver;
IDENTIFY VAR=diff_silver STATIONARITY=(ADF=1);
RUN;

/* Model testing and forecasting (Autoregressive model) */
/* gold */
PROC ARIMA DATA=diff_goldsilver;
IDENTIFY VAR=diff_gold nlag=5; /* check up to 5 lags */
ESTIMATE P=5; /* specify the number of lags*/
RUN;

/* silver */
PROC ARIMA DATA=diff_goldsilver;
IDENTIFY VAR=DIFF_SILVER NLAG=4;
ESTIMATE P=4;
RUN;

/* Forecasting */
/* gold forecasts */
PROC ARIMA DATA=goldsilver;
IDENTIFY VAR=GOLD NLAG=5;
ESTIMATE P=5;
FORECAST LEAD=10 OUT=GOLD_FORECAST; /* generate 10 step ahead forecasts*/
RUN;

/* silver forecasts */
PROC ARIMA DATA=goldsilver;
IDENTIFY VAR=SILVER NLAG=4;
ESTIMATE P=4;
FORECAST LEAD=10 OUT=SILVER_FORECAST;
RUN;

/* the accuracy of the forecasts */
/* GOLD */
DATA GOLD_ACCURACY;
   SET GOLD_FORECAST;
   absolute_error = abs(gold - forecast); 
   squared_error = (gold - forecast)**2;
   absolute_percentage_error = abs(gold - forecast) / gold * 100;
run;

PROC MEANS DATA=GOLD_ACCURACY MEAN;
VAR ABSOLUTE_ERROR SQUARED_ERROR ABSOLUTE_PERCENTAGE_ERROR;
OUTPUT OUT=GOLD_ACCURACY_METRICS MEAN=MAE MSE MAPE;
RUN;

PROC PRINT DATA=GOLD_ACCURACY_METRICS;
TITLE 'FORECAST ACCURACY METRICS FOR GOLD';
RUN;

/* SILVER */
DATA SILVER_ACCURACY;
  SET SILVER_FORECAST;
  absolute_error = abs(silver - forecast);
  squared_error = (silver - forecast)**2;
  absolute_percentage_error = abs(silver - forecast) / silver *100;
run;

PROC MEANS DATA=silver_accuracy MEAN;
VAR ABSOLUTE_ERROR SQUARED_ERROR ABSOLUTE_PERCENTAGE_ERROR;
OUTPUT OUT=SILVER_ACCURACY_METRICS MEAN= MAE MSE MAPE;
RUN;

PROC PRINT DATA=SILVER_ACCURACY_METRICS;
TITLE 'FORECAST ACCURACY METRICS FOR SILVER';
RUN;
