#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
#
library(magrittr)
library(tidyverse)

paths <- list.files(path = "/cloud/project/pernilla/data_frames/"
           , pattern = "^Ki"
           , full.names = TRUE)

read_files <- function(x){
    time_name <- str_extract(x,"[0-9]{4}\\-[0-9]{2}") %>%
        gsub("-","_",.)
    tmp_df <-
        read_tsv(x, col_names = c("tax.id","organism","species","genus"
                               ,"family","taxID.species","taxID.genus","taxiID.family"))
    
    tmp_df %<>% add_column(time = rep(time_name,nrow(tmp_df) ))
    return(tmp_df)
    }

# Reads in all files puts a column(time) as id for the each dataframe
all.df <- paths %>%
    map(~read_files(.x)) %>% do.call(rbind,.)

# Converts columns datatype
all.df %<>% mutate(
    tax.id = as.character(tax.id) ,
    taxID.species = as.character(taxID.species),
    taxID.genus = as.character(taxID.genus),
    taxiID.family = as.character(taxiID.family),
    time = factor(time, levels = unique(time))
)

# How many dataFrames/Timepoints do we have?
all.df %>% select(time) %>% unique() %>% nrow()

# We extract the ids that are present in each dataframe i.e 9 times
taxid_species_9_meassures <-
    all.df %>%
    count(taxID.species,sort = TRUE) %>%
    filter(n==9) %>%
    pull(taxID.species)

# We first select the rows of the species that are present in each dataframe
# then group by the tax.ID,species and for each group take the median. This
# creates a df of the medians which we then sort in decresing order and save
# all tax.ID,species.
taxid_species_9_meassures_decrising_higestest_median <-
    all.df %>%
    filter(taxID.species %in% taxid_species_9_meassures) %>%
    group_by(taxID.species) %>%
    summarise(median = median(species)) %>%
    arrange(desc(median)) %>%
    pull(taxID.species)
    
# We now create a new column by dividing the species(reads) by one miljon then
# subsets the big df to only include the rows of the 10 with higest median and pass
# to ggplot, geom_smooth approximates the pattern to make a plot with soft edges.
all.df %>% mutate(species_millions = species/1e6) %>% 
    filter(taxID.species %in% taxid_species_9_meassures_decrising_higestest_median[1:10]) %>%
    ggplot(aes(x=time,y=species_millions,group=taxID.species,col=organism)) +
    geom_smooth(se = FALSE, method = "loess",formula = "y~x") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 35, hjust = 1)) +
    labs(title = "No. of Reads in Species of the 10 Most Abundant Organisms"
         , x="Time (year-week-sample-id)"
         , y= "No. Reads (Millions)"
         , col = "Organism")

