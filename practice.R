library(RSQLite) 

conn <- dbConnect(SQLite(), dbname='/Users/alison/Desktop/survey.sqlite')

tables <- dbListTables(conn)
tables

class(tables)

surveys <- dbGetQuery(conn, 'SELECT * FROM surveys')

surveys <- dbGetQuery(conn, 
                      'SELECT * FROM surveys 
                      JOIN species ON surveys.species_id = 
                      species.species_id 
                      JOIN plots ON surveys.plot_id = plots.plot_id;') 

surveys <- read.csv("~/ecology.csv") 
class(surveys)
dbDisconnect(conn)
remove(conn)

#ex of making a data frame!
df <- data.frame( 
  x1 = c(TRUE, FALSE, TRUE), 
  x2 = c(1, 'red', 2)) 

typeof(df$x1) 
typeof(df$x2) 

#ex of making a list 
list(99, TRUE, 'balloons')
#a list is how you can store different data types together 


#the first with the dollar sign calls a vector; the second with brackets and parentheses  
#gives us an integer vector
head(surveys$year) 
class(surveys['year']) 

#factors 
surveys$sex
levels(surveys$sex) 
nlevels(surveys$sex)
#they don't have an order! 

#e.g. 
spice <- factor(c('low', 'medium', 'low', 'high')) 
#unless
spice.2 <- factor(c('low', 'medium', 'low', 'high'), 
                  levels = c('low', 'medium', 'high'), 
                  ordered = TRUE)  

levels(spice.2)
max(spice.2)

tabulation <- table(surveys$taxa)
barplot(tabulation)


surveys$taxa <- factor(surveys$taxa, levels = c('Rodent', 'Bird', 'Rabbit', 'Reptile'))   

tabulation <- table(surveys$taxa)
barplot(tabulation)

#or 
barplot(table(surveys$taxa))

#cross tabulation! 
#or, given the levels in one column, how frequently do levels of another column co-vary with that 
table(surveys$year, surveys$taxa)

surveys$taxa == 'Rodent'
length(surveys$taxa == 'Rodent')
dim(surveys)

t <- surveys[surveys$year >= 1980 & surveys$year <=1990 ,] 
max(t$year) 

#dplyr
library(dplyr) 

output <- select(surveys, year, taxa, weight)
head(output)

filter(surveys, taxa == 'Rodent')

#pipes in dplyr 
surveys %>%  
  filter(taxa == 'Rodent') %>%  
  select(year, taxa, weight) 

#Subset surveys to only Rodent surveys between 1980 and 1990 

rodent_surveys <- surveys %>% 
  filter(taxa == 'Rodent') %>% 
  filter(year >= 1980 & year <= 1990)   

rodent_surveys2 <- surveys %>% 
  filter(taxa == 'Rodent') %>% 
  filter(year >= 1980, year <= 1990)  

#using all.equal 

all.equal(rodent_surveys, rodent_surveys2)

#mutate 

surveys %>%  
  mutate(weight_kg = weight / 1000) %>% 
  head()

#split, apply, combine workflow 
#we split apart a dataframe based on subsets, e.g., species id 

surveys %>%  
  filter(weight != 'NA') %>%
  group_by(species_id) %>% 
  summarise(median_weight = median(weight)) 
 


#ggplot2 

library(ggplot2)

ggplot(data = surveys, 
       aes(x = weight, y = hindfoot_length, colour = species_id)) + 
  geom_point()
