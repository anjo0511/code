#
#
#
suppressMessages(library(shiny))
suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(DT))
suppressMessages(library(pdp))
suppressMessages(library(ggExtra))


# https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/
# https://shiny.rstudio.com/tutorial/

# setwd("/cloud/project/rnaseq_plot_expression_profiles/")
load("plot_genes.RData")


plotIndividualExpression_with_scatter <-
    function(vst, median, gene, scatter =FALSE, facet =FALSE){
        # Both graphs share the same aestetics
        aes.1 = aes_string(x= "TimePoint", y= gene
                           , group= "Genotype", col= "Genotype")
        # Plots the median of the replicates across time
        gene_plot <-
            ggplot(median,aes.1) +
            geom_point(size=2) +
            geom_line(size=1.2) +
            theme_bw() +
            theme(axis.text.x = element_text(angle = 50, hjust = 1) ) +
            scale_colour_brewer(palette= "Dark2")  +
            labs(title = gene)
        
        if (facet ==TRUE){
            gene_plot = gene_plot + facet_wrap(~Genotype, scales= "free_y")}
        # Plots the replicatres themselfs if scatter is true
        if(scatter ==TRUE){
            gene_plot = gene_plot + geom_point(data = vst, aes.1)}
        
        return(gene_plot)
    }

ui <-
    navbarPage(title = "RNAseq",
               tabPanel(title = "Plot Expression Profiles",
                            column(3, offset = 1,
                                   textInput(inputId = "multigenename"
                                             , label = "Write one or several pop
                                                    genes separated by a comma"),
                                   radioButtons(inputId = "facet"
                                                ,label = "Facet Plot"
                                                , c("No" = FALSE
                                                    ,"Yes" = TRUE) ),
                                   radioButtons(inputId = "scatter"
                                                ,label = "Show Replicates"
                                                , c("No" = FALSE
                                                    ,"Yes" = TRUE) ),
                                   actionButton(inputId = "plotbutton"
                                                , label = "Plot gene expression")),
                            column(7,
                                   plotOutput("plot", height="auto")) ),
               
               tabPanel(title = "Gene Description Table",
                        column(2),
                        column(8,
                            fluidRow(verbatimTextOutput("genelist")),
                            fluidRow(dataTableOutput("desc")) ),
                        column(2))
    )

server <- function(input, output,session){
    
    output$desc <- DT::renderDataTable({
        datatable(
            pop_arab_genie_all_genes
            , options = list(searchHighlight = TRUE
                             , pageLength = 5
                             , search.caseInsensitive=FALSE)
            , filter = 'top', class = 'cell-border stripe')
        
    }, server = TRUE)
    
    data <- eventReactive(input$plotbutton,input$multigenename)
        
    output$plot <- renderPlot({
        names <- data() %>%  str_split(",") %>% unlist()
        grobs <-
            lapply(names, function(x){
                plotIndividualExpression_with_scatter(
                      vst_to_plot_all_genes
                    , median_vst_alfredo_noBad_noBB_aware
                    , x
                    , input$scatter
                    , input$facet)})
        
        grid.arrange(grobs=grobs,ncol=2,nrow=ceiling(((length(names)/2)+1))
                     , main=textGrob("Median Expression",gp=gpar(fontsize=20,font=3)))
                     
    }, height = function(){session$clientData$output_plot_width}) 
    
    output$genelist <- renderPrint({
        s = input$desc_rows_selected
        if (length(s)) {
            cat('These genes were selected:\n\n')
            cat(pop_arab_genie_all_genes$Gene[s], sep = ', ')
        }
    })
}

shinyApp(ui = ui, server = server)
