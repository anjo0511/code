#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
#
# What we need to run this is the log2foldchange matrix having as entries the actual logfold2 change
# for the sig genes and for the non sig genes the entry values of zero or NA.
# and also what col names we want to check.
# <https://scriptsandstatistics.wordpress.com/2018/04/26/how-to-plot-venn-diagrams-using-r-ggplot2-and-ggforce//>

load("~/Project-Git-Files-aspen-FTL1-growth-cessation/src/R/3.D.E_alfredoDataset_gopher_mfuzz/0-RData_Storage/7-barchart_up_down.RData")

get.sig.gene.Name.Matrix <- function(log2_sig_matrix,cols_wanted = colnames(log2_sig_matrix)){
    # This function returns a matrix of all genes and as many condistion as we want with the entries 
    # being the significant genes for each condition, the rest of the entries are NAs.
    #
    # Now we are making the log matrix logical by replacing all 0 values with NA and then map to logical
    # meaning that all sig values will be be true and the rest NA
    # we specify the columns we want.
    logical_sig_matrix <- 
        log2_sig_matrix[cols_wanted] %>%
        na_if(0) %>%
        map_df(~as.logical(.x)) 
 
    # we make a full matrix by repeating the gene names as many columns as we want
    genes_matrix <-
        rownames(log2_sig_matrix) %>%
        list() %>%
        rep( ncol(logical_sig_matrix) ) %>%
        do.call(cbind,.) %>%
        as.tibble()
    
    colnames(genes_matrix) <- colnames(logical_sig_matrix)
    
    # Now we mix the two matriced for each entry that is NA in the logical matrix we
    # take the names matrix and replace the entry in the coresponding position of the names
    # matrix by Na.
    for (col in 1:length(cols_wanted)){
        genes_matrix[ is.na(logical_sig_matrix[,col]) , col] = NA
    }
    # The result is a gene matrix having the sig genes as names in a columns reprecenting
    # the condition.
    return(genes_matrix)
}


genes_matrix = get.sig.gene.Name.Matrix(log2fc_matrix_sig_genes,columns_Levels_wanted)

test = get.sig.gene.Name.Matrix(log2fc_matrix_sig_genes)

test %>% filter(!is.na(SVP_CTW10_LD2))
genes_matrix %>% map_df(~sum(!is.na(.x)))

get_vennD = function(df,group){
    range = switch (group,
            "SVP" = 1:5 ,
            "FT" = 6:10 ,
            "FT_SVP" = 11:16)
    
    list = list()
    df %<>% select(range)
    names = colnames(df) 
    names.sorage = NULL
    for (i in 1:(ncol(df)-1)){
        names.sorage[i] = paste(names[(i)],names[(i+1)],sep = "-")
        
        x = df %>% pull(names[(i)])
        y = df %>% pull(names[(i+1)])
        
        # in common between x and y, also removing Na values.
        int = intersect(x, y) %>% .[!is.na(.)] %>% length()
        #uniq for x
        uniq_former = setdiff(x, y) %>% length()
        # uniq for y
        uniq_latter = setdiff(y, x) %>% length()
        
        # cat(int," ",uniq_former," ",uniq_latter, "\n")
        list %<>% list.append(c(uniq_latter,uniq_former,int))
    }
    list %<>% do.call(rbind,.) %>% as.data.frame()
    rownames(list) = names.sorage
    colnames(list) = c("uniq.latter","uniq.former","intercept")
    return(list)
}


get_vennD(genes_matrix,"SVP")
get_vennD(genes_matrix,"FT")
get_vennD(genes_matrix,"FT_SVP")[1,] %>% rownames()



# DONE Function to plot VennDiagrams
plotVennDiagram.2D <- function(df,data){
    require(ggforce)
    require(ggExtra)
    
    # Here we save all plots
    plist = list()
    
    for (row in 1:nrow(df)){
        tmp.name = unlist( str_split(rownames(df[row,]),"-"))

        # The circles coordiantes
        df.venn <- data.frame(x = c(0.866, -0.866),
                              y = c(0, 0),
                              labels = tmp.name )
        # The most important step is to relevel default order
        levels(df.venn$labels) <- tmp.name
        # My data structured by counts 
        df.vdc <- structure(list(A = c(0, 1, 1),
                                 B = c(1, 0, 1),
                                 Counts = as.integer(df[row,]),
                                 x = c(1.2, -1.2, 0),
                                 y = c(0, 0, 0)),
                            class = "data.frame", row.names = c(NA,-3L))
        colnames(df.vdc)[1:2] = tmp.name
        
        plot <-
            ggplot(df.venn) +
            geom_circle(aes(x0 = x, y0 = y, r = 1.5
                            , fill = labels), alpha = .5, size = .3, colour = 'black') +
            coord_fixed() +
            theme_void() +
            theme(legend.position = 'bottom') +
            scale_fill_manual(values = c('cornflowerblue', 'firebrick')) +
            scale_colour_manual(values = c('cornflowerblue', 'firebrick'), guide = FALSE) +
            labs(fill = NULL) +
            annotate("text", x = df.vdc$x, y = df.vdc$y, label = df.vdc$Counts, size = 5)
        
       plist[[row]] <- plot
       
    }
    main = paste("Venndiagram of DEGs between interactions of",data,"\n",sep = " ")
    grid.arrange( grobs = plist, nrow = 2 , 
                  heights= unit( c(50,50), c("mm", "mm") ) ,
                  top = textGrob(main,gp=gpar(fontsize=15,font=8) ) )
    
}


smal.df1 = get_vennD(genes_matrix,"SVP")
smal.df2 = get_vennD(genes_matrix,"FT")
smal.df3 = get_vennD(genes_matrix,"FT_SVP")


pdf("~/Project-Git-Files-aspen-FTL1-growth-cessation/src/R/3.D.E_alfredoDataset_gopher_mfuzz/vennD.pdf", width = 7,height = 4 )
plotVennDiagram.2D(smal.df1,"SVP")
plotVennDiagram.2D(smal.df2,"FT")
dev.off()


pdf("~/Project-Git-Files-aspen-FTL1-growth-cessation/src/R/3.D.E_alfredoDataset_gopher_mfuzz/vennD2.pdf", width = 9,height = 6 )
plotVennDiagram.2D(smal.df3,"FT_SVP")
dev.off()


plot_Singel_Venn(df,3)
plot_Singel_Venn <-function(df,row){
    tmp.name = unlist( str_split(rownames(df[row,]),":"))
    row = as.integer(df[row,])
    
    # The circles coordiantes
    df.venn <- data.frame(x = c(0.866, -0.866),
                          y = c(0, 0),
                          labels = tmp.name )
    
    levels(df.venn$labels) <- tmp.name
    # My data structured by counts 
    df.vdc <- structure(list(A = c(0, 1, 1),
                             B = c(1, 0, 1),
                             Counts = row,
                             x = c(1.2, -1.2, 0),
                             y = c(0, 0, 0)),
                        class = "data.frame", row.names = c(NA,-3L))
    

    plot <-
        ggplot(df.venn) +
        geom_circle(aes(x0 = x, y0 = y, r = 1.5
                        , fill = labels), alpha = .5, size = .3, colour = 'black') +
        coord_fixed() +
        theme_void() +
        theme(legend.position = 'bottom') +
        scale_fill_manual(values = c('cornflowerblue', 'firebrick')) +
        scale_colour_manual(values = c('cornflowerblue', 'firebrick'), guide = FALSE) +
        labs(fill = NULL) +
        annotate("text", x = df.vdc$x, y = df.vdc$y, label = df.vdc$Counts, size = 5)
    
    return(plot)
}
