snippet map
	map${1}(${2:list}, ~${3:function}(.x))
	
snippet ggplot
	ggplot(data=.,aes(${2:aes})) +
	 geom_${3:geom}()
	
snippet tryc
	${1:variable} <- tryCatch({
		${2}
	}, warning = function(w) {
	    message(sprintf("Warning in %s: %s", deparse(w[["call"]]), w[["message"]]))
	    ${3}
	}, error = function(e) {
	    message(sprintf("Error in %s: %s", deparse(e[["call"]]), e[["message"]]))
	    message("Returning NA")
	    NA_real_
	    ${4}
	}, finally = {
	    message("Done")
	    ${5}
	})	

snippet map.parallel
	library(parallel)
	no_cores <- detectCores()
	
	system.time({
		${1:variable} <- mclapply(${2:list}, FUN = ${3:function(x) {
			${4}}
		}, mc.cores= (no_cores-${5:2}))
		
		${1:variable} <- unlist(${1:variable})
	})

