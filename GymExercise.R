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
gym %>% count(body_part, sort = TRUE) %>% head(5)

# Base R equivalent (without pipe, without dplyr)
counts <- sort(table(gym$body_part), decreasing = TRUE)

# Draw pie chart
pie(counts, 
    main = "Exercises per Body Part",
    col = rainbow(length(counts)),   # nice colors
    clockwise = TRUE)

# Convert to a data frame for ggplot
counts_df <- gym %>%
  count(body_part, sort = TRUE)

# Pie chart using ggplot2
ggplot(counts_df, aes(x = "", y = n, fill = body_part)) +
  geom_col(width = 1) +                # stacked column
  coord_polar(theta = "y") +           # convert to pie
  theme_void() +                        # remove axes
  labs(title = "Exercises per Body Part") +
  theme(legend.position = "right")

# Distribution of difficulty levels (Beginner / Intermediate / Expert)
gym %>% count(level) %>%
  ggplot(aes(x = level, y = n, fill = level)) +
  geom_col() +
  theme_minimal()

# Average rating by body part.
# arrange -> Reorder the rows of my table based on the values in one or more columns.
gym %>%
  group_by(body_part) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE)) %>%
  arrange(desc(avg_rating))

# Compare difficulty levels and ratings.
# na.rm = TRUE -> Remove all NA values before doing the calculation
# summarise -> Take my dataset, calculate some summary values, and 
#  return a new table with those values.
gym %>%
  group_by(level) %>%
  summarise(avg_rating = mean(rating, na.rm = TRUE),
            count = n())


# Use statistics: e.g. t-tests or ANOVA to see if Expert-level exercises have 
# significantly higher ratings than Beginner ones.

# Keep only Beginner and Expert for t-test
subset_te <- gym %>%
  filter(level %in% c("Beginner", "Expert")) %>% # only Beginner and Expert exercises
  select(level, rating) %>%
  filter(!is.na(rating))  # remove missing ratings, because t-test cannot handle NA

# tests if Expert ratings are greater than Beginner ratings
t.test(rating ~ level, data = subset_te)

# boxplot of ratings by level so you can visualize Beginner vs Expert exercises
ggplot(subset_te, aes(x = level, y = rating, fill = level)) +
  geom_boxplot() +
  labs(title = "Ratings by Exercise Level",
       x = "Level",
       y = "Rating") +
  theme_minimal() +
  scale_fill_manual(values = c("lightblue", "salmon")) +
  theme(legend.position = "none")

