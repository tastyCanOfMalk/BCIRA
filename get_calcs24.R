###########################
# GET CALCS - use time series to caluclate key points
#             time at max distortion, max distortion
#             time to cross baseline
#             time to failure

# max distortion, long format
B.240 <- t(A.24)        # transpose & remove time, 0-row to apply() to rows
B.241 <- as.numeric(apply(B.240, 1, max))       # find max values per variable
B.242 <- as.numeric(apply(B.240, 1, which.max)) # find time at max values
B.24  <- data.frame(time     = B.242, 
                   variable = names.24.unique, 
                   value    = B.241)

# baseline crossing, break point, long format
C.24 <- vector("list", 2)                           # empty lists
D.24 <- vector("list", 2)

for(i  in 1:length(names.24.unique)){
  C.24[[i]] <- getCross(A.24, i)
  D.24[[i]] <- getBreak(A.24, i)
}

C.24 <- data.frame(matrix(unlist(C.24), nrow = 2))   # unlist to dfs
D.24 <- data.frame(matrix(unlist(D.24), nrow = 2))

C.24 <- data.frame(time = t(C.24[1,]),               # convert to long format
                  variable = names.24.unique,
                  value = t(C.24[2,]))
D.24 <- data.frame(time = t(D.24[1,]),
                  variable = names.24.unique,
                  value = t(D.24[2,]))

colnames(C.24) <- c("time", "variable", "value")
colnames(D.24) <- c("time", "variable", "value")

names.24.unique
t(B.24[1])  # time to max distortion (s)
t(B.24[3])  # max distortion (mm)
C.24[,1]    # time to zero (s)
D.24[,1]    # break time (s)

data.24 <- rbind(t(B.24[1]),  # time to max distortion (s)
                t(B.24[3]),   # max distortion (mm)
                C.24[,1],     # time to zero (s)
                D.24[,1]      # break time (s)
)
colnames(data.24) <- names.24.unique
rownames(data.24) <- c("max distortion (s)",
                       "max distortion (mm)",
                       "cross baseline (s)",
                       "break time (s)")

# round(data.24,2)
