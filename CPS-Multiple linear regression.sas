/* CHICAGO PUBLIC SCHOOLS ANALYSIS */
/*Multiple Linear Regression Analysis*/
/* load the dataset into the program */
proc import datafile='/home/u64071682/LABS/CPS_ES-HS_ProgressReport_2011-2012.csv' 
out=cps_data dbms=csv replace;
run;

/*  check the structure of the data*/
proc contents data=cps_data varnum;
run;

/* the descriptive statistics of the selected variables */
proc means data=cps_data n min mean stddev p25 median p75 max;
var Average_Student_Attence Rate_of_Misconducts Average_Teacher_Attence 
        X9_Grade_Explore_2009 X11_Grade_Average_ACT_2011 College_Eligibility 
        Graduation_Rate Freshman_on_Track_Rate Probation;
run;
/* visual plots of the target variable and a few predictor variables */
/* Histogram of the variable College_Enrollment */
proc sgplot data=cps_data;
histogram College_enrollment;
density college_enrollment/type=normal;
yaxis label='Frequency';
title "Histogram of College Enrollment of students";
run;

/* Histogram of average student attendance */
proc sgplot data=cps_data;
histogram average_student_attence;
density average_student_attence/ type=normal;
yaxis label='Frequency';
title "Histogram of average student attendance in CPS";
run;

/* Histogram of the rate of misconducts among the students */
proc sgplot data=cps_data;
histogram rate_of_misconducts;
density rate_of_misconducts / type=normal;
yaxis label='Frequency';
title "Histogram of Rate of Misconducts among CPS students";
run;

/* Histogram of freshman on track rate */
proc sgplot data=cps_data;
histogram freshman_on_track_rate;
density freshman_on_track_rate / type=normal;
yaxis label='Frequency';
title "Histogram of Freshman on Track Rate";
run;

/* Regression analysis */
/* set up the initial multiple linear regression model with all the 9 predictors */
proc reg data=cps_data;
model College_Enrollment = Average_Student_Attence Rate_of_Misconducts 
        Average_Teacher_Attence X9_Grade_Explore_2009 X11_Grade_Average_ACT_2011 
        College_Eligibility Graduation_Rate Freshman_on_Track_Rate Probation;
run;

/* check for the presence of multicollinearity among the predictors
this involves calculating the variance inflation factor (VIF) */
PROC REG DATA=cps_data;
model College_Enrollment = Average_Student_Attence Rate_of_Misconducts 
        Average_Teacher_Attence X9_Grade_Explore_2009 X11_Grade_Average_ACT_2011 
        College_Eligibility Graduation_Rate Freshman_on_Track_Rate Probation / vif;
run;

/* 3 variables were removed VIF greater than 10*/
/* the final statistical model without the 3 variables */
PROC REG DATA=cps_data;
MODEL College_Enrollment = Average_Student_Attence Rate_of_Misconducts 
        Average_Teacher_Attence Graduation_Rate Freshman_on_Track_Rate Probation / vif;
run;

/* Variable selection using backward selection */
/* this is done at a significance level of 0.10 */
PROC GLMSELECT DATA=cps_data;
MODEL College_Enrollment = Average_Student_Attence Rate_of_Misconducts 
        Average_Teacher_Attence X9_Grade_Explore_2009 X11_Grade_Average_ACT_2011 
        College_Eligibility Graduation_Rate Freshman_on_Track_Rate Probation / 
        SELECTION=BACKWARD(select=sl) stats=all;
run;

/*ONLY 3 VARIABLES WERE RETAINED FROM THE BACKWARD SELECTION TECHNIQUE  */
/* Check for the best model assumptions */
/* the best model */
PROC REG DATA=cps_data;
MODEL College_Enrollment = rate_of_misconducts X9_Grade_Explore_2009 Freshman_on_Track_Rate/ vif;
run;
/*  linearity assumption */
PROC SGSCATTER DATA=cps_data;
matrix college_enrollment rate_of_misconducts X9_Grade_Explore_2009 Freshman_on_Track_Rate;
run;
/* independence of residuals */
PROC REG DATA=cps_data;
MODEL College_Enrollment = rate_of_misconducts X9_Grade_Explore_2009 Freshman_on_Track_Rate/ vif;
output out=residuals r=resid;
run;