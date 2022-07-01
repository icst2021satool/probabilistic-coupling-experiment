#!/usr/bin/env Rscript
# Create the function mode.
getmode <- function(v) {
   uniqv <- unique(v)
   uniqv[which.max(tabulate(match(v, uniqv)))]
}
# Create the function estimated probability.
get_estimated_probability <- function(v) {
   N_true = subset(v,LessFdpUnc == 'True')
   N_false = subset(v,LessFdpUnc == 'False')
   N_notclear = subset(v,Status == 'notclear')
   print("False:")
   nfalse = nrow(N_false)
   print(nfalse)
   print("True:")
   print(nrow(N_true))
   ntrue = nrow(N_true)
   print("Notclear:")
   nnotclear=nrow(N_notclear)
   print(nnotclear)
   print("Total:")
   print(nfalse+ntrue)
   estprob=((ntrue/(nfalse+ntrue)))
   print("Estimated probability:")
   print(100*estprob)
   print("Variance:")
   variance=estprob*(1-estprob)
   print(100*variance)
   print("Std err:")
   stderr = sqrt(variance/(nfalse+ntrue))
   print(100*stderr)
   print("95% CI lower limit:")
   lowci=estprob-1.96*stderr
   print(100*lowci)
   print("95% CI higher limit:")
   highci=estprob+1.96*stderr
   print(100*highci)
}

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

# You have to install package ggplot2 before using this script
#install.packages("ggplot2", dependencies = TRUE)  
# load library ggplot2
library(ggplot2)

file1 = paste(yourpath, "/uncduas-vs-subduas/uncduas-vs-subduas-plot", ".csv",sep="")
# v = read.csv(file.path(file1), stringsAsFactors=FALSE)

print(file1)
v = read.csv(file.path(file1),stringsAsFactors=FALSE, header = TRUE, sep = ";", dec = ".")

print(get_estimated_probability(v))
print("UncFdpMax:")
mode=getmode(v$UncFdpMax)
print(summary(v$UncFdpMax))
print("Mode for :")
print(mode)
print("Frequency mode value for UncFdpMax:")
N_value_1=subset(v,UncFdpMax == 1.0)
print(nrow(N_value_1))

print("FdpMaxDF:")
mode=getmode(v$FdpMaxDF)
print(summary(v$FdpMaxDF))
print("Mode for FdpMaxDF:")
print(mode)
print("Frequency mode value for FdpMaxDF:")
N_value_1=subset(v,FdpMaxDF == 1.0)
print(nrow(N_value_1))

p<-ggplot(v)
p<-p+geom_violin(aes(x="",y=UncFdpMax),fill="gray80")+xlab("Bugs")+ylab("Maximum Probablistic Coupling Unconstrained DUAs")+stat_summary(aes(x="",y=UncFdpMax),fun = "median", colour = "black", size = 3, geom = "point",shape=2)+stat_summary(aes(x="",y=UncFdpMax),fun = "mean", shape = 8, colour = "black", size = 1)+theme_bw()
ggsave("plotUncDUAs.eps",plot=p,device="eps",path=".")
d<-ggplot(v)
d<-d+geom_violin(aes(x="",y=FdpMaxDF))+xlab("Bugs")+ylab("Maximum Probablistic Coupling DUAs")+stat_summary(aes(x="",y=FdpMaxDF),fun = "median", colour = "black", size = 3, geom = "point",shape=2)+stat_summary(aes(x="",y=FdpMaxDF),fun = "mean", shape = 8, colour = "black", size = 1)+theme_bw()
ggsave("plotDUAs.eps",plot=d,device="eps",path=".")
