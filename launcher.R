# v1.1
# 2017-03-31

# repurpose original program to pull data from single folder
# upgrade later to pull from multiple folders, e.g. different benchtimes


#########################
# ASSIGN NAMES

sub.fold    <- "2017-04-04"          # folder with DAT files
trim.length <- 1                     # characters to keep, for homogenizing
  
run.3  <- F
run.24 <- T

# working directory, for scripts
wd          <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA") 
# save directory
save.dir    <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA//output") 
# working directory, 3-hr for files
wd.3        <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA//DAT files",
                      "/", "/", sub.fold, "/", "/", "3")
# working directory, 24-hr for files
wd.24       <- paste0("C://Users//yue.GLOBAL//Documents//R//BCIRA//DAT files",
                      "/", "/", sub.fold, "/", "/", "24")

###########################
# GET DATA

setwd            (wd)                                 # set wd
source("get_functions.R")

if(run.3 == TRUE){
  source("get_data3.R")
  source("get_calcs3.R")
  source("get_graphs3.R")
  
  grid.newpage()
  grid.draw(gg.all.3)
  
  setwd(save.dir)                                     
  ggsave(paste0(sub.fold,"-3hr",".png"),   # save 'facet' graph
         gg.all.3,
         width  = 13,
         height = 10,
         dpi    = 300)
  setwd(wd)
  }

if(run.24 == TRUE){
  source("get_data24.R")
  source("get_calcs24.R")
  source("get_graphs24.R")
  
  grid.newpage()
  grid.draw(gg.all.24)
  
  setwd(save.dir)
  ggsave(paste0(sub.fold,"-24hr",".png"),   # save 'facet' graph
         gg.all.24,
         width  = 13,
         height = 10,
         dpi    = 300)
  setwd(wd)
}


