#' ---
#' output:
#'  html_document:
#'    toc: false
#'    number_sections: false
#' ---


#' # Brief Introduction

#' This report includes a table of only the D.E genes for the interaactions along with the belonging table they are being significant to.
#' For each timepoint displaying only the significant genes. As title is the  condition the tamplecorresponds to. The title means The significant genes from the difference between two timepoints example "FT_SDW2_SDW1 " means the difference between SDW1 and SDW2 in FT background. 
#' 
#' One can aswell search for a specific term in the window.
#' 
#' The information displayed are gathered from websites:
#' 
#'    <https://www.arabidopsis.org/>
#'    
#'    <http://popgenie.org/>
#'    

#' ```{r set up, echo=FALSE}
#' knitr::opts_knit$set(echo=FALSE)
#' ```



#' ```{r include=FALSE}
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(magrittr))
suppressPackageStartupMessages(library(DT))
#' ```


pop_arab_genie_all_genes <- read_csv2("~/Project-Git-Files-aspen-FTL1-growth-cessation/src/R/restart_Analysis_To_make_int_Understandable/0-Important-DataTables/pop_arab_genie_all_genes.csv", col_names = TRUE, guess_max = 80000)


pop_arab_genie_all_genes %>% filter(!is.na(Significant.Tables)) %>%
    select(-Transcript,-ATG,-Gene.Model.Name.tair,-Gene.Model.Type.tair) %>%
    unique() %>% 
    datatable(options = list(searchHighlight = TRUE
                             , pageLength = 5
                             , search.caseInsensitive=FALSE)
              , filter = 'top', class = 'cell-border stripe')

