#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
#
library(magrittr)
library(tidyverse)

df = read_csv2("~/Downloads/tree_measures (1).csv", col_names = TRUE)
colnames(df) <- c("line","rep","growth.condition" ,"week.1", "week.2",
                  "week.3","week.4", "week.5", "week.6", "week.7", 
                   "week.8")

df %>% select(line) %>% unique()

get_df = function(df){
    mean.df.tidy1 = NULL
    for (i in c("LD","SD") ){
        mean.df = df %>%
            filter(growth.condition == i) %>% 
            select(-rep,-growth.condition) %>% 
            group_by(line) %>%
            nest() %>%
            mutate(mean = map(data,~map_df(.x,~mean(.x) ) )
                   , se = map(data,~map_df(.x,~sqrt(var(.x)/length(.x)))))%>%
            select(-data) %>%
            unnest() 
        
        colnames(mean.df)[10:17] %<>% map_chr(~str_remove(.x,"[0-9]$"))
        colnames(mean.df)[-1] %<>% paste(c( rep("mean",8),rep("se",8) )
                                         , sep="_")
        mean.df.tidy <-
            mean.df %>%
            gather(type,n,2:17) %>%
            separate(type, into = c("timepoint","method"),sep="_") %>%
            spread(method,n)
        mean.df.tidy %<>%  add_column(condition=rep(i,nrow(mean.df.tidy)))
        mean.df.tidy1 %<>% rbind(mean.df.tidy)
    }
return(mean.df.tidy1)
}


plot_columns <- function(df){
        ggplot(df,aes(x=timepoint,y = mean, fill = line)) +
        facet_wrap(~condition) +
        geom_bar(stat="identity", position = "dodge") +
        geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.6,
                      position=position_dodge(0.9)) +
        theme_bw() +
        theme(legend.position="bottom") +
        scale_fill_brewer(palette="YlGnBu") +
        labs(title = " ",x="Timepoints",y="Average height (cm)"
             , fill= "Line")
        
    }

# Here we call on the functions and rowbind both conditions to create
# a big data.frame http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/ on the bottom one can 
# take the name of a colour pallete

fixed_df = get_df(df)

# Saving a grid of the four plots as a pdf
pdf("~/Downloads/hn.pdf", width=9, height=6)
plot_columns(fixed_df)
dev.off()
