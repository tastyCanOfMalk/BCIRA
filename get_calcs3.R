###########################
# GET CALCS - use time series to caluclate key points
#             time at max distortion, max distortion
#             time to cross baseline
#             time to failure

# max distortion, long format
B.30 <- t(A.3)        # transpose & remove time, 0-row to apply() to rows
B.31 <- as.numeric(apply(B.30, 1, max))       # find max values per variable
B.32 <- as.numeric(apply(B.30, 1, which.max)) # find time at max values
B.3  <- data.frame(time     = B.32, 
                   variable = names.3.unique, 
                   value    = B.31)

# baseline crossing, break point, long format
C.3 <- vector("list", 2)                           # empty lists
D.3 <- vector("list", 2)

for(i  in 1:length(names.3.unique)){
  C.3[[i]] <- getCross(A.3, i)
  D.3[[i]] <- getBreak(A.3, i)
}

C.3 <- data.frame(matrix(unlist(C.3), nrow = 2))   # unlist to dfs
D.3 <- data.frame(matrix(unlist(D.3), nrow = 2))

C.3 <- data.frame(time = t(C.3[1,]),               # convert to long format
                 variable = names.3.unique,
                 value = t(C.3[2,]))
D.3 <- data.frame(time = t(D.3[1,]),
                  variable = names.3.unique,
                  value = t(D.3[2,]))

colnames(C.3) <- c("time", "variable", "value")
colnames(D.3) <- c("time", "variable", "value")

names.3.unique
t(B.3[1])  # time to max distortion (s)
t(B.3[3])  # max distortion (mm)
C.3[,1]    # time to zero (s)
D.3[,1]    # break time (s)

data.3 <- rbind(t(B.3[1]),  # time to max distortion (s)
                t(B.3[3]),  # max distortion (mm)
                C.3[,1],    # time to zero (s)
                D.3[,1]    # break time (s)
                )
colnames(data.3) <- names.3.unique
rownames(data.3) <- c("max distortion (s)",
                      "max distortion (mm)",
                      "cross baseline (s)",
                      "break time (s)")

# round(data.3,2)
