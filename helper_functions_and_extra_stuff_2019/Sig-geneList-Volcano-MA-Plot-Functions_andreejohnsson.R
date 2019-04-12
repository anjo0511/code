#
# Writen by:  Andreé Johnsson <andreejohnsson@outlook.com>
#
suppressPackageStartupMessages(require(ggplot2))
suppressPackageStartupMessages(require(ggrepel))
volcanoPlot = function(res,use.labels=FALSE){
    # PLots a volcano plot with the threshold for significance of
    # padj <= 0.01 & Log2FoldChange >= 0.5 by givin a results object
    # directly after Dseq method. 
    subtitle = gsub("Wald statistic:","",res@elementMetadata$description[4])
    res = as.data.frame(res)
    res$Genes = rownames(res)
    res$Significant = ifelse(res$padj <= .01 &
                                 !is.na(res$padj) &
                                 abs(res$log2FoldChange) >= 0.5
                             , "FDR < 0.01", "Not Sig")
    
    ggplot(res,aes(x=log2FoldChange, y=-log10(padj))) +
        geom_point(aes(col=Significant)) +
        geom_point(data= res[res$Significant=="FDR < 0.01",], aes(x=log2FoldChange,y= -log10(padj)), col="red") +
        
        labs(title = "Volcano Plot", caption = "\nThreshold: padj <= 0.01 & Log2FoldChange >= 0.5"
             , subtitle = subtitle,col="Significance: ") +
        theme_light(base_size = 12) + theme(legend.position = "top") +
        scale_color_manual(values = c("red", "grey")) +
        
        geom_hline(yintercept=-log10(0.01),linetype="dashed", color = "red") +
        geom_vline(xintercept=-log2(0.5),linetype="dashed", color = "blue") +
        geom_vline(xintercept=log2(0.5),linetype="dashed", color = "blue") +
        geom_text_repel(
            data = res[res$Significant=="FDR < 0.01",],
            aes(label = ifelse(use.labels == TRUE,res$Gene, "")),
            #size = 1,
            box.padding = unit(0.35, "lines"),
            point.padding = unit(0.3, "lines")
        )
}
suppressPackageStartupMessages(require(ggpubr))
gg.ma.Plot <- function(res,no.labels=0){
    # Plots a MA plot given dds-results object
    # It is possible to specify No of labels to be displayed
    # i.e no of significant genes labels
    subtitle = gsub("Wald statistic:","",res@elementMetadata$description[4])
    ggmaplot(res
             , main = paste("MA Plot:",subtitle,sep = "\n")
             , fdr = 0.01 
             , fc = 0.5
             , size = 0.6
             , palette = c("#B31B21", "#1465AC", "darkgray")
             , genenames = as.vector(rownames(res))
             , legend = "top"
             , top = no.labels # top decides how many labels to show
             , font.label = c("bold", 11)
             , font.legend = c("bold",12)
             , ggtheme = ggplot2::theme_minimal())
}
suppressPackageStartupMessages(library(LSD))
maPlot.singelSample <- function(df,col.list){
    M = log2(df[,col.list[1]] / df[,col.list[2]])
    A = 0.5*log2(df[,col.list[1]] * df[,col.list[2]])
    heatscatter(x = A, y = M)
}