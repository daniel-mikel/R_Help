# Find Packages in workspace through console

# Print out list of R packages in workspace

ip <- as.data.frame(installed.packages()[,c(1,3:4)])
rownames(ip) <- NULL
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
print(ip, row.names=FALSE)

# find information on datasets that came with packages
	# results vary by dataset, but should tell you where they are from 

?<dataset name>

help(<dataset name>)