# ===================================
# Lesson N736 - Multivariate Regression & 
#               Variable Selection
#
# by Melinda Higgins, PhD
# updated 09/23/2020
# ===================================

library(tidyverse)

load("help.Rdata")

# create subset
# select indtot, cesd, pss_fr, pcs, mcs

h1 <- helpdata %>%
  select(indtot, cesd, pss_fr, pcs, mcs)

# if we focus on indtot as our outcome of interest
# let's look at building a model using
# cesd, pcs, mcs and pss_fr as possible predictors

# look at the correlation matrix
library(psych)
psych::corr.test(h1, method="pearson")

# notice the high correlation between
# cesd and mcs

# fit a model with cesd, get model summary
fit.cesd <- lm(indtot ~ cesd, data=h1)
summary(fit.cesd)

# fit a model with mcs, get model summary
fit.mcs <- lm(indtot ~ mcs, data=h1)
summary(fit.mcs)

# fit a model with cesd and mcs, get model summary
fit.cesdmcs <- lm(indtot ~ cesd + mcs, data=h1)
summary(fit.cesdmcs)

# compare models
anova(fit.cesd, fit.cesdmcs)
anova(fit.mcs, fit.cesdmcs)

# model with all variables entered together
fit.all <- lm(indtot ~ cesd + pss_fr + pcs + mcs,
              data=h1)
summary(fit.all)

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
car::Anova(fit.all, type = 3) # request Type III SS
anova(fit.all) # provides Type I SS

# and see tests and p-values for summary
# these match Type III SS
summary(fit.all)




# install olsrr package - ok off CRAN
# developer version off github did better
# other option
# devtools::install_github("rsquaredacademy/olsrr")
library(olsrr)

# learn more at
# https://cran.r-project.org/web/packages/olsrr/vignettes/regression_diagnostics.html

# get a more complete model fit summary
# includes standardized betas
ols_regress(fit.all)

# get DfBeta plots for each variable in model
# ols_dfbetas_panel(fit.all) - old function replaced
ols_plot_dfbetas(fit.all)

# residual plot
# ols_rsd_qqplot(fit.all) - old function replaced
ols_plot_resid_qq(fit.all)

# get multicollinearity stats
ols_coll_diag(fit.all)

# normality tests for residuals
# ols_norm_test(fit.all) - old function replaced
ols_test_normality(fit.all)

# corelation between observed
# and expected residuals
# ols_corr_test(fit.all) - old function replaced
ols_test_correlation(fit.all)

# observed versus predicted plots
# ols_ovsp_plot(fit.all) - old function replaced
# BLUE line is 1:1 Y=X line, ideal
# RED line is actual best fit line
# ideally RED and BLUE lines should line up
ols_plot_obs_fit(fit.all)

# diagnostics plots
# ols_diagnostic_panel(fit.all) - old function replaced
ols_plot_diagnostics(fit.all)

# stepwise variable selection
# get Mallows C(p) and AIC and more
# k <- ols_stepwise(fit.all) - old function replaced
# variable selection based on p-values
k <- ols_step_both_p(fit.all)
k
plot(k)

# backwards variable selection
# k <- ols_stepaic_backward(fit.all) - old function replaced
k <- ols_step_backward_aic(fit.all)
k
plot(k)

# forwards variable selection
# k <- ols_stepaic_forward(fit.all) - old function replaced
k <- ols_step_forward_aic(fit.all)
k
plot(k)

# both variable selection
# k <- ols_stepaic_both(fit.all) - old function replaced
# variable selection based on AIC values
k <- ols_step_both_aic(fit.all)
k
plot(k)

# all possible subsets
# k <- ols_all_subset(fit.all)
k <- ols_step_all_possible(fit.all)
k
plot(k)

# get coefficients of each model
ols_step_all_possible_betas(fit.all)

# best subset
# k <- ols_best_subset(fit.all) - old function replaced
# looks at R2, MSE, Mallows Cp and AIC
k <- ols_step_best_subset(fit.all)
k
plot(k)



