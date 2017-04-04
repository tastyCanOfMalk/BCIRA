####################
# LOAD PACKAGES

# if (require("packrat") == FALSE) install.packages("packrat")
# require("packrat")

if (require("stringr")   == FALSE) install.packages("stringr")   # string manipulation
if (require("reshape2")  == FALSE) install.packages("reshape2")  # melting casting
if (require("ggplot2")   == FALSE) install.packages("ggplot2")   # graphs
if (require("plyr")      == FALSE) install.packages("plyr")      # rbind fill
if (require("ggthemes")  == FALSE) install.packages("ggthemes")  # gdocs theme
if (require("gridExtra") == FALSE) install.packages("gridExtra") # 
if (require("grid")      == FALSE) install.packages("grid")      # textgrobs
if (require("gtable")    == FALSE) install.packages("gtable")    # gtable

require("stringr")   # string manipulation
require("reshape2")  # melting casting
require("ggplot2")   # graphs
require("plyr")      # rbind fill
require("ggthemes")  # gdocs theme
require("gridExtra") # 
require("grid")      # textgrobs
require("gtable")    # gtable

####################
# GRAPH VARIABLES

gg.vars <- list(
  "red",      #2  hline color
  21,         #3  shape max deflection
  10,         #4  shape cross baseline
  8,          #5  shape break
  4,          #6  key points size
  1,          #7 stat_smooth size
  .5          #8 stat_smooth alpha
)

####################
# DEFINE FUNCTIONS

getCross <- function(x,y){
  # Computes minimum absolute value from zero
  #  i.e., closest point to the baseline
  #
  # Arguments:
  #  x: data frame to look in
  #  y: column within dataframe to use
  #
  # Returns:
  #  (x,y) coordinate corresponding to time and deflection at baseline crossing
  #  else a mean of the closest values
  xx <- which(abs(x[y] - 0) == min(abs(x[y] - 0)))
  yy <- x[xx, y]
  if(length(xx) > 1){
    A <- list(mean(xx), mean(yy))
    return(A)
  }
  else{
    A  <- list(xx, yy)
    return(A)  
  }
}
# getCross(A.24, 1)

getBreak <- function(x,y){
  # Subsets data after crossing baseline to end
  #  finds largest change in slope, should correspond to break time
  #
  # Arguments:
  #  x: data frame to look in
  #  y: column within dataframe to use
  #
  # Returns:
  #  (x,y) coordinate corresponding to break time
  #  may need modification later if returns multiple values (see getCross())
  t0 <- as.numeric(getCross(x, y)[[1]])
  t1 <- x[t0:nrow(x), y]            # select rows only after crossing baseline
  t2 <- which.max(abs(diff(t1,1)))  # find time at max(abs(diff)))
  t2 = t2 + t0 - 1                  # readjust break time, -1 to get before break
  t3 <- x[t2, y]                    # get corresponding y-value
  A  <- list(t2, t3) 
  return(A)
}
# getBreak(A.24,1)
