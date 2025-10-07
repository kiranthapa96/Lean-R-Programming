install.packages("sqldf")

library(sqldf)

# Example: select all Expert exercises
sqldf("SELECT * FROM gym WHERE level = 'Expert' LIMIT 5")

# Example: group and count
sqldf("SELECT body_part, COUNT(*) AS n FROM gym GROUP BY body_part ORDER BY n DESC")
