/* Chi-Square test */
PROC FREQ DATA=WORK.IMPORT order=data;
            tables Gender*CauseofDeath / chisq;
run;

/*frequency table  */
PROC FREQ DATA=WORK.IMPORT order=data;
            tables Gender;
RUN;

/* summary statistics */
PROC MEANS DATA=WORK.IMPORT;
RUN;
