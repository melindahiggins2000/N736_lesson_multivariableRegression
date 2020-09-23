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

libname library 'C:\MyGithub\N736_lesson_multivariableRegression';

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

* look at indtot as an outcome variable;

proc univariate data=help plots;
  var indtot;
  run;

* look at correlations with other 
  potential predictors
  cesd, mcs, pcs, pss_fr;

proc corr data=help;
  var indtot cesd mcs pcs pss_fr;
  run;

* run regression with all predictors
  and look at 
  multicollinearity statistics (VIF TOL COLLIN)
  get standardized betas (STB)
  confidence intervals for betas (CLB);

proc reg data=help;
  model indtot = cesd mcs pcs pss_fr / STB CLB VIF TOL COLLIN;
  run;

* try sequential regression code
  put cesd in first
  then mcs
  then pcs and pss_fr
  get change in R2 for each term as entered;

proc reg data=help 
         plots=none noprint outest=rsq_data rsquare;
  var indtot cesd mcs pcs pss_fr;

  model indtot=cesd;
  run ;
  model indtot=cesd mcs;
  run ;
  model indtot=cesd mcs pcs pss_fr;
  run ;
quit;

data rsq_extended;
  set rsq_data;
  delta_rsq=dif(_rsq_);
  delta_indvars=dif(_in_);
run;

proc print data=rsq_extended; run;

* Look at sequential adding
  of variable to model
  use / scorr1(seqtests) model option
  put cesd in first and then mcs and then others;

proc reg data=help;
  model indtot = cesd mcs pcs pss_fr / scorr1(seqtests);
  run;

* change variable order and run again
  put mcs in first, then cesd, then others;

proc reg data=help;
  model indtot = mcs cesd pcs pss_fr / scorr1(seqtests);
  run;

* look at stepwise variable selection;

proc reg data=help;
  model indtot = mcs cesd pcs pss_fr / selection=stepwise;
  run;

* an article to review
  https://amstat.tandfonline.com/doi/abs/10.1080/00401706.1967.10490502#.XZ3p7EZKjD5;

* other options to explore
  https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_reg_sect030.htm;

* for example - try Mallow's Cp keep best 5 models
  compare to result from stepwise selection;
* get best variable subset
  using C(p) option for variable selection;

proc reg data=help;
  model indtot = cesd mcs pcs pss_fr / selection = cp best = 5;
  run;






