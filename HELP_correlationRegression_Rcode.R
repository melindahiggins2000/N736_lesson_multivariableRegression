#' =======================================
#' Working with the HELP dataset
#' 
#' Melinda Higgins, PhD
#' last updated 09/16/2020
#' =======================================

# load packages
library(dplyr)
library(tidyverse) # also loads ggplot2, dplyr, and others

# The *.Rdata file can be downloaded from the SASR website
# https://nhorton.people.amherst.edu/sasr2/datasets.php 
#
# download the dataset and put it in your 
# current project directory

# load the dataset help.Rdata
load("help.Rdata")

# this loads the data frame "helpdata"
# list of variable names in dataset
names(helpdata)

# This dataset has 453 observations and 88 vars
# various r functions for getting data.frame
# dimensions. 
dim(helpdata)

# let's look at age, female, racegrp, cesd, pcs and mcs.
helpset1 <- helpdata %>%
  select(age, female, racegrp, cesd, pcs, mcs)

# simple summary
summary(helpset1)

# let's make female a factor
# with appropriate labels and levels defined
helpset1$femaleF <- factor(helpset1$female,
                           levels=c(0,1),
                           labels=c("male","female"))

# check
table(helpset1$female)
table(helpset1$femaleF)

# =======================================
# continuous - continuous
# =======================================

# select the continuous variables
# also add female, dichotomous
vars <- c("cesd", "age", "female", "pcs", "mcs")

# parametric Pearson's R correlation
# non-parametric Spearman's rho
# non-parametric Kendall's tau - good for rank ties

cor(helpset1[,vars],
    method="pearson")
cor(helpset1[,vars],
    method="spearman")
cor(helpset1[,vars],
    method="kendall")

# can also use the corr.test() in the psych
# package to get the p-values, t-tests,
# and confidence intervals, in addition to
# the correlations
library(psych)
psych::corr.test(helpset1[,vars],
                 method="pearson")

# save the results
pc <- psych::corr.test(helpset1[,vars],
                       method="pearson")

# look at correlations
pc$r

# t-test for each correlation
pc$t

# p-value of each t-test for correlation
pc$p

# confidence intervals for each pair
# removes the diagonal values and tests
pc$ci

# also look at spearmans rho
pc <- psych::corr.test(helpset1[,vars],
                       method="spearman")
pc$ci

# =======================================
# continuous with 2-group categorical
# =======================================
# this is basically a t-test
vars <- c("female","age","cesd")
pc <- psych::corr.test(helpset1[,vars],
                       method="pearson")
pc$ci

pc$t

# compare to running a t-test
options(digits=8)
t.test(age ~ female, helpset1)
t.test(cesd ~ female, helpset1)

t.test(cesd ~ female, helpset1, var.equal = TRUE)

# R defaults to unpooled t-test
# var.equal = FALSE by default
# change to var.equal = TRUE
t.test(age ~ female, 
       var.equal = TRUE,
       helpset1)

# check equal variances
# ideally run this first
# to see if you need var.equal = TRUE or FALSE
bartlett.test(age ~ female, helpset1)

# non-parametric 2-group tests
# Mann Whitney U test
wilcox.test(age ~ female, helpset1)
wilcox.test(cesd ~ female, helpset1)

# =================================
# look at using regression
# =================================

# scatterplot of age (x) with CESD (y)
ggplot(helpset1, aes(age, cesd)) +
  geom_point() 

# add best fit linear line
ggplot(helpset1, aes(age, cesd)) +
  geom_point() +
  geom_smooth(method = "lm")

# get the best fit line equation
# simple linear regression using lm()
lm1 <- lm(cesd ~ age, data=helpset1)
summary(lm1)

# the y-intercept is not meaningful
# since there are no children < 19
# so CESD when age=0 doesn't mean anything

# youngest age is 19
min(helpset1$age, na.rm=TRUE)

# if we create a new variable for age - 19
# and rerun the equation, now the
# y-intercept is the avg CESD score for people age 19
# adjust age to years from 19
helpset1 <- helpset1 %>%
  mutate(age_19 = age - 19)

# updated best fit line
# notice that y-intercept changes but slope is same
lm1 <- lm(cesd ~ age_19, data=helpset1)
summary(lm1)

# updated plot
ggplot(helpset1, aes(age_19, cesd)) +
  geom_point() +
  geom_smooth(method = "lm")

# female is coded 1 for female
# and 0 for male
# let's look at the best fit line for
# 

cor(helpset1[,c("cesd", "female")],
    method="pearson")

library(psych)
cortest1 <- psych::corr.test(helpset1[,c("cesd", "female")],
                 method="pearson")
cortest1
cortest1$r
cortest1$p
cortest1$t

t.test

lm2 <- lm(cesd ~ female, data=helpset1)
summary(lm2)

# if we compute z-scores for both x's and y
# then we can get the standardized coefficients
helpset1 <- helpset1 %>% 
  mutate(zcesd = (cesd - mean(cesd))/sd(cesd),
         zfemale = (female - mean(female))/sd(female))

# now the "beta" coefficient is same
# as the correlation
lm3 <- lm(zcesd ~ zfemale, data=helpset1)
summary(lm3)



