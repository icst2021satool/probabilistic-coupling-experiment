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

library(ggplot2)

# Create the function estimated probability and other metrics
get_estimated_probability <- function(nfalse,ntrue,nnotclear) {
   print("nfalse:")
   print(nfalse)
   print("ntrue:")
   print(ntrue)
   print("nnotclear:")
   print(nnotclear)
   print("Total:")
   print(nfalse+ntrue)
   estprob=((nfalse/(nfalse+ntrue)))
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

file1 = paste(yourpath,"duas-vs-cfts/duas-vs-cfts-fixed", ".csv",sep="")
# v = read.csv(file.path(file1), stringsAsFactors=FALSE)

print(file1)
v = read.csv(file.path(file1),stringsAsFactors=FALSE, header = TRUE, sep = ";", dec = ".")

print("==============================")
print("DUA-node:")
N_true_node = subset(v,topDUANodeSubsumption == 'True')
N_false_node = subset(v,topDUANodeSubsumption == 'False')
N_notclear_node = subset(v,topDUANodeSubsumption == 'notclear')
nfalse_node = nrow(N_false_node)
ntrue_node = nrow(N_true_node)
nnotclear_node = nrow(N_notclear_node)
get_estimated_probability(nfalse_node,ntrue_node,nnotclear_node)

print("==============================")
print("DUA-edge:")
N_true_edge = subset(v,topDUAEdgeSubsumption == 'True')
N_false_edge = subset(v,topDUAEdgeSubsumption == 'False')
N_notclear_edge = subset(v,topDUAEdgeSubsumption == 'notclear')
nfalse_edge = nrow(N_false_edge)
ntrue_edge = nrow(N_true_edge)
nnotclear_edge = nrow(N_notclear_edge)
get_estimated_probability(nfalse_edge,ntrue_edge,nnotclear_edge)


df <- data.frame(Req=c("Node", "Node", "Node", "Edge", "Edge", "Edge"),Subsumption=c("True","False", "Not clear","True","False", "Not clear"),Bugs=c(ntrue_node,nfalse_node,nnotclear_node,ntrue_edge,nfalse_edge,nnotclear_edge))

#Colored bars, bars varying from 0 to 1
#p<-ggplot(df,aes(x=Req,y=Bugs,fill=Subsumption)) + geom_bar(stat="identity",position="fill")+xlab("Control flow requirement")+ylab("Bugs")+theme_bw()

# Grey scale, absolute number of bugs
p<-ggplot(df,aes(x=Req,y=Bugs,fill=Subsumption)) + geom_bar(stat="identity")+xlab("Control flow requirement")+ylab("Bugs")+theme_bw()+scale_fill_grey()
ggsave("barDUA-node-egde-sub.eps",plot=p,device="eps",path=yourpath)
