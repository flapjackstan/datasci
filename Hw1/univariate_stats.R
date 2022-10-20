# GSBA 524 HW 1

# This hw goes over some intro stats calculations and interpretations for univariate data

library(tidyverse)
library(ggplot2)
library(sqldf)
library(pivottabler)
library(e1071) #skewness and kurtosis

# read and quick print of 5 observations
real_estate_df <- read_csv('../data/LA Real Estate.csv')
summary(real_estate_df)
sqldf('select * from real_estate_df limit 5')

# a summary stats
summary(real_estate_df)
sqldf('select avg("LIST PRICE") from real_estate_df')

sqldf('select median("LIST PRICE") from real_estate_df')

sqldf('select stdev("LIST PRICE") from real_estate_df')

sqldf('select max("LIST PRICE") - min("LIST PRICE") as "range" from real_estate_df')

sqldf('with transform_cte as 
        (select "LIST PRICE", NTILE(4) over(order by "LIST PRICE") as "QUARTILE" from real_estate_df)
       
      select max(value) - min(value) as "IQR"
      from 
      (select a."value" from (select max("LIST PRICE") as "value", "QUARTILE" from transform_cte where "QUARTILE" = 1) as a
      union
      select b."value" from (select max("LIST PRICE") as "value", "QUARTILE" from transform_cte where "QUARTILE" = 3) as b)')

sqldf('select max(Q) - min(Q) as "IQR"
      from 
      (select median("LIST PRICE") as "Q" from real_estate_df where "LIST PRICE" < (select median("LIST PRICE") from real_estate_df)
      union
      select median("LIST PRICE") as "Q" from real_estate_df where "LIST PRICE" > (select median("LIST PRICE") from real_estate_df))')

summary(real_estate_df)
IQR(real_estate_df$`LIST PRICE`)


# b
sqldf('with transform_cte as
        (select 
          "LIST PRICE",
          CASE
            WHEN "LIST PRICE" > 20000000 THEN 1
            ELSE 0
          END AS "HIGH"
        from real_estate_df)
      
      select min("VALUE" * 1.0) / max("VALUE") as "PERCENTAGE HIGH" from  
      (select "TOTAL HIGH" as "KEY", count(1) as "VALUE" from transform_cte where "HIGH" = 1
      union
      select "TOTAL" as "KEY", count(1) as "VALUE" from transform_cte)')
# c


# d

p<-ggplot(real_estate_df, aes(x=`LIST PRICE`)) + 
  geom_histogram(color="black", fill="white")
p

p+ geom_vline(aes(xintercept=mean(`LIST PRICE`)),
              color="blue", linetype="dashed", size=1)
# Histogram with density plot
ggplot(real_estate_df, aes(x=`LIST PRICE`)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666")

kurtosis(real_estate_df$`LIST PRICE`, type=2)
skewness(real_estate_df$`LIST PRICE`, type=2)


# e

# f

sqldf('with transform_cte as
        (select 
          "LIST PRICE",
          CASE
            WHEN "HOME TYPE" = "Single Family Residential" THEN 1
            ELSE 0
          END AS "SFF"
        from real_estate_df)
      
      select min("VALUE" * 1.0) / max("VALUE") as "PERCENTAGE SFF" from  
      (select "TOTAL SFF" as "KEY", count(1) as "VALUE" from transform_cte where "SFF" = 1
      union
      select "TOTAL" as "KEY", count(1) as "VALUE" from transform_cte)')

sqldf('select "HOME TYPE", count("HOME TYPE") as count from real_estate_df group by "HOME TYPE"')

sqldf('with transform_cte as
        (select 
          "HOME TYPE", 
          count(1) as count,
          sum(count(1)) Over() as "total",
          count(1) * 1.0 / sum(count(1)) Over() as "percentage"
        from real_estate_df 
        group by "HOME TYPE")
      
      select * from transform_cte')

# g


sqldf('with transform_cte as
        (select 
          "LOCATION", 
          count(1) as count,
          sum(count(1)) Over() as "total",
          count(1) * 1.0 / sum(count(1)) Over() as "percentage"
        from real_estate_df 
        group by "LOCATION")
      
      select * from transform_cte')


# h 
qhpvt(real_estate_df, c("HOME TYPE"), c("LOCATION"), "n()/count(real_estate_df)[[1]]", formats=list("%.2f"))
qhpvt(real_estate_df, c("HOME TYPE"), c("LOCATION"), "n()")

# i

bh_df <- real_estate_df %>% filter(`LOCATION` == "Beverly Hills")
dtla_df <- real_estate_df %>% filter(`LOCATION` == "Downtown Los Angeles")
sm_df <- real_estate_df %>% filter(`LOCATION` == "Santa Monica")

radiant::radiant()


# j

# k

# l

# m

# n

# o