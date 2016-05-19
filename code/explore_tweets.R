
# loading chuncks 0 to a data frame:
tweets <- readRDS(file = "..//data//chunck_0.rds")

# if we want to load more than one...
for (i in 0:8){
        #print(i)
        file_name = paste("..//data//chunck_" , i, ".rds", sep = "")
        temp <- readRDS(file = file_name)
        tweets <- rbind(tweets , temp)
        temp <- NULL 
}        

dim(tweets)
summary(tweets)
names(tweets)
str(tweets) #?
head(tweets)

# number of users in this data set:
length(unique(tweets$user_id))
# type is = status. with is good
unique(tweets$type)
table(tweets$type)

# tweet_id is numeric:
summary(tweets$tweet_id)

# re-tweet count is also numeric
summary(tweets$ret_count)

# favorite has only one value (in the frst chunck) = false
summary(tweets$favorite)

# looking at the top 10 Hashtags:
sort(table(tweets$hashtags),decreasing = TRUE)[1:10]
# GoodMorning is more popular than iPad :)

# need to convert column 'time' to date-time format:

library(lubridate)
parse_date_time((tweets$time)[1], orders = "a% b% d!% H!%:M!%:S!% y!")

