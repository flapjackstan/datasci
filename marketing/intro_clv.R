library(tidyverse)
library(glue)
library(FinancialMath)

#### funcs because classes are terrible in r ####

getRetentionRate <- function(churn) {
  # returns retention rate given a churn percentage
  ret <- 1 - churn
  return(ret)
}

getCashPerCustomer <- function(total_cash, count_customers) {
  # returns an average numbers spent by cohort of customers
  cash_per_customer <- total_cash / count_customers
  return(cash_per_customer)
}

getProfitPerCustomer <- function(cash_per_customer, profit_margin) {
  # returns an average profit provided by cohort of customers
  profit_per_customer <- cash_per_customer * profit_margin
  return(profit_per_customer)
}

getCLV <- function(profit_per_customer, discount_rate, retention_rate) {
  # returns Customer Lifetime Value for cohort of customers
  clv <- profit_per_customer / (1 + (discount_rate - retention_rate))
  return(clv)
}

createScenerio <- function(revenue, customers, lost, new, churn_rate, profit_margin, discount_rate) {
  # returns a dictionary with necessary variables to calculate different values for the analysis
  data <- {}
  
  data['revenue'] <- revenue
  data['customers'] <- customers
  data['lost'] <- lost
  data['new'] <- new
  
  # provided calculations 
  
  data['churn_rate'] <- churn_rate # No clue how they came up with this.
  data['profit_marigin'] <- profit_margin
  data['discount_rate'] <- discount_rate
  
  # calculated variables
  data['retention_rate'] <- getRetentionRate(data['churn_rate'])
  data['cash_per_customer'] <- getCashPerCustomer(data['revenue'], data['customers'])
  data['profit_per_customer'] <- getProfitPerCustomer(data['cash_per_customer'], data['profit_marigin'])
  data['clv'] <- getCLV(data['profit_per_customer'], data['discount_rate'], data['retention_rate'])
  
  return(data)
}

createProfitScenerio <- function(existing_clv, new_clv, discount_rate, current_customers, new_customers_per_year) {
  # returns a dictionary with necessary variables to calculate different values for the analysis
  data <- {}
  
  data['value_of_current_base'] <- existing_clv * current_customers
  
  df <- tibble(time = c(1:10), 
                      cashflow =rep(new_clv * new_customers_per_year, 10), 
                      discount_rate = rep(discount_rate, 10))
  
  df <- df %>% mutate(present_value = cashflow / (1+discount_rate)^time)
  
  data["cashflows"] <- list(df)
  
  data["npv_of_future_customers"] <- df %>% 
    select(present_value) %>% 
    sum()
  
  data["total_value_of_customers"] <- as.numeric(data["npv_of_future_customers"]) + as.numeric(data["value_of_current_base"])

  
  return(data)
}

createCountryScenerio <- function(revenue, customers, lost, new, churn_rate, profit_margin, discount_rate, country){
  current <- createScenerio(revenue, customers,lost, new, churn_rate, profit_margin, discount_rate)
  
  # increase in churn by .02
  scenerio_1 <- createScenerio(revenue, customers,lost, new, churn_rate + .02, profit_margin, discount_rate)
  
  # decrease in churn by .02
  scenerio_2 <- createScenerio(revenue, customers, lost, new, churn_rate - .02, profit_margin, discount_rate)
  
  # profit scenario current
  current_scenario <- createProfitScenerio(current["clv"], current["clv"], discount_rate, current['customers'], new)
  
  # profit scenario 1
  profit_scenario_1 <- createProfitScenerio(scenerio_1["clv"], current["clv"], discount_rate, current['customers'], new)
  
  # profit scenario 2
  profit_scenario_2 <- createProfitScenerio(scenerio_1["clv"], current["clv"], discount_rate, current['customers'], new + 100000)
  
  # profit scenario 3
  profit_scenario_3 <- createProfitScenerio(scenerio_1["clv"], scenerio_2["clv"], discount_rate, current['customers'], new + 100000)
  
  colname = glue(country, "_percent_relative_change")
  df <- tibble("{country}" := c(as.numeric(current_scenario["total_value_of_customers"]), as.numeric(profit_scenario_1["total_value_of_customers"]), as.numeric(profit_scenario_2["total_value_of_customers"]), as.numeric(profit_scenario_3["total_value_of_customers"])))
  # all_scenarios <- all_scenarios %>% mutate("{colname}" := germany/as.numeric(current_scenario["total_value_of_customers"]) -1)
  return(df)
}


germany <- createCountryScenerio(revenue = 6296000000, customers=6558000,
                                 lost=771000, new=574000, churn_rate=.114,
                                 profit_margin=.3, discount_rate=.1, "germany")

curr <- germany$germany[1]
germany <- germany %>% mutate("germany_relative_change" = (germany/curr-1)*100)
germany


france <- createCountryScenerio(revenue = 11050000000, customers=8839000,
                                 lost=922000, new=2047000, churn_rate=.119,
                                 profit_margin=.3, discount_rate=.1, "france")
curr <- france$france[1]
france <- france %>% mutate("france_relative_change" = (france/curr-1)*100)
france


spain <- createCountryScenerio(revenue = 5942000000, customers=8909000,
                                 lost=642000, new=1573000, churn_rate=.081,
                                 profit_margin=.3, discount_rate=.1, "spain")
curr <- spain$spain[1]
spain <- spain %>% mutate("spain_relative_change" = (spain/curr-1)*100)
spain

italy <- createCountryScenerio(revenue = 11280000000, customers=12362000,
                                 lost=1186000, new=1790000, churn_rate=.101,
                                 profit_margin=.3, discount_rate=.1, "italy")
curr <- italy$italy[1]
italy <- italy %>% mutate("italy_relative_change" = (italy/curr -1)*100)
italy

all_countries <- tibble(scenarios=c("current", "profit scenario 1", "profit scenario 2", "profit scenario 3"),germany,france,italy,spain)

all_countries_percentages <- all_countries %>% select("scenarios","germany_relative_change","france_relative_change","italy_relative_change","spain_relative_change")
all_countries_percentages

# references
# https://www.codingprof.com/how-to-calculate-the-net-present-value-npv-in-r-examples/
# https://bookdown.org/jeffreytmonroe/business_analytics_with_r7/finance.html
