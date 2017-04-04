# BCIRA
### mm deflection vs time
General Notes:
- Sample replicates need not match, however if number of replicates vary from sample to sample, this will not be displayed in the output
- Calculations are performed on means rather than each individual measurement. Therefore no standard deviation is available yet.

From launcher.R:
`sub.fold` must contain .DAT files, with subfolders .../3 and .../24
`trim.length` controls str_sub(, , x) variable, must select value that homogenizes names
`run.3` set to `TRUE` if .DAT files to be processed within, else `FALSE`
`run.24` set to `TRUE` if .DAT files to be processed within, else `FALSE`

### Process 
Running launcher.R will assign above variables and launch the scripts below. After running the scripts the `ggsave()` functions is called for each graph produced and output to `save.dir`

`get_functions.R` 
- loads required packages 
- assigns graph variables
- loads functions for computing key coordinates

`get_data`
 - imports data
 - transforms to long format

`get_calcs`
 - functions applied to data producing key points
 - coordinates of key points produced in dataframe

`get_graphs.R`
- prepare graphs focusing on different key points
- print graphs with dataframe of values
 
 
### Sample output
Grid.arranged plot below summarizing all data

`gg.BCIRAeg`

`gg.BCIRAeg2`

![gg.BCIRAeg](/output/2017-04-04-24hr.png)

![gg.BCIRAeg2](/output/2017-03-20-3hr.png)
