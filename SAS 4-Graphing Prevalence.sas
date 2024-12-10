/* Inputting data into the SAS program  */
DATA HIVDATA;
    INPUT Country $ Year $ HIVPrev ;
DATALINES;
    USA 2010 14.7
    USA 2011 14
    USA 2012 13.5
    USA 2013 13
    Nigeria 2010 410
    Nigeria 2011 412
    Nigeria 2012 415
    Nigeria 2013 420
;

/* Line graph  */
PROC SORT
    DATA=WORK.HIVDATA(KEEP=Year HIVPrev Country)
    OUT=WORK.SORTTempTableSorted
    ;
    BY Year;
RUN;
SYMBOL1
    INTERPOL=JOIN
    HEIGHT=10pt
    VALUE=NONE
    LINE=1
    WIDTH=2
 
    CV = _STYLE_
;
SYMBOL2
    INTERPOL=JOIN
    HEIGHT=10pt
    VALUE=NONE
    LINE=1
    WIDTH=2
 
    CV = _STYLE_
;
Legend1
    FRAME
    ;
Axis1
    STYLE=1
    WIDTH=1
    MINOR=NONE
;
Axis2
    STYLE=1
    WIDTH=1
    MINOR=NONE 
;
TITLE;
TITLE1 "HIV Prevalence per 100,000 Population as reported by WHO, 2010 - 2013";
FOOTNOTE;
FOOTNOTE1 "Holland, P. R. (2015). SAS programming and data visualization techniques: a power user's guide. Apress.";
PROC GPLOT DATA = WORK.SORTTempTableSorted
;
PLOT HIVPrev * Year      =Country
 /
     VAXIS=AXIS1
 
    HAXIS=AXIS2
 
FRAME    LEGEND=LEGEND1
;
RUN;

/* Input data in SAS manually for Question 2 */
/* Inputting data into the SAS program */
DATA CANCERDATA;
    INPUT Country $ Year $ CancerIncidence ;
DATALINES;
    USA 2010 442.7
    USA 2011 440.1
    USA 2012 437.3
    USA 2013 434.5
    Canada 2010 345.6
    Canada 2011 342.9
    Canada 2012 340.2
    Canada 2013 337.8
    UK 2010 398.7
    UK 2011 396.2
    UK 2012 393.6
    UK 2013 391.1
;

/* Sorting data for graphing */
PROC SORT
    DATA=WORK.CANCERDATA(KEEP=Year CancerIncidence Country)
    OUT=WORK.SORTTempTableSorted;
    BY Year;
RUN;

/* Graph customization */
SYMBOL1
    INTERPOL=JOIN
    HEIGHT=10pt
    VALUE=NONE
    LINE=1
    WIDTH=2
    CV = _STYLE_;
Legend1 FRAME;
Axis1
    STYLE=1
    WIDTH=1
    MINOR=NONE;
Axis2
    STYLE=1
    WIDTH=1
    MINOR=NONE;

/* Titles and Footnotes */
TITLE;
TITLE1 "Cancer Incidence Rates per 100,000 Population: 2010-2013";
FOOTNOTE;
FOOTNOTE1 "World Health Organization. (2023). Cancer Statistics. Retrieved from [your source].";

/* Line graph generation */
PROC GPLOT DATA=WORK.SORTTempTableSorted;
    PLOT CancerIncidence * Year = Country / 
        VAXIS=AXIS1 
        HAXIS=AXIS2 
        FRAME 
        LEGEND=LEGEND1;
RUN;
QUIT;
