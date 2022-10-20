# HW 3

# 1a

# Calculate Z score for 3 min

#1a

mean <- 3.8
sd <- .95

z_3 <- (3-mean)/sd
prob_less_than_three <- pnorm(z_3)
prob_less_than_three

z_5 <- (5-mean)/sd
prob <- pnorm(z_5)
prob_greater_than_five <- 1-prob

1 - prob_less_than_three - prob_greater_than_five

#1b

n <- 10
z_sample_10 <- (3-mean) / (sd/sqrt(n))
prob_greater_than_three <- 1-pnorm(z_sample_10)
prob_greater_than_three

#1c 

1.645 * sd/sqrt(n)

# 2b
# https://stats.stackexchange.com/questions/316977/sample-mean-margin-of-error-and-c-i
# https://datascience.stackexchange.com/questions/10093/how-to-find-a-confidence-level-given-the-z-value

library(tidyverse)
df <- read_csv('newsales.csv')

mean_x <- mean(df$`New Sales`)
std_err  <- sd(df$`New Sales`)/sqrt(50)

# t-dist
crit_val_qt <- qt(0.975, df=49)   
margin_of_error_qt <- std_err * crit_val_qt

# norm dist
crit_val_qnorm <- qnorm(.025,lower.tail=FALSE)
margin_of_error_qnorm <- std_err * crit_val_qnorm
