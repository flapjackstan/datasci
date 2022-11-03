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


#### global ####

case_rev <- 6296000000
case_cust <- 6558000
case_lost <- 771000
case_new <- 574000
case_churn <- .114
case_pm <- .3
case_dr <- .1

case_new_customers_per_year <- 600000

#### scenarios ####
current <- createScenerio(revenue = case_rev, customers=case_cust,
                          lost=case_lost, new=case_new, churn_rate=case_churn,
                          profit_margin=case_pm, discount_rate=case_dr)

# increase in churn by .02
scenerio_1 <- createScenerio(revenue = case_rev, customers=case_cust,
                             lost=case_lost, new=case_new, churn_rate=case_churn + .02,
                             profit_margin=case_pm, discount_rate=case_dr)
scenerio_1

# decrease in churn by .02
scenerio_2 <- createScenerio(revenue = case_rev, customers=case_cust,
                             lost=case_lost, new=case_new, churn_rate=case_churn - .02,
                             profit_margin=case_pm, discount_rate=case_dr)
scenerio_2

#### profit scenarios ####

# note: numbers in excel were heavily rounded

# profit scenario current
# profit_scene_1 <- createProfitScenerio(1345, 1345, case_dr, 6558, 600)
current_scenario <- createProfitScenerio(current["clv"], current["clv"], case_dr, current['customers'], case_new_customers_per_year)

# profit scenario 1
# profit_scenario_1 <- createProfitScenerio(scenerio_1["clv"], current["clv"], case_dr, current['customers'], case_new_customers_per_year)
profit_scenario_1 <- createProfitScenerio(1345, 1345, case_dr, 6558, 600)
profit_scenario_1

# profit scenario 2
# profit_scenario_2 <- createProfitScenerio(scenerio_1["clv"], current["clv"], case_dr, current['customers'], case_new_customers_per_year + 100000)
profit_scenario_2 <- createProfitScenerio(1230, 1345, case_dr, 6558, 700)
profit_scenario_2


# profit scenario 3
# profit_scenario_3 <- createProfitScenerio(scenerio_2["clv"], current["clv"], case_dr, current['customers'], case_new_customers_per_year + 100000)
profit_scenario_3 <- createProfitScenerio(1230, 1484, case_dr, 6558, 700)
profit_scenario_3


# references
# https://www.codingprof.com/how-to-calculate-the-net-present-value-npv-in-r-examples/
# https://bookdown.org/jeffreytmonroe/business_analytics_with_r7/finance.html
