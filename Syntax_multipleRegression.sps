* Encoding: UTF-8.
* =======================================.
* Multiple Regression - lesson for NRSG 736
*
* updated 09/23/2020, Melinda Higgins, PhD
* =======================================.

* NOTE: This SYNTAX assumes you are working
* with the "helpmkh.sav" dataset.

* look at indtot - Inventory of Drug Use Consequences.

FREQUENCIES VARIABLES=indtot
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* look at correlation with other possible predictors
* cesd, pcs, mcs and pss_fr
* and with the indtot outcome measure.

CORRELATIONS
  /VARIABLES=indtot cesd pss_fr pcs mcs
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* model with all 4 predictors
* include multicollinearity diagnostics.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT indtot
  /METHOD=ENTER cesd pss_fr pcs mcs
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* run model put cesd in first
* then put in mcs
* then put in pcs and pss_fr.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT indtot
  /METHOD=ENTER cesd
  /METHOD=ENTER mcs
  /METHOD=ENTER pss_fr pcs
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* run again but put mcs in first and then cesd
* then the others pcs and pss_fr.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT indtot
  /METHOD=ENTER mcs
  /METHOD=ENTER cesd
  /METHOD=ENTER pss_fr pcs
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* try running with stepwise variable selection.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT indtot
  /METHOD=STEPWISE mcs pss_fr pcs cesd
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* run with model for cesd, mcs and pss_fr together
  and SAVE predicted values.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT indtot
  /METHOD=ENTER mcs pss_fr cesd
  /PARTIALPLOT ALL
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID)
  /SAVE PRED.

* make plot of observed indtot versus predicted
  these saved predicted values are PRE_1.

GRAPH
  /SCATTERPLOT(BIVAR)=PRE_1 WITH indtot
  /MISSING=LISTWISE.

* let's look at a transformation
  to improve normality issues
  subtract indtot from its maximum of 50
  then take the SQRT.

COMPUTE sqrt_50_minus_indtot=sqrt(50 - indtot).
EXECUTE.

* and try a natural log (LN) but add 1 to not have a zero input.

COMPUTE ln_50_minus_indtot_plus1=LN(50 - indtot + 1).
EXECUTE.

* now look at normality stats.

EXAMINE VARIABLES=indtot sqrt_50_minus_indtot ln_50_minus_indtot_plus1
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* all of the transformations help a little but 
  now the result is hard to interpret.

* ==========================
* Try Automatic Linear Modeling
* added about v.26 or so in SPSS
* ==========================.

* settings below look at best possible subsets.
*Automatic Linear Modeling. 

LINEAR 
  /FIELDS TARGET=indtot INPUTS=cesd mcs pcs pss_fr 
  /BUILD_OPTIONS OBJECTIVE=STANDARD USE_AUTO_DATA_PREPARATION=FALSE CONFIDENCE_LEVEL=95 
    MODEL_SELECTION=BESTSUBSETS CRITERIA_BEST_SUBSETS=AICC REPLICATE_RESULTS=TRUE SEED=54752075
  /ENSEMBLES COMBINING_RULE_CONTINUOUS=MEAN COMPONENT_MODELS_N=10.



