# Install packages if not already
install.packages(c("tidyverse", "janitor"))

# Load libraries
library(tidyverse)
library(janitor)

# load data (adjust filename)
gym <- read_csv("megaGymDataset.csv")

# quick peek
glimpse(gym)
summary(gym)
head(gym) # This shows the first 6 rows.

# PIPE: It means: take the result on the left, and pass it as the first argument to the function on the right.
gym <- gym %>%
  select(-...1) %>% # drop index column
  clean_names()     # make names lowercase and snake_case

glimpse(gym)

# Which body parts have the most exercises?
gym %>% count(body_part, sort = TRUE)

# Base R equivalent (without pipe, without dplyr)
sort(table(gym$body_part), decreasing = TRUE)

# Distribution of difficulty levels (Beginner / Intermediate / Expert)
gym %>% count(level) %>%
  ggplot(aes(x = level, y = n, fill = level)) +
  geom_col() +
  theme_minimal()

# Average rating by body part.
gym %>%
  group_by(body_part) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE)) %>%
  arrange(desc(avg_rating))

# Compare difficulty levels and ratings.
gym %>%
  group_by(level) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE),
            count = n())