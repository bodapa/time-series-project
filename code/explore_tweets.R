
# loading chuncks 0 to a data frame:
library(dplyr)
library(lubridate)
library(tidyr)

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


# converting 'time' column to date-time format:

# changing my local time format to English...
# sessionInfo()
#Sys.setlocale("LC_TIME", "C")

# converting 'time' to string and removing beginning and trailing whitespaces:
tweets$time_string <- trimws(as.character(tweets$time))

string.date.format <- function(date_string){
        #converting a string to a format easily for converting to date-time object
        
        
        date_items = unlist(strsplit( date_string, split = " "))
        # creating string in format %d% b% Y% H:%M:%S
        # for example -  "29 Jul 2011 09:05:05"
        date_time_string = paste(date_items[3], date_items[2], date_items[6],date_items[4], sep=" ")
        return(date_time_string)
}

tweets$time_string <- apply(tweets["time_string"],1, string.date.format)

 
# checking what time zones are in our data:
time.zones = lapply(tweets$time_string, function(x) unlist(strsplit( x, split = " "))[5])
unique(time.zones)
time.zones <- NULL

# converting string to new date object in dataframe: 
tweets$time_string[1:10]
tweets$date.time <- dmy_hms(tweets$time_string)


# Note: For now, I haven't used the time zone information when converting to date object.
# this can be problematic, as I'm implicitly assuming all dates are in the same time zone - our current. 
# An example why this is problematic: lets say somebody tweeted at 4PM in LA - which is 6PM in our local time. 
# If we ignore the TZ, we will create the date as 4PM. This can lead to us mistakenly identifying this tweet 
# as influencing other tweets, when in fact it was the other way around - like tweets between 4-6 PM of users in
# our timezone...

# hope it make sense. We can easily create a column of the TZ from the string, and use it as an argument in 
# the dmy_hms function. However, I have a feeling that the way TZ are captured in are strings are not the expected
# input for lubridate. so we might need to convert some of them.
 

# looking at the dates we have:

head(tweets[c("time","time_string","date.time")])
tail(tweets[c("time","time_string","date.time")])

summary(tweets$date.time)

# Range of years is mostly 2010-2011, at least in this chunck
summary(year(tweets$date.time))
# range of time (hour) of tweets is all day:
summary(hour(tweets$date.time))

# number of tweets in each month-year:
tweets$year <- year(tweets$date.time)
tweets$month <- month(tweets$date.time)

month_year <- tweets %>%
        group_by(year, month) %>%
        summarise(number.tweets  = n())


month_year_wide = spread(month_year, month,  number.tweets)
month_year_wide[is.na(month_year_wide)] <- 0
month_year_wide

string.to.date <- function(date_string){
        date_items = unlist(strsplit( date_string, split = " "))
        # creating string in format %d% b% Y% H:%M:%S
        # for example -  "29 Jul 2011 09:05:05"
        date_time_string = paste(date_items[3], date_items[2], date_items[6],date_items[4], sep=" ")
        # for now, avoiding specifing Time Zone...
        # converting to time object
        #date_time_object =strptime(date_time_string, "%d %b %Y %T")
        date_time_object = dmy_hms(date_time_string)
        return(date_time_object[[1]])
}

tweets["date.time"] <- lapply( tweets$time_string, string.to.date)



a = lapply( tweets$time_string[1:205], string.to.date)

str(tweets["date.time"])





