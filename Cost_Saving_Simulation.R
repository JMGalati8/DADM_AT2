library(mc2d)
library(tidyverse)

#decrease in times are the first row, bed costs are the second row
min <- c(0, 184)
mode <- c(0.125, 216)
max <- c(0.17, 237)

df = data.frame(min, mode, max)

#1000 runs, with 33,697 patients modeled in each run
n = 1000
stay_length = 2.3
patients <- 33697

#Set up the vectors to input values into shortly
total_cost_saving <- vector("list", n)
total_time_saving <- vector("list", n)

#Work out the time saved for each patient (percentage)
#Work out the time saved for each patient in units
#Calculate the bed value for each of the patients in dollars
#Calculate the savings for each patients
#Sum
for (i in 1:n) {
  ts_per <- rtriang(patients, min=df[[1, 'min']], mode=df[[1, 'mode']], max=df[[1, 'max']])
  ts_unit <- stay_length * ts_per
  bed_value <- rtriang(patients, min=df[[2, 'min']], mode=df[[2, 'mode']], max=df[[2, 'max']])
  cost_saving <- ts_unit * bed_value
  total_cost_saving[[i]] <- sum(cost_saving)
  total_time_saving[[i]] <- sum(ts_unit)
}

print(total_cost_saving)

df_time_saving <- data.frame(unlist(matrix(total_time_saving, byrow=TRUE)))
colnames(df_time_saving) <- ("Time_Saved")

df_cost_saving <- data.frame(unlist(matrix(total_cost_saving, byrow=TRUE)))
colnames(df_cost_saving) <- ("Cost_Saved")

#Graph of the time saved
ggplot(df_time_saving, aes(Time_Saved)) + 
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "Bed days saved", y = "Count of occurrences", title = "Yearly bed day savings") +
  theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))

#Graph of the cost savings
ggplot(df_cost_saving, aes(Cost_Saved)) + 
  geom_histogram(fill = "lightblue", color = "black") +
  labs(x = "Cost savings ($)", y = "Count of occurrences", title = "Yearly cost savings") +
  theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))

#Time saved percentiles 
quantile(ecdf(df_time_saving$Time_Saved),c(0, 0.25,0.5,0.75, 1),type=7)

#Cost saved percentiles
quantile(ecdf(df_cost_saving$Cost_Saved),c(0, 0.25,0.5,0.75, 1),type=7)
