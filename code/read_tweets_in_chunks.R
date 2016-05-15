
n_rows <- 100000
tweets <- read.csv("..//data//tweets.csv", header = T, sep = ',', nrows=n_rows)
col_names = names(tweets)
saveRDS(tweets, "..//data//chunck_0.rds")
tweets <- NULL # save memory

for (i in 1:9){
        print(i)
        tweets <- read.csv("..//data//tweets.csv", header = F, col.names = col_names,
                           sep = ',', nrows=n_rows, skip = n_rows*i)
        file_name = paste("..//data//chunck_" , i, ".rds", sep = "")
        saveRDS(tweets, file_name)
        tweets <- NULL # save memory
}

'''
#problem with the 10th chunck...

tweets <- read.csv("..//data//tweets.csv", header = F, 
                   sep = ',', nrows=2, skip = n_rows*9)
col_names
head(tweets)
'''
