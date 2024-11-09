/* Exploratory data analysis */
/* Dataset used is Medical appointments */
/* Loading the dataset into the program */
PROC IMPORT DATAFILE="/home/u64071682/LABS/Medical Appointments.csv" DBMS=CSV OUT=df REPLACE;
RUN;

/* DATA WRANGLING */
/* Checking the data to get the details of the variables in the dataset. */
PROC CONTENTS DATA=df VARNUM;
RUN;
/* Checking the descriptive statistics of nuimerical variables in the data */
proc means data=df;
run;
/* checking the missing values in the data */
proc means data=df nmiss;
run;       /* there are no missing values in the data*/
/* Changing the name of variable ‘No-show’ to ‘Show’ 
and changing the label from No-Show to Show. */
data df1 (rename=('No-show'n = Show));
set df;
label 'No-show'n=Show;
run;
/*Inverting show values into integer values */
data df2;
set df1;
if Show='No' then Show=1;
else if Show='Yes' then Show=0;
run;
/* check the names of the variables */
proc print data=df2 (obs=10);
run;
/* Get the date only part out of datetime values of scheduledday and appointmentday in the data. */
data df3 (drop=PatientId AppointmentID);
set df2 (rename=Hipertension=Hypertension);
drop ScheduledDay AppointmentDay;
schld_date= datepart(ScheduledDay);
appoint_date=datepart(AppointmentDay);
format schld_date appoint_date date9.;
day_diff=(appoint_date-schld_date);
run;
/* check the cleaned data once again */
proc print data=df3 (obs=10);
run;
/* checking the structure of the cleaned data */
proc contents data=df3 varnum;
run;
/* I used PROC FREQ procedure to get the percentage 
of Show and create a bar graph */
ods graphics on;
proc freq data=df3;
tables show/ nocum plots=freqplot(type=bar scale=percent);
run;
ods graphics off;
/*  Is gender related to whether a patient will be 
there at the scheduled appointment or not? */
/* Create a stacked bar plot using PROC SGPLOT */
proc freq data=df3;
tables Show*Gender;
run;
ods graphics on;
proc sgplot data=df3;
    vbar gender / group=show groupdisplay=stack;
    xaxis label="Gender";
    yaxis label="Frequency";
    keylegend / title="Show";
    title "Stacked Bar Plot of Gender by Show Status";
run;
ods graphics off;

ods graphics on;
proc freq data=df3;
tables show*gender/ plots=freqplot(twoway=stacked orient=Vertical);
run;
ods graphics off;

/* Are patients with scholarships more likely to miss their appointment? */
ods graphics on;
proc freq data=df3;
tables show*scholarship/ plots=freqplot(twoway=stacked orient=vertical);
run;
ods graphics off;

/*Are patients with hypertension more likely to miss their appointment? */
ods graphics on;
proc freq data=df3;
tables show*hypertension/plots=freqplot(twoway=stacked orient=vertical);
run;
ods graphics off;

/*Are patients who don't receive SMS more likely to miss their appointment? */
ods graphics on;
proc freq data=df3;
tables show*sms_received/plots=freqplot(twoway=stacked orient=Horizontal);
run;
ods graphics off;

/*Is the time difference between the scheduling and appointment related 
to whether a patient will show up for an appointment or not? */
data df4;
set df3;
if day_diff<= 0 then day_diff2 = 'Same Day';
else if day_diff <= 4 then day_diff2 = 'Few Days';
else if day_diff > 4 and day_diff <= 15 then day_diff2 = 'More than 4';
else day_diff2 = 'More than 15';
run;

proc freq data=df4;
tables day_diff2/nocum;
run;

ods graphics on;
proc freq data=df4;
tables show*day_diff2 /plots=freqplot(twoway=grouphorizontal orient=vertical);
run;
ods graphics off;

/* Is there an effect of Age if the patient will turn up for their appointment or not.? */
proc univariate data=df3;
class show;
var age;
histogram age/ overlay;
run;

/* Which are the neighborhood where patients more than 500 are missing their appointments ? */
/* subset the data to only have the no-show data*/
data No_Show;
set df3;
if show = 0;
run;

ods graphics / reset width=14in height=6in imagemap;

proc sgplot data=no_show;
vbar Neighbourhood / group=Show groupdisplay=cluster
fillattrs=(transparency=0.25) datalabelfitpolicy=none;
yaxis grid;
refline 508 / axis=y lineattrs=(thickness=2 color=Red) label
labelattrs=(color=Red);
keylegend / location=inside;
run;

ods graphics / reset;

/* On which weekdays people don’t show up most often? */
/*After changing the dataset by steps mentioned above, I changed the date
to weekday to checon which dates the patients missed most of their 
appointments, 
I also changed the numeric weekdays to weekday names using if then statement  */
data weekdays;
set df3;
appoint_day=weekday(appoint_date);
if appoint_day=1 then week_day='Sun';
else if appoint_day=2 then week_day='Mon';
else if appoint_day = 3 then week_day='Tues';
else if appoint_day = 4 then week_day='Wednes';
else if appoint_day = 5 then week_day='Thurs';
else if appoint_day = 6 then week_day = 'Fri';
else week_day = 'Satr';
run;

/* Bar chart */
proc sgplot data=weekdays;
vbar week_day/ group=show groupdisplay=cluster stat=freq;
title "Weekdays on which most of the appointments were missed";
run;