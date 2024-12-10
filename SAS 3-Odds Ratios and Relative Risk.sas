/* Inputting data manually in SAS using datalines function */
DATA gordis;
        INPUT exposed $ disease $ patients;
DATALINES ;
        exposed disease 50
        exposed none    50
        not_exp disease 25
        not_exp none    75
;

/* calculate the odd ratios and relative risk */
PROC FREQ DATA=gordis;
TABLES EXPOSED*DISEASE / RELRISK RISKDIFF;
WEIGHT PATIENTS;
RUN;

/* Manually input data for question 2 */
DATA TEST_RESULT;
     INPUT ECONOMICS $ BUSINESS $ STUDENTS;
     DATALINES;
     pass pass 47
     fail pass 87
     pass fail 23
     fail fail 2
 ;
 
/* calculate the odds ratios and relative risk */
PROC FREQ DATA=test_result;
      TABLES ECONOMICS*BUSINESS / RELRISK RISKDIFF;
      WEIGHT STUDENTS;
RUN;
 