# Load necessary libraries

install.packages("forecast")
install.packages("car")
install.packages("lubridate")
library(dplyr)
library(ggplot2)
library(forecast)
library(car)
library(lubridate)


# Load the data
food_delivery_Data <- read.csv("C:/Users/Lenovo/Downloads/food_delivery_data.csv")


# Display the first few rows of the data
head(food_delivery_Data)


# Data Cleaning
# Remove duplicate rows
food_delivery_Data <- food_delivery_Data %>% distinct()

# Replace missing values with column means
food_delivery_Data <- food_delivery_Data %>%
  mutate(across(everything(), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# Convert order date to Date type
food_delivery_Data$Order_Date <- as.Date(food_delivery_Data$Order_Date, format="%d-%m-%Y")

# Convert Time_Orderd to proper time format
food_delivery_Data$Time_Orderd <- hms::as_hms(food_delivery_Data$Time_Orderd)

# Extract hour from Time_Orderd
food_delivery_Data$order_hour <- hour(food_delivery_Data$Time_Orderd)



# Histogram of Delivery Time
ggplot(food_delivery_Data, aes(x = Time_taken.min.)) +
  geom_histogram(binwidth = 5, fill = "darkgreen", color = "black") +
  labs(title = "Distribution of Delivery Time", x = "Delivery Time (min)", 
       y = "Frequency")

# Bar Plot of Delivery Person Ratings
ggplot(food_delivery_Data, aes(x = Delivery_person_Ratings)) +
  geom_bar(fill = "red", color = "black") +
  labs(title = "Delivery Person Ratings", x = "Ratings", y = "Count")


# Pie chart of orders by road traffic density
traffic_density_counts <- food_delivery_Data %>%
  count(Road_traffic_density) %>%
  mutate(percentage = n / sum(n) * 100)

ggplot(traffic_density_counts, aes(x = "", y = percentage, 
                                   fill = Road_traffic_density)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  labs(title = "Orders by Road Traffic Density", x = "", y = "") +
  theme_void()


# Bar plot of multiple deliveries
ggplot(food_delivery_Data, aes(x = factor(multiple_deliveries))) +
  geom_bar(fill = "darkgreen", color = "black") +
  labs(title = "Distribution of Multiple Deliveries", x = "Multiple Deliveries", 
       y = "Count")

# Heatmap of delivery person ratings by city
rating_by_city <- food_delivery_Data %>%
  group_by(City) %>%
  summarise(avg_rating = mean(Delivery_person_Ratings, na.rm = TRUE))

ggplot(rating_by_city, aes(x = City, y = avg_rating, fill = avg_rating)) +
  geom_tile() +
  scale_fill_gradient(low = "darkgreen", high = "lightgreen") +
  labs(title = "Average Delivery Person Ratings by City", x = "City", 
       y = "Average Rating")

# Bar plot of delivery person ratings by weather conditions
ggplot(food_delivery_Data, aes(x = Weatherconditions, y = Delivery_person_Ratings)) +
  geom_bar(stat = "identity", fill = "purple") +
  labs(title = "Delivery Person Ratings by Weather Conditions", 
       x = "Weather Conditions", y = "Average Ratings")

# Box Plot of Delivery Person Ratings by Age Group
food_delivery_Data <- food_delivery_Data %>%
  mutate(Age_Group = cut(Delivery_person_Age, breaks = c(20, 25, 30, 35, 40, 45), 
                         labels = c("20-25", "25-30", "30-35", "35-40", "40-45")))

ggplot(food_delivery_Data, aes(x = Age_Group, y = Delivery_person_Ratings)) +
  geom_boxplot(fill = "Yellow") +
  labs(title = "Delivery Ratings by Age Group", x = "Age Group",y="Ratings")


#generate report 

library(DataExplorer)

create_report(food_delivery_Data)
