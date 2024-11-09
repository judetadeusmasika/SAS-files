data df;
input Name $ Age Education_level $ High_bp;
cards;
Peter   24 high_school 140
Adrian  29 college     175
Jesse   30 high_school 120
Nancy   25 college     115
run;
/* get the frequency of the data */
PROC FREQ DATA=df;
run;
PROC MEANS DATA=df;
run;
PROC PRINT DATA=df;
run;

/* Loading an external data */
PROC IMPORT DATAFILE= '/home/u64071682/RETURN.xlsx' DBMS=XLSX out =RETURN replace;
run;
/* statistical analysis */
/* summary statistics */
proc means data=RETURN;
run;

/* distribution summary */
proc univariate data=RETURN;
run;

/* Regression analysis */
proc reg;
model RF=CMA VIX RMW HML;
RUN;

/* ploting */
proc plot;
plot RF*VIX;
RUN;

/* use the VAR statement which allows you to select the variables to ptint*/
proc print
data=RETURN;
VAR StataYear RET Inflation Unemp MktRF;
RUN;

/* the NOOBS statement that supresses the number of observations*/
proc print
data=RETURN NOOBS;
VAR StataYear RET Inflation Unemp MktRF;
RUN;

/* the where statement that subsets the data by conditioning*/

proc print
data= RETURN NOOBS;
VAR StataYear RET Inflation Unemp MktRF;
where StataYear=2022;
run;

proc plot;
plot MktRF*StataYear;
run;

/* where logical operators */
proc print
data=RETURN;
VAR StataYear RET Inflation Unemp MktRF;
WHERE StataYear = 2022 AND Inflation>1;
run;

proc print
data=RETURN;
VAR StataYear RET Inflation Unemp MktRF;
where StataYear=2000 or StataYear=1997;
RUN;

/* where special operators (between and, contains (?)*/
proc print
data=RETURN;
VAR StataYear RET Inflation Unemp MktRF;
where Unemp between 7.5 and 8.5;
run;

*proc print
data=RETURN;
*VAR StataYear RET Inflation Unemp MktRF;
*WHERE StataYear CONTAINS 1997;
*RUN; /* requires character data */


