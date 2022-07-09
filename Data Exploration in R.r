# R DATA FRAME BASICS TO INTERMEDIATE

library(ggplot2)  # To load ggplot2 package
data(diamonds)    # To load diamonds data
view(diamonds)    # To add data frame to viewer
head(diamonds,10) # To view first 10 rows
tail(diamonds, 5) # To view last 5 rows
str(diamonds)     # To view the structure of the data
colnames(diamonds)# To view column names
rownames(diamonds)# To view row names -- not so useful in this context
mutate(diamonds, carart_2=2*carat) # To add more var in the data frame

# Better when dealing with large data sets
as_tibble(diamonds)

# To create a data frame you need to create two vectors and combine

names <- c("Peter", "Jennifer", "Julie", "Alex")
age <- c(15, 19, 21, 25)
people <- data.frame(names, age)
head(people)
str(people)
glimpse(people)
mutate(people, age_in_20_years = age + 20)

# To display a list of pre-loaded data sets in R
data()

# To display a list of sample data sets in readr package
# readr functions are used to turn flat files into data frame
readr_example()

# Our file path in this case for csv file
readr_example("chickens.csv")

# To assign and view chickens data
chickens <- (read_csv(readr_example("chickens.csv")))
view(chicken)

library(readxl)

# To assign and view type_me data
type_me <- read_excel(readxl_example("type-me.xlsx"), sheet = "numeric_coercion")
view(type_me)


# DATA CLEANSING BASICS IN R

# Install and load "here", "janitor" and "skimr" packages. They simplify data
# cleaning tasks

install.packages("here") # This makes referencing files easier
library("here")

install.packages("skimr") # This makes summarizing data easier
library("skimr")

install.packages("janitor") # This has data cleansing functions
library("janitor")


# ORGANIZING DATA IN R

# Install and load "palmerpenguins" package.

# A. ARRANGE

install.packages("palmerpenguins")
library("palmerpenguins")

view(penguins)
head(penguins)

penguins %>%  arrange(bill_length_mm) # To sort the penguins data by the
# bill_length_nm col in ascending order

penguins %>%  arrange(-bill_length_mm) # To sort the penguins data by the
# bill_length_nm col in descending order

penguins_2 <- penguins %>%  arrange(-bill_length_mm)  # To save it to a data frame
# Not just to view on the console
view(penguins_2)

# A. GROUP_BY & FILTER ( group_by & summarize, piping, filter)

penguins %>%
  group_by(island) %>%
      summarize(mean_bl = mean(bill_length_mm))
# grouping by island and summarizing by mean of bill_length_mm

penguins %>%
  group_by(island) %>%
          drop_na() %>%
            summarize(mean_bl = mean(bill_length_mm))
# grouping by island and summarizing by mean of bill_length_mm and dropping NA

penguins %>%
  group_by(island) %>%
          drop_na() %>%
            summarize(max_bl= max(bill_length_mm))
# grouping by island and summarizing by max of bill_length_mm and dropping NA

penguins %>%
  filter (sex == "male") %>%
         group_by(island) %>%
                 drop_na() %>%
            summarize(mean_bl = mean(bill_length_mm))
# grouping by island, filter for male and summarizing by mean of bill_length_mm and dropping NA


penguins %>% filter (sex == "male") %>%
            group_by(species, island) %>%
                            drop_na()  %>%
                                summarize(mean_bl = mean(bill_length_mm),
                                          max_bl  = max(bill_length_mm))
# grouping by species & island, filter for male and summarizing by mean & max of bill_length_mm and
# dropping NA

# 1. BASICS DATA CLEANSING TASKS (READ_CSV() SELECT() RENAME() UNITE() MUTATE() SUMMARIZE())

# Packages needed already installed and loaded (tidyverse, skimr and janitor)
# Use read_csv from the tidyverse to import csv from external file into a data frame

bookings_df <- read_csv("Google Data Analytics Tasks/hotel_bookings.csv")

view(bookings_df) # To load the data in R

head(bookings_df) # To view first few rows of data

str(bookings_df)  # To view metadata

glimpse(bookings_df)  # To view metadata

skim_without_charts(bookings_df) # very useful data structure and metadata function

trimmed_bookings_df <- bookings_df %>%
  select( hotel, is_canceled, lead_time)  # To limit the scope of analysis - filter

trimmed_bookings_df

trimmed_rename_bookings_df <- trimmed_bookings_df %>%
  select(hotel, is_canceled, lead_time) %>%    # To rename columns
  rename(hotel_type = hotel)

trimmed_rename_bookings_df

unite_bookings_df<- bookings_df %>%        # Use unite to concatenate month & year
  select(arrival_date_year, arrival_date_month) %>%
  unite(arrival_month_year, c("arrival_date_month", "arrival_date_year"), sep = " ")

unite_bookings_df

mutate_df <- bookings_df %>%   # Use mutate to alter your data. create calculated cols
  mutate(guests = adults + children + babies)

view(mutate_df)

num_cancelled_avg_lead_time_df <- bookings_df %>%
            summarize(num_cancelled= sum(is_canceled),
                      avg_lead_time= mean(lead_time))
head(num_cancelled_avg_lead_time_df)

# 2. BASICS DATA CLEANSING TASKS ( SEPARATE() UNITE() MUTATE())


id <- c(1:10)

name <- c("John Mendes", "Rob Stewart", "Rachel Abrahamson", "Christy Hickman", "Johnson Harper", "Candace Miller", "Carlson Landy", "Pansy Jordan", "Darius Berry", "Claudia Garcia")

job_title <- c("Professional", "Programmer", "Management", "Clerical", "Developer", "Programmer", "Management", "Clerical", "Developer", "Programmer")

employee_1 <- data.frame(id, name, job_title)   # Combine and create data frame

view(employee_1)

employee_2 <- separate(employee, name,          # Use separate to split columns
         into=c("first_name", "last_name"), sep=" ")
view(employee_2)

unite(employee_2, name,                         # Use unite to concatenate columns
              first_name, last_name, sep=" ")

pengiuns_mutate <- penguins %>% mutate(body_mass_kg=body_mass_g/1000,
                                       flipper_length_m = flipper_length_mm/1000)

view(pengiuns_mutate)                           # Use mutate to add new columns

# 2. BASICS DATA CLEANSING TASKS (PIVOT_LONGER() PIVOT_WIDER()) for Unpivoting & Pivoting


# 3. BIAS FUNCTION IN R - (sim(), sample())

install.packages("SimDesign")   # Installing & Loading the SimDesign package to use the BIAS function
library(SimDesign)

actual_temp <- c(68.3, 70, 72.4, 71, 67, 70)
predicted_emp <- c(67.9, 69, 71.5,  70, 67, 69)
bias(actual_temp, predicted_emp)  # An unbiased model should be close to zero(0)



# Data cleaning automation with SQL Scrips and R Scripts are great leap over
# spreadsheets with opportunity for quick debugging and audit
