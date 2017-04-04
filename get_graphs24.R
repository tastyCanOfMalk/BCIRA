# all lines
gg.all <- 
  ggplot(df.all.24, aes(x = time, y = variable, color = id)) + 
  theme_gdocs() +
  geom_line() +
  ylab("deflection (mm)") + xlab("time(s)")

# all lines averaged
gg.all.means <- 
  ggplot(A.melt.24, aes(x = time, y = value, color = variable)) +
  theme_gdocs() +
  geom_line() +
  geom_hline(yintercept = 0, 
             color      = gg.vars[[1]]) +
  ylab("deflection (mm)") + xlab("time(s)")

# all lines, zoomed baseline
gg.zoomed.baseline <- 
  ggplot(A.melt.24, aes(x = time, y = value, color = variable)) +
  theme_gdocs() +
  geom_line (alpha = 0.3) +                 
  geom_hline(yintercept = 0, 
             color      = gg.vars[[1]]) +         
  geom_point(data  = B.24, 
             shape = gg.vars[[2]], 
             size  = gg.vars[[5]]) +                  # max deflection
  geom_point(data  = C.24, 
             shape = gg.vars[[2]], 
             size  = gg.vars[[5]]) +                  # cross baseline
  geom_line(stat   = "smooth", 
            method = "loess", 
            se     = F, 
            size   = gg.vars[[6]], 
            alpha  = gg.vars[[7]]) +
  theme(legend.position = "none") +
  xlim(0, 
       max(C.24[,1])*1.1 ) +
  ylim(-max(B.24[,3]*1.1),
       max(B.24[,3]*1.1 )) +
  ylab("deflection (mm)") + xlab("time(s)")

gg.zoomed.break <- 
  ggplot(A.melt.24, aes(x = time, y = value, color = variable)) +
  theme_gdocs() +
  geom_point (alpha = 0.2) +
  geom_hline(yintercept = 0, 
             color = gg.vars[[1]]) +                         
  geom_point(data  = D.24, 
             shape = gg.vars[[4]], 
             size  = gg.vars[[5]]) +                  # break
  geom_line(stat   = "smooth", 
            method = "loess", 
            se     = F, 
            size   = gg.vars[[6]], 
            alpha  = gg.vars[[7]]) +
  theme(legend.position = "none") +
  xlim(min(C.24[,1]), 
       max(D.24[,1])) +
  ylim(min(D.24[,3]),
       max(B.24[,3])*1.3) +
  ylab("deflection (mm)") + xlab("time(s)")


gg.all.facet <- 
  ggplot(A.melt.24, aes(x = time, y = value, color = variable)) +
  theme_gdocs() +
  geom_line (size = 1, 
             alpha = 0.5) +                      
  geom_hline(yintercept = 0, 
             color      = "red") +                    
  geom_point(data  = B.24, 
             shape = gg.vars[[2]], 
             size  = gg.vars[[5]]) +                  # max deflection
  geom_point(data  = C.24, 
             shape = gg.vars[[3]], 
             size  = gg.vars[[5]]) +                  # cross baseline
  geom_point(data  = D.24, 
             shape = gg.vars[[4]], 
             size  = gg.vars[[5]]) +                  # break
  theme(legend.position = "right") +
  facet_wrap(~variable) +
  xlim(0,
       max(D.24[,1])*1.5) +
  ylim(min(D.24[,3]*1.5),
       max(B.24[,3]*1.1 )) +
  ylab("deflection (mm)") + xlab("time(s)")

# format data table
ss           <- tableGrob(round(data.24, 4),
                          theme = ttheme_minimal())  # convert themed df to grob
title        <- textGrob(sub.fold, 
                         gp = gpar(fontsize = 12))   # save date as title
padding      <- unit(5,"mm")                         # bottom title padding
g.table.data <- gtable_add_rows(ss, 
                                heights = grobHeight(title) + padding,
                                pos = 0)
g.table.data <- gtable_add_grob(g.table.data, title, 1, 1, 1, ncol(g.table.data))
# grid.newpage()
# grid.draw(g.table.data)     # print table

gg.all.24 <- 
  arrangeGrob(g.table.data,
              gg.zoomed.baseline,
              gg.zoomed.break,
              gg.all.facet,
              layout_matrix = rbind(c(2,4,4),
                                    c(3,4,4),
                                    c(3,1,1)),
              widths=c(1.4,1,1))

# grid.newpage()
# grid.draw(gg.all.24)