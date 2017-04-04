###########################
# GET DATA - imports DAT files
#            end with A.24, long format df

setwd            (wd.24)                              # read from 24-hr dir   

all.fnames.24 <- dir(wd.24)                           # get filenames from wd.24
dfl.all.24    <- lapply(all.fnames.24, function(x)    # read to list of dframes 
  read.table(x, sep = ",", fill = TRUE, skip = 1))

df.all.24 <- do.call(rbind.fill, dfl.all.24)          # rbind to long format
bench.24  <- matrix(rep(24 ,nrow(df.all.24)))         # create benchtime column
df.all.24 <- data.frame(df.all.24, bench.24)          # attach bench column

colnames(df.all.24) <- c("id", 
                         "variable", 
                         "time", 
                         "benchtime")                  # assign colnames
df.cast.24 <- dcast(df.all.24,
                    time~id, 
                    value.var = "variable")            # dcast to new df

df.cast.24 [is.na(df.cast.24)] <- -6                   # replace NA with -6
df.cast.24 <- data.frame(df.cast.24[,-1],              # move time to end...
                         df.cast.24[, 1])              # makes renaming easier

names.24.simple <- str_sub(all.fnames.24, 0,
                           trim.length)                # simplify filenames
names.24.unique <- unique(names.24.simple)             # get unique names.simple
names.24.count  <- count(names.24.simple)              # freq of names.simple

colnames(df.cast.24) <- c(names.24.simple, 
                         "time")                       # rename to names.simple

A.24 <- vector("list", length(names.24.unique))         # empty list

# loop sized on names.unique
# compute rowMeans on columns with same names.simple

for (i in 1:length(names.24.unique)){
  if(i == 1){
    k = 1
    A.24[[i]] <- rowMeans(df.cast.24[k:names.24.count[[2]][i]])
    k = k + names.24.count[[2]][i]
  }
  else{
    A.24[[i]] <- rowMeans(df.cast.24[k:names.24.count[[2]][i]-1])
    k = k + names.24.count[[2]][i]
  }
}

A.24 <- data.frame(matrix(unlist(A.24),
                         ncol = length(names.24.unique)))# unlist to df

# create new time col, starts from 1 rather than 0
time.24 <- data.frame(seq(1, nrow(A.24), 1))              
pad.24  <- rep(0, length(names.24.unique) + 1)          # add zeros to first row
A.melt.24    <- data.frame(time.24, A.24)
A.melt.24    <- rbind(pad.24, A.melt.24)
colnames(A.melt.24) <- c("time", names.24.unique)

A.melt.24    <- melt(A.melt.24, id.vars = "time")

setwd            (wd)                                 # revert to wd

