/* Loading the dataset into SAS studio */

FILENAME REFFILE '/home/u64071682/diabetes_dataset.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

/* check the structure of the loaded data */
PROC CONTENTS DATA=WORK.IMPORT1; RUN;

/* chi square test */
PROC FREQ DATA=WORK.IMPORT1 ORDER=DATA;
       TABLES GENDER*SMOKING_HISTORY / CHISQ;
       RUN;
       
/* frequency distribution */
PROC FREQ DATA = WORK.IMPORT1;
      TABLES GENDER;
      RUN;

/* descriptive statistics */
PROC MEANS DATA=WORK.IMPORT1;
RUN;