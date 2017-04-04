###########################
# GET DATA - imports DAT files
#            end with A.3, long format df

setwd           (wd.3)                                # read from 3-hr dir     

all.fnames.3 <- dir(wd.3)                             # get filenames from wd.3
dfl.all.3    <- lapply(all.fnames.3, function(x)      # read to list of dframes 
  read.table(x, sep = ",", fill = TRUE, skip = 1))

df.all.3  <- do.call(rbind.fill, dfl.all.3)           # rbind to long format
bench.3   <- matrix(rep(3 ,nrow(df.all.3)))           # create benchtime column
df.all.3  <- data.frame(df.all.3, bench.3)            # attach bench column

colnames(df.all.3) <- c("id", 
                        "variable", 
                        "time", 
                        "benchtime")                  # assign colnames
df.cast.3 <- dcast(df.all.3, 
                   time~id, 
                   value.var = "variable")            # dcast to new df

df.cast.3 [is.na(df.cast.3)] <- -6                    # replace NA with -6
df.cast.3 <- data.frame(df.cast.3[,-1],               # move time to end...
                        df.cast.3[, 1])               # makes renaming easier

names.3.simple <- str_sub(all.fnames.3, 0, 
                          trim.length)                # simplify filenames
names.3.unique <- unique(names.3.simple)              # get unique names.simple
names.3.count  <- count(names.3.simple)               # freq of names.simple

colnames(df.cast.3) <- c(names.3.simple, 
                         "time")                      # rename to names.simple

A.3 <- vector("list", length(names.3.unique))         # empty list

# loop sized on names.unique
# compute rowMeans on columns with same names.simple

for (i in 1:length(names.3.unique)){
  if(i == 1){
    k = 1
    A.3[[i]] <- rowMeans(df.cast.3[k:names.3.count[[2]][i]])
    k = k + names.3.count[[2]][i]
  }
  else{
    A.3[[i]] <- rowMeans(df.cast.3[k:names.3.count[[2]][i]-1])
    k = k + names.3.count[[2]][i]
  }
}

A.3 <- data.frame(matrix(unlist(A.3),
                         ncol = length(names.3.unique)))# unlist to df

# create new time col, starts from 1 rather than 0
time.3 <- data.frame(seq(1, nrow(A.3), 1))              
pad.3  <- rep(0, length(names.3.unique) + 1)          # add zeros to first row
A.melt.3           <- data.frame(time.3, A.3)
A.melt.3           <- rbind(pad.3, A.melt.3)
colnames(A.melt.3) <- c("time", names.3.unique)

A.melt.3    <- melt(A.melt.3, id.vars = "time")

setwd            (wd)                                 # revert to wd
