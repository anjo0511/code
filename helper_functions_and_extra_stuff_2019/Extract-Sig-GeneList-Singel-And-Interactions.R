#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
##
#
# Method Descriptions: 
# -------------------------------------------------------------------
# These two functions returns a vector of names of all combinations from 
# the contrast representing the interaction effect between Genotype and Treatment.
# These are not supossed to be used by the user rather to be called by the Extract
# funtions.
# 
# Uniq.Int.Combination.Genotype.Treatment.Names.All.Geno(dds)
# Uniq.Int.Combination.Genotype.Treatment.Names.One.Geno(dds,Genotype)
# 
# -------------------------------------------------------------------
# This is a helper function to extract the significant genes from the 
# results matrix, mainly used by the Extract functions.
# 
# sig.gene.list(res)
# -------------------------------------------------------------------
# This methods returns a list of lists with significant genes, either
# 1) from singel valiables, 2) from interactions, 3) from interactions
# in parallel.
# 
# Extrakt.Sig.GeneListFromAll.Singel.Contrast(dds)
# Extrakt.Sig.GeneListFromAll.Interaction.Contrast(dds,int.list)
# Extrakt.Sig.GeneListFromAll.Interaction.Contrast.Parallel(dds)
# -------------------------------------------------------------------
# 
require(magrittr)
require(tidyverse)
require(DESeq2)
require(parallel)
#
Uniq.Combination.GT.Names.Same.Timepoint <- function(dds){
    # Returns a vector of Genotype Combinations for the same
    # treatment. That is FT and SVP both for ex week 1.
    treat= c("LD","CTW10","LD2","SDW1","SDW10","SDW2","SDW3")  
    names <-sapply(treat,function(x){
        resultsNames(dds) %>%
            grep(paste0("Genotype(FT|SVP)\\.Treatment",x,"$"),.,value = TRUE) %>%
            paste(collapse = "-")
        
    })
    names(names) <- NULL
    names = names[-1] 
    return(names)
}
Uniq.Int.Combination.GT.Names.All.Geno <- function(dds){
    # Get Interactions Unique Combinations of Names
    # Given a dds object it returns all of the unique combination for
    # Interaction terms between Genotype and Treatment i.e wihtin the same Genotype.
    vector = NULL
    Genotype = c("SVP","FT")
    for (i in 1:length(Genotype)){
        interac.names <-
            resultsNames(dds) %>%
            grep(paste0(Genotype[i],"\\."),.,value = TRUE)
        
        combinations.df <- combn(interac.names,2)
        
        for (col in 1:ncol(combinations.df)){
            tmp = combinations.df[,col] %>%
                paste(collapse = "-")
            vector %<>% append(tmp)
        }
    }
    return(vector)
}
Uniq.Int.Combination.Genotype.Treatment.Names.One.Geno <- function(dds, Genotype="SVP"){
    # Get Interactions Unique Combinations of Names fron one Genotype
    # Given a dds object it returns all of the unique combination for
    # Interaction terms between Genotype and Treatment i.e wihtin the same Genotype.
    interac.names <- 
        resultsNames(dds) %>%
        grep(paste0(Genotype,"\\."),.,value = TRUE)
    
    combinations.df <- combn(interac.names,2)
    vector = NULL
    for (col in 1:ncol(combinations.df)){
        tmp = combinations.df[,col] %>%
            paste(collapse = "-")
        vector[col] = tmp
        
    }
    return(vector)
}
sig.gene.list <- function(res){
    # Returns a list of significant seqIDs given a dds results object
    #
    sig.gene.list <- 
        rownames(res[res$padj <= .01 & !is.na(res$padj) & abs(res$log2FoldChange)>=0.5,])
    return(sig.gene.list)
}
Extrakt.Sig.GeneListFromAll.Singel.Contrast <- function(dds){
    # Given a ddsobject, returns a list of all significant, genes for each
    # contrast, only the signle cintrast.
    start_time = Sys.time()
    c.names = resultsNames(dds)
    all.sig.genes <-
        lapply(c.names, function(contrast){
            res = results(dds
                          , name = contrast
                          , alpha = 0.01
                          , lfcThreshold = 0.5)
            sig.genes = sig.gene.list(res)
            return(sig.genes)
        })
    names(all.sig.genes) = c.names
    end_time = Sys.time()
    print(end_time - start_time)
    return(all.sig.genes)
}
Extrakt.Sig.GeneListFromAll.Interaction.Contrast <- function(dds){
    # Extract Significant Gene List
    int.list.1 <- Uniq.Int.Combination.GT.Names.All.Geno(dds)
    int.list.2 = Uniq.Combination.GT.Names.Same.Timepoint(dds)
    int.list = append(int.list.1,int.list.2)
    
    start_time = Sys.time()
    all.sig.genes <-
        lapply(int.list, function(x,dds){
            combination <- strsplit(x,"-")
            res <- results(dds
                           , contrast = combination
                           , alpha = 0.01
                           , lfcThreshold = 0.5)
            
            sig.genes <- sig.gene.list(res)
            return(sig.genes)
        },dds)
    names(all.sig.genes) <- gsub("Genotype|Treatment","",int.list) 
    end_time = Sys.time()
    print(end_time - start_time)
    return(all.sig.genes)
}
Extrakt.Sig.GeneListFromAll.Interaction.Contrast.Parallel <- function(dds){
    # Extract Significant Gene List Interactions in Parallel
    # 
    int.list.1 <- Uniq.Int.Combination.GT.Names.All.Geno(dds)
    int.list.2 = Uniq.Combination.GT.Names.Same.Timepoint(dds)
    int.list = append(int.list.1,int.list.2)

    start_time = Sys.time()
    #n_cores <- detectCores() - 1
    n_cores = 5
    cl <- makeCluster(n_cores)
    
    all.sig.genes <-
        parLapply(cl, int.list, function(x,dds){
            require(magrittr)
            require(DESeq2)
            require(tidyverse)
            combination <- strsplit(x,"-") 
            res <- results(dds
                           , contrast = combination
                           , alpha = 0.01
                           , lfcThreshold = 0.5)
            
            sig.genes <- rownames(res[res$padj <= .01
                                      & !is.na(res$padj)
                                      & abs(res$log2FoldChange)>=0.5,])
            return(sig.genes)
        },dds)
    names(all.sig.genes) <- gsub("Genotype|Treatment","",int.list) 
    stopCluster(cl)
    end_time = Sys.time()
    print(end_time - start_time)
    return(all.sig.genes)
}
# Test
# all.int.names =Uniq.Int.Combination.Genotype.Treatment.Names.All.Geno(dds.alfredo.noBad.noBB)
# svp.int.names = Uniq.Int.Combination.Genotype.Treatment.Names.One.Geno(dds.alfredo.noBad.noBB,"SVP")
# 
# sig.con.genes = Extrakt.Sig.GeneListFromAll.Singel.Contrast(dds.alfredo.noBad.noBB)
# str(sig.con.genes)
# 
# sig.gene.list = Extrakt.Sig.GeneListFromAll.Interaction.Contrast(dds.alfredo.noBad.noBB,svp.int.names[1:2])
# str(sig.gene.list)
# 
# sig.gene.list.parallel=
#     Extrakt.Sig.GeneListFromAll.Interaction.Contrast.Parallel(dds.alfredo.noBad.noBB,svp.int.names[1:2])
# str(sig.gene.list.parallel)