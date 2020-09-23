* ===========================================
  Check to make sure you have run helpformats01.sas
  first to create and apply the formats
  and the create the library "library"

  If you've already got the formats.sas7bcat
  created, you can run the LIBNAME statement
  again if needed, otherwise comment this code out
  or skip it
* ===========================================;

* ===========================================
  CHANGE the location of the DIRECTORY below
  to the location where your files are

  CREATE a link to your files called "library"
* ===========================================;

libname library 'C:\EMORY-SON\NRSG736_previousStatsSPSScourse\Fall2019\CorrelationRegression' ;

* ===========================================
  In general it is a good idea to make a 
  copy of the original data - here I'm
  putting a copy into the WORK library.

  The rest of the code is then run in the WORK
  library (which is temporary) so the original
  file is left untouched.
* ===========================================;

* make a copy to WORK;
data help;
  set library.helpmkh;
  run;

* check dataset read ok;

proc contents data=help; run;

* get summary stats
  for multiple vars;
proc means data=help n min max mean std median q1 q3;
  var age female cesd pcs mcs;
  run;

proc freq data=help;
  tables female;
  run;

* get summary stats
  by gender female;
proc means data=help n min max mean std median q1 q3;
  var age cesd pcs mcs;
  class female;
  run;

* ==================================
  continuous - continuous
  compute correlations
  ==================================;

proc corr data=help;
  var cesd age female pcs mcs;
  run;

* ==================================
  unique feature of SAS
  use the WITH option in PROC CORR
  helps to focus on specific columns
  of correlation matrix
  ==================================;

proc corr data=help;
  var cesd;
  with age female pcs mcs;
  run;

* scatterplot of cesd by age;

proc sgplot data=help;
  reg x=age y=cesd;
run;

* add confidence intervals
  for mean predicted values CLM
  or individual predicted values CLI;

proc sgplot data=help;
  reg x=age y=cesd / CLM CLI;
run;

* run regression of cesd by age
  add STB option to get standardized coefficients
  notice that std_beta1 std_slope
  is same as Pearson's r correlation;

proc reg data=help;
  model cesd = age / STB;
  run;

* make a boxplot of cesd by female;

proc sgplot data=help;
  title "CESD scores by gender";
  vbox cesd / category=female;
run;
title;

* run t-test of cesd by female;

proc ttest;
  class female;
  var cesd;
  run;

* run regression of cesd by female
  note what the y-intercept is (mean CESD for males)
  and the slope is the mean difference
  between males and females (i.e. change from males to females)
  remember male=0 and female=1;

proc reg data=help;
  model cesd = female / STB;
  run;

* scatterplot of cesd by mcs;

proc sgplot data=help;
  reg x=mcs y=cesd;
run;

* recenter mcs at population norm of 50;

data help2;
  set help;
  mcs_minus50 = mcs - 50;
  run;

* make another scatterplot
  add reference line at new x=0
  set at Population Norm MCS=50
  make reference line color RED;

proc sgplot data=help2;
  reg x=mcs_minus50 y=cesd;
  refline 0 / axis=x label="Population Norm MCS=50" lineattrs=(color=red);
run;



