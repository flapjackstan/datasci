library('tidyverse')

df <- read_csv('../data/GammaDeltaStock.csv')

# 1A EV for stocks
gamma_mu <- sum(df$return_gamma * df$probability)
delta_mu <- sum(df$return_delta * df$probability)


# 1B SD for stocks 
gamma_sd <- sqrt(sum((df$return_gamma-gamma_mu)^2*df$probability))
delta_sd <- sqrt(sum((df$return_delta-delta_mu)^2*df$probability))

# 1C 
# I would go for delta because it has a lower standard deviation meaning less risk. I am risk averse at the moment and although
# expected value is higher for gamma inc, I would rather pick a more reliable investment at this time.

# 1D
# Looks like a negative correlation because as gamma goes down, delta goes up


# 2a

z <- (4.8 - 3.1) / .9
1 - pnorm(z)

prob_over_48 <- 1- pnorm(q=4.8, mean=3.1, sd=.9)


# N = 5000
# norm_data <- rnorm(N, mean=3.1, sd=.9)
# hist(norm_data, breaks =  51, col = "orange", main = "runif")
# plot(density(norm_data,kernel="gaussian"))
# 
# norm_frame = with(density(norm_data,kernel="gaussian"),  # Create data frame density values
#                   data.frame(x,y)) 
# 
# norm_plot <- ggplot(data = norm_frame, aes(x = x, y = y)) +   # Create the plot
#   geom_line(color="NA")+
#   geom_ribbon(data=subset(norm_frame,x > -5 & x < 10),
#               aes(ymax=y, ymin=0),
#               fill="skyblue", 
#               alpha=0.4)+
#   xlim(0,6)
# 
# 
# norm_plot
# 
# 
# norm_plot_w_calc <- norm_plot + 
#   geom_ribbon(data=subset(norm_frame,x < 4.8),
#               aes(ymax=y, ymin=0),
#               fill="green", 
#               alpha=0.4)+
#   geom_ribbon(data=subset(norm_frame,x > 4.8),
#               aes(ymax=y, ymin=0),
#               fill="red", 
#               alpha=0.4)+
#   geom_text(x=5.2,y=0.1,label=round(prob_over_48,4),size=5) 
# 
# norm_plot_w_calc


# 2b

qnorm(p = .99,mean=3.1, sd=.9) # 1% chance to randomly select a obs lower than this

z <- (5.19 - 3.1) / .9
1 - pnorm(z)


# 3a
qnorm(.12, mean=21340, sd=4980)

# 4
 
df <- read_csv('../data/HW 2 DJIA data.csv')

# 4a

# General statement of SD for each var
mean(df$`Adj Close**`)
sd(df$`Adj Close**`)

# 4b

1 - pnorm(q=36799.65, mean=mean(df$`Adj Close**`), sd=sd(df$`Adj Close**`))

# 4c

z <- (2112.98 - mean(df$Change, na.rm=TRUE)) / sd(df$Change, na.rm=TRUE)

1 - pnorm(z)

# 4d

z <- (-.1293 - mean(df$Return, na.rm=TRUE)) / sd(df$Return, na.rm=TRUE)

pnorm(z)


# 4e

temp <- df %>% filter(index != 16 & index !=10)

mean(temp$`Change`, na.rm=TRUE)
sd(temp$`Change`, na.rm=TRUE)


df <- df %>% muta
