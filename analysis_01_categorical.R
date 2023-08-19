# Load dplyr for tibble()

install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)

demo <- tibble(
  id  = c("001", "002", "003", "004"),
  age = c(30, 67, 52, 56),
  edu = c(3, 1, 4, 2)
)

print(demo)

#==============================================================================

demo <- tibble(
  id       = c("001", "002", "003", "004"),
  age      = c(30, 67, 52, 56),
  edu      = c(3, 1, 4, 2),
  edu_char = c(
    "Some college", "Less than high school", "College graduate", 
    "High school graduate"
  )
)

demo

#.---------------------------- OR: in tidyverse way-----------------------------

demo <- demo %>% mutate(
  
  edu_char = c("Some college", "Less than high school", "College graduate", 
               "High school graduate")
  
)

demo
#------------------------------------------------------------------------------


# let us create another variable called edu_f from the coercion of the edu var 

# i will use the tidyverse way:
demo <- demo %>% mutate(
  edu_f = factor(x = edu,
                 levels = 1:4,
                 labels = c("Less than high school","High school graduate",
                            "Some college", "College graduate"))
  
)

demo

# factors are numeric under the hood and we can prove that:

as.numeric(demo$edu_char) #this is not a numeric 
as.numeric(demo$edu_f)   # this is a numeric


#------------------------------------------------------------------------

# let us show the freq.count for the observations in edu_char and edu_f

table(demo$edu_char) # display the count result alphabetically
table(demo$edu_f)    # display the count result in logical order we specified.


# let us use factor() to capture obervation that is possible but not captured
# in our dataset 


demo <- demo %>% mutate(
  edu_f = factor(x = edu,
                 levels = 1:5,
                 labels = c("Less than high school","High school graduate",
                            "Some college", "College graduate",
                            "Graduate school"))
  
)

demo

# use table to view the count again

table(demo$edu_f)  # Graduate school is possible but is not observed in our 
# study dataset.

# let us simulate another dataset and let us name it height_and_weight_20

# Simulate some data
height_and_weight_20 <- tibble(
  id = c(
    "001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", 
    "012", "013", "014", "015", "016", "017", "018", "019", "020"
  ),
  sex = c(1, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2),
  sex_f = factor(sex, 1:2, c("Male", "Female")),
  ht_in = c(
    71, 69, 64, 65, 73, 69, 68, 73, 71, 66, 71, 69, 66, 68, 75, 69, 66, 65, 65, 
    65
  ),
  wt_lbs = c(
    190, 176, 130, 154, 173, 182, 140, 185, 157, 155, 213, 151, 147, 196, 212, 
    190, 194, 176, 176, 102
  )
)


# calculate frequency of male and female:

# A. using the base R table function:
table(height_and_weight_20$sex_f)


#B. Using the gmodels::Crosstable function:

install.packages("gmodels") # install packages
library(gmodels)

CrossTable(height_and_weight_20$sex_f) # using the CrossTable() from gmodels 
#  now

# C. the tidyverse method:

# 1. group_by and summarise():

height_and_weight_20 %>% group_by(sex_f) %>% summarise(n = n())

#2. using count():

height_and_weight_20 %>% count(sex_f)


# calculating the proportion or percentage of this we have---------------------

# a.
height_and_weight_20 %>% group_by(sex_f) %>% 
  summarise(n = n(),
            proportn = n / 20)  # gives the desired proportn result


# b. 
height_and_weight_20 %>% group_by(sex_f) %>% 
  summarise(n = n(),
            proportn = n / sum(n))  # does not give the desired proportn result

# c. using count() and mutate() 

height_and_weight_20 %>% count(sex_f) %>% mutate(proportn = n /sum(n))

# d. 

height_and_weight_20 %>% group_by(sex_f) %>% 
  summarise(n = n()) %>% mutate(proportn = n / sum(n)) #gives the desired result


# to create a new sex_factor with NAs from the sex column----------------------

height_and_weight_20_2 <- height_and_weight_20 %>% mutate(
  sex_f = replace(sex, c(2,9), NA)
)

height_and_weight_20_2 # now contains NA at row 2 and 3


# to calculate the percentage frequency from this:


height_and_weight_20_2 %>% count(sex_f) %>% mutate(percent = (n / sum(n)) * 100)

# since our result contain missing value,let us try removing the NAs:

# a. using drop_na()

height_and_weight_20_2 %>% drop_na() %>% count(sex_f) %>% 
  mutate(percent = (n / sum(n)) * 100)


# b. using the the filter() and !is.na(): 

height_and_weight_20_2 %>% filter(!is.na(sex_f)) %>% count(sex_f) %>% 
  mutate(percent = (n / sum(n)) * 100
  )

# round your result to 2 d.p:

height_and_weight_20_2 %>% filter(!is.na(sex_f)) %>% count(sex_f) %>% 
  mutate(percent = (n / sum(n)) * 100) %>% round(2)


# use the freq_table from the freqtables package to calculate the freq:

install.packages("freqtables") # not installing on my macbook. i don't know why