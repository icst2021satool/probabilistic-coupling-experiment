#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("You should provide the directory of tableIV.csv (input file).n", call.=FALSE)
} else if (length(args)==1) {
        # set yourpath
	print(args[1])
        yourpath=paste(args[1],"", sep="")
	print(yourpath)
} else {
  stop("Too many arguments supplied (input file).n", call.=FALSE)
}

file1 = paste(yourpath,"/", "tableIV.csv", sep="")
print(file1)
csvfile = read.csv(file.path(file1),stringsAsFactors=FALSE, header = TRUE, sep = ";", dec = ".")
print(csvfile)
print(summary(csvfile))
print("Std Duas")
print(sd(csvfile$DUAs, na.rm = TRUE))
print("Std Dua-node")
print(sd(csvfile$DUA.Node, na.rm = TRUE))
print("Std Dua-edge")
print(sd(csvfile$DUA.Edge, na.rm = TRUE))
print("Std unc-Duas")
print(sd(csvfile$Unc.DUAs, na.rm = TRUE))
print("Std t-node")
print(sd(csvfile$t.Node, na.rm = TRUE))
print("Std t-edge")
print(sd(csvfile$t.Edge, na.rm = TRUE))
print("Std t-Unc-Duas")
print(sd(csvfile$t.Unc.DUAs, na.rm = TRUE))
