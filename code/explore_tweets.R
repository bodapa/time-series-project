
# loading chuncks 0-8 to one data frame:

tweets <- readRDS(file = "..//data//chunck_0.rds")
for (i in 1:8){
        print(i)
        file_name = paste("..//data//chunck_" , i, ".rds", sep = "")
        temp <- readRDS(file = file_name)
        tweets <- rbind(tweets , temp)
        temp <- NULL 
}        

dim(tweets)
summary(tweets)
# need some cleaning...
summary(tweets$ret_count)