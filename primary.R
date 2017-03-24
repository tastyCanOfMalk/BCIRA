
# load DAT files
# may have 3-hr and 24-hr

require("stringr") # string manipulation
require("reshape2")
require("ggplot2")
require("plyr") #rbind fill

sub.fold    <- "2017-03-20"          # folder with DAT files

wd          <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA")
wd.3        <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA//DAT files",
                      "/", "/", sub.fold, "/", "/", "3")

# setwd(wd)   # load functions
# 
# source("get_functions.R")

setwd(wd.3)                 # switrch to 3-hr dir
all.file.names <- dir(wd.3) # list filenames in 3-hr dir

# List of data.frames, uneven rows
mx.all <- lapply(all.file.names, function(x) 
  read.table(x, sep = ",", fill = TRUE, skip = 1))

# rbind all data
mx.all.rb <- do.call(rbind.fill, mx.all)

benchtime <- matrix(rep(3 ,nrow(mx.all.rb)))  # add benchtime column

# add benchtime col, restructure for dcasting, rename
mx.all.rb <- cbind(mx.all.rb[1], 
                   benchtime,
                   mx.all.rb[3],
                   mx.all.rb[2])
colnames(mx.all.rb) <- c("id",
                         "benchtime",
                         "time",
                         "variable")

all.cast <- dcast(mx.all.rb, time~id )

all.cast[is.na(all.cast)] <- -6                 # replace NA with -6
all.cast <- cbind(all.cast[,-1], all.cast[,1])  # move time to end

names.simple <- str_sub(all.file.names,0,3) # simplify filenames
names.unique <- unique(names.simple)        # unique samples tested
names.count  <-  count(names.simple)        # frequency of samples

colnames(all.cast) <- c(names.simple, "time") # rename variables

A <- vector("list",length(names.unique)) # empty list sized to variables

# Loop from 1 to total variables
# compute rowMeans on columns with same names.simple

for(i in 1:length(names.unique)){
  if(i == 1){
    k = 1
    A[[i]] <- rowMeans(all.cast[k:names.count[[2]][i]])  
    k = k + names.count[[2]][i]
  }
  else{
    A[[i]] <- rowMeans(all.cast[k:(names.count[[2]][i]-1)])
    k = k + names.count[[2]][i]
  }}

# unlist into dataframe
AA <- data.frame(matrix(unlist(A),ncol=length(names.unique)))

colnames(AA) <- names.unique
