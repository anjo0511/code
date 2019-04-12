#
# Writen by Andreé Johnsson, andreéjohnsson@outlook.com
#
require(rlist)
require(magrittr)
require(tidyverse)
require(parallel)
makeListofList.500 <- function(bacID.vec,cutoff = 500){
    # Given a enormous list of seqID this function
    # Separates each 500 seq in a separate list and returns it
    # as a list of lists.
    baclist.500.all = list()
    baclist.names.500.all = NULL
    for (i in seq(1,length(bacID.vec),cutoff)){
        baclist.names.500.all %<>% append(.,paste0(i,"_bac"))
        tmp.500 = bacID.vec[i:(i+(cutoff-1))]
        baclist.500.all %<>% list.append(.,tmp.500)
        names(baclist.500.all) <- baclist.names.500.all
    }
    # Removes NA values in the end of the last list if not even
    last.name <- names(tail(baclist.500.all,1))
    baclist.500.all[[last.name]] %<>% .[!is.na(.)]
    cat("**** The last elements of the list: ****\n")
    tail(str(baclist.500.all))
    return(baclist.500.all)
}
save.YAML.query <- function(listOfLists,directory,extension=".yaml"){
    # Given a directory name and the list of lists previously created
    # We save a separate file containing max 500 seq in each. 
    lapply(listOfLists
           , function(x,directory){
               directory %<>% paste0(.,x[1],extension)
               x %<>% paste(.,collapse = ",")
               list.save(x
                         , file = directory
                         , type = "YAML")},directory)
}
parallel.save.500.query.YMAL <- function(listOfLists,directory,extension=".yaml"){
    # Given a directory name and the list of lists previously created
    # We save a separate file containing max 500 seq in each. 
    no_cores <- detectCores() - 1
    cl <- makeCluster(no_cores)
    
    parLapply(cl,listOfLists
              , function(x,directory){
                  require(rlist)
                  require(magrittr)
                  require(tidyverse)
                  directory %<>% paste0(.,x[1],extension)
                  x %<>% paste(.,collapse = ",")
                  list.save(x
                            , file = directory
                            , type = "YAML")},directory)
    stopCluster(cl)
}
listFilenames<-function(folder,extensionPattern=".yaml$",fullpath=FALSE){
    listfiles <-
        list.files(folder
                   , recursive = TRUE
                   , full.names = fullpath
                   , pattern = extensionPattern)
    listfiles %<>% sapply(., function(x) paste0("-",x))
    names(listfiles) <- NULL
    listfiles %<>% as.data.frame(.)
    colnames(listfiles) <- "Files.in.Dir"
    return(listfiles)
}
listOutPutFilenames <- function(fil.names.df){
    fil.names.df %<>% apply(., 1, function(x) gsub("^-","-out_",x)) %>%
        gsub(".yaml$",".fasta",.) %>% as.data.frame(.)
    colnames(fil.names.df) <- "OutPutFiles.in.Dir"
    fil.names.df
}
saveFiles.Names <- function(df,path="~/Downloads/filnames.txt"){
    write_tsv(df,path = paste0(path),col_names = FALSE)
}

####### test ##############

test_ID= bacSeqIDinBD[1:50]
x= makeListofList.500(test_ID,cutoff = 10)

#save.YAML.query(x,"~/Downloads/test_seq/")
parallel.save.500.query.YMAL(x,directory="~/Downloads/test_seq/")


x = listFilenames("~/Downloads/test_seq/")
x
y = listOutPutFilenames(x)
y

saveFiles.Names(x,"~/Downloads/input.txt")
saveFiles.Names(y,"~/Downloads/output.txt")
