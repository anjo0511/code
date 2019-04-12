#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
#
library(tidyverse)
library(magrittr)
library(gridExtra)

# Reading in the file
df = read_csv2("~/Downloads/bin/starlifedf.csv"
               , col_names = TRUE)

# Now we gather the columns of the radiation to get
# tidy data which is easier to plot we also change the
# columns datatypes.
df %<>%
    gather(OD,ODn,4:7) %>%
    mutate(
        Organism = as.factor(Organism),
        Radiation_level = as.factor(Radiation_level),
        OD = as.factor(OD),
        ODn = as.double(ODn)
        )

# Check for missing values in any column and then removing those.
df %>% map_df(~sum(is.na(.x)))
df %<>% filter(!is.na(ODn))

# Plots the a smooth line closest to the observed values. Making the plot nicer to interpret.
plot_od = function(df,organism){
    df %>%
        filter(Organism == organism) %>% 
        ggplot(aes(x=Time, y=ODn,group=Radiation_level)) +
        facet_grid(~OD) +
        geom_smooth(aes(col=Radiation_level),se=FALSE) +
        #geom_point(aes(col=Radiation_level)) +
        scale_color_brewer(palette="Spectral") +
        theme_bw() +
        labs(title = organism,
             x = "Time (h)",
             y = "Optical Density (OD)",
             col="Radiation Level")
}
# This page shows how to save png or pdfs
# <http://www.cookbook-r.com/Graphs/Output_to_a_file//>

# Now we call the function with the respective organism
# and save the plot to a variable.
one = plot_od(df,"Algae")
two =  plot_od(df,"Algae+Bacteria")
three =  plot_od(df,"Bacteria+BBM")
four =  plot_od(df,"Bacteria+RM")

# Saving a grid of the four plots as a pdf
pdf("~/Downloads/Jona.pdf", width=12, height=8)
grid.arrange(one,two,three,four, nrow = 2)
dev.off()

