library(tidyverse)
library(ggplot2)
library(caret)
library(pastecs)
library(gridExtra)

##### PROB 1 ##### 

ds1 <- read_csv('../data/dataset1.csv')
ds2 <- read_csv('../data/dataset2.csv')
ds3 <- read_csv('../data/dataset3.csv')
ds4 <- read_csv('../data/dataset4.csv')
ed <- read_csv('../data/education.csv')

####### Problem 1 #######

# a) Report the sample mean, sample standard deviation, and sample size for each of the four data sets.
# (Hint: In Radiant, go to Data > Explore)
summary(ds1)
grid.table(stat.desc(ds1) %>% mutate(y = round(y,2), x = round(x,2)))


mod1a <- lm(formula = y ~ x, data = ds1)
summary(mod1a)

ggplot(ds1, aes(x=x, y=y)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

###

summary(ds2)
grid.table(stat.desc(ds2) %>% mutate(y = round(y,2), x = round(x,2)))

mod2a <- lm(formula = y ~ x, data = ds2)
summary(mod2a)

ggplot(ds2, aes(x=x, y=y)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

###

summary(ds3)
grid.table(stat.desc(ds3) %>% mutate(y = round(y,2), x = round(x,2)))

mod3a <- lm(formula = y ~ x, data = ds3)
summary(mod3a)

ggplot(ds3, aes(x=x, y=y)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

###

summary(ds4)
grid.table(stat.desc(ds4) %>% mutate(y = round(y,2), x = round(x,2)))

mod4a <- lm(formula = y ~ x, data = ds4)
summary(mod4a)

ggplot(ds4, aes(x=x, y=y)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)


ds1 <- ds1 %>% mutate(dataset = 'dataset 1')
ds2 <- ds2 %>% mutate(dataset = 'dataset 2')
ds3 <- ds3 %>% mutate(dataset = 'dataset 3')
ds4 <- ds4 %>% mutate(dataset = 'dataset 4')

concat_df <- rbind(ds1, ds2, ds3, ds4)

ggplot(concat_df, aes(x=x, y=y, color=dataset)) +
  geom_point()

ggplot(concat_df, aes(x=x, y=y, color=dataset)) +
  geom_point()+ facet_grid(. ~ dataset)

##### Problem 2 ##### 

summary(ed)


ggplot(ed, aes(x=height, y=math_score)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

mod1a_ed <- lm(math_score ~ height, ed)
summary(mod1a_ed)

mod2a_ed <- lm(math_score ~ height * grade_level, ed)
summary(mod2a_ed)

ed <- ed %>% mutate(interaction_predicted = predict(mod2a_ed, newdata = ed %>% select(height, grade_level)),
                    linear_prediction = predict(mod1a_ed, newdata = ed %>% select(height, grade_level)))

###############SAME AS ABOVE##################

dummy <- dummyVars(" ~ .", data=ed)
dummy_ed <- data.frame(predict(dummy, newdata=ed))


mod3a_ed <- lm(math_score ~ height * `grade_level7th` + height * `grade_level8th`, dummy_ed)
summary(mod3a_ed)




