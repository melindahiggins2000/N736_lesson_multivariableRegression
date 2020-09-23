* Encoding: UTF-8.

* look at descriptive stats.

FREQUENCIES VARIABLES=age female cesd pcs mcs pss_fr
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* look at Pearson's correlations with CESD (and among other variables).

CORRELATIONS
  /VARIABLES=cesd age female pss_fr pcs mcs
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* let's look at a few of these
* make scatterplots.

* overlay best fit line
* notice line is basically flat - no association.

GRAPH
  /SCATTERPLOT(BIVAR)=age WITH cesd
  /MISSING=LISTWISE.

* gender is coded 0 and 1
* notice the "best fit" line is not flat
* there is a difference by gender.

GRAPH
  /SCATTERPLOT(BIVAR)=female WITH cesd
  /MISSING=LISTWISE.

* can also look at these differences using a dot plot
* like a stacked histogram.

XGRAPH CHART=[POINT] BY cesd[s]
  /DISPLAY DOT=ASYMMETRIC
  /PANEL ROWVAR=female ROWOP=CROSS.

* could also make side-by-side boxplots.

EXAMINE VARIABLES=cesd BY female
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.

* and CESD and MCS are strongly correlated
* these measure similar constructs
* depressive symptoms and mental quality of life.

GRAPH
  /SCATTERPLOT(BIVAR)=mcs WITH cesd
  /MISSING=LISTWISE.

* now let's look at these relationships in the context of regression.
* note R2, intercept and slope terms
* what does the y-intercept mean? how coud we improve this interpretation?
* review diagnostic plots

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT cesd
  /METHOD=ENTER age
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* youngest person is 19
* suppose we look at age as years from 19?

compute age_from_19 = age - 19.
execute.

* re-run regression and note change in y-intercept.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT cesd
  /METHOD=ENTER age_from_19
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* let's run regression for gender - female.
* female is coded 0 = male and 1 = female
* the y-intercept is the average CESD for males
* the slope is the difference between males and females.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT cesd
  /METHOD=ENTER female
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* let's also run a t-test and compare to the regression results.

T-TEST GROUPS=female(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=cesd
  /CRITERIA=CI(.95).

* run a regression of the CESD by the mcs.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT cesd
  /METHOD=ENTER mcs
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* a score of 50 in the MCS indicates the population
* norm for mental quality of life
* let's recenter the MCS as scores from 50
* where positive scores are above the population norm
* and negative numbers are below the population norm.

compute mcs_minus50 = mcs - 50.
execute.

* rerun regression using MCS scores minus 50.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT cesd
  /METHOD=ENTER mcs_minus50
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* update the scatterplot using mcs_minus50.
* and overlay the best fit line.

GRAPH
  /SCATTERPLOT(BIVAR)=mcs_minus50 WITH cesd
  /MISSING=LISTWISE.
