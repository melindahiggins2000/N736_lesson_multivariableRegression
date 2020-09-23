# ===================================
# Lesson 13 - Multivariate Regression & 
#             Variable Selection
#
# by Melinda Higgins, PhD
# dated 10/11/2017
# ===================================

library(tidyverse)
library(haven)

helpdat <- haven::read_spss("helpmkh.sav")

# create subset
# select indtot, cesd, pss_fr, pcs, mcs

h1 <- helpdat %>%
  select(indtot, cesd, pss_fr, pcs, mcs)

# if we focus on indtot as our outcome of interest
# let's look at building a model using
# cesd, pcs, mcs and pss_fr as possible predictors

# look at the correlation matrix
library(psych)
psych::corr.test(h1, method="pearson")

# notice the high correlation between
# cesd and mcs

# fit a model with cesd
fit.cesd <- lm(indtot ~ cesd, data=h1)

# fit a model with mcs
fit.mcs <- lm(indtot ~ mcs, data=h1)

# fit a model with cesd and mcs
fit.cesdmcs <- lm(indtot ~ cesd + mcs, data=h1)

# compare models
anova(fit.cesd, fit.cesdmcs)
anova(fit.mcs, fit.cesdmcs)

# model with all variables entered together
fit.all <- lm(indtot ~ cesd + pss_fr + pcs + mcs,
              data=h1)

# compare full vs reduced models
anova(fit.cesdmcs, fit.all)

# to get standardized coefficients
# compute the z-scores and refit the model
# we'll use the scale() function
# and make it a data.frame
zh1 <- as.data.frame(scale(h1))
fit.allz <- lm(indtot ~ cesd + pss_fr + pcs + mcs,
              data=zh1)

# compare the coefficients
# use the round() function to neaten up the output
round(data.frame(coefficients(fit.all),
                 coefficients(fit.allz)),
      digits=3)

summary(fit.all)

# look at VIF from car package
library(car)
car::vif(fit.all)

# compare Type I and Type III Sums of Squares
car::Anova(fit.all) # defaults to Type III SS
anova(fit.all) # provides Type I SS

# install olsrr package
# developer version off github did better
# than CRAN
devtools::install_github("rsquaredacademy/olsrr")
library(olsrr)

# learn more at
# https://cran.r-project.org/web/packages/olsrr/vignettes/regression_diagnostics.html

# get a more complete model fit summary
# includes standardized betas
ols_regress(fit.all)

# get DfBeta plots for each variable in model
ols_dfbetas_panel(fit.all)

# residual plot
ols_rsd_qqplot(fit.all)

# get multicollinearity stats
ols_coll_diag(fit.all)

# normality tests for residuals
ols_norm_test(fit.all)

# corelation between observed
# and expected residuals
ols_corr_test(fit.all)

# observed versus predicted plots
ols_ovsp_plot(fit.all)

# diagnostics plots
ols_diagnostic_panel(fit.all)

# stepwise variable selection
k <- ols_stepwise(fit.all)
k
plot(k)

# backwards variable selection
k <- ols_stepaic_backward(fit.all)
k
plot(k)

# forwards variable selection
k <- ols_stepaic_forward(fit.all)
k
plot(k)

# both variable selection
k <- ols_stepaic_both(fit.all)
k
plot(k)

# all possible subsets
k <- ols_all_subset(fit.all)
k
plot(k)

# best subset
k <- ols_best_subset(fit.all)
k
plot(k)



