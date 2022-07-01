#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("You should provide datacollection directory (input file).n", call.=FALSE)
} else if (length(args)==1) {
        # set yourpath
	print(args[1])
        yourpath=paste(args[1],"/results/", sep="")
	print(yourpath)
} else {
  stop("Too many arguments supplied (input file).n", call.=FALSE)
}

#listprograms <- c('Chart','Cli','Closure', 'Codec','Collections', 'Compress', 'Csv', 'Gson', 'JacksonCore', 'JacksonDatabind', 'JacksonXml', 'Jsoup', 'JxPath', 'Lang', 'Math','Mockito', 'Time', 'Weka')

listprograms <- c('Chart','Cli','Closure', 'Codec','Collections', 'Compress', 'Csv', 'Gson', 'JacksonCore', 'JacksonDatabind', 'JacksonXml', 'Jsoup', 'JxPath', 'Lang', 'Math', 'Mockito', 'Time') 

for (program in listprograms) {
print(program)
file1 = paste(yourpath, program,"/", program, "-duacov.csv", sep="")
print(file1)
csvfile = read.csv(file.path(file1),stringsAsFactors=FALSE, header = TRUE, sep = ";", dec = ".")
#print(summary(csvfile$DUAcov))
#print(csvfile$DUAcov)
cov=summary(csvfile$DUAcov)
print(cov)
print(sd(csvfile$DUAcov, na.rm = TRUE))
}
