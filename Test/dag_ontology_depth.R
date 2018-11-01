#!/usr/bin/env Rscript
####################################################################################################
#
# This program receives a list of nodes from the Gene Ontology OBO representation
# and returns  table with their depth. The depth of a node is defined as the minimum number 
# of edges from the node to the root. 
#
# ./dag_ontology_depth.R <GO:id> <GO:id> .... <GO:id>
# 
# input: list of <GO:id> 	provided by user, default value GO:0008153 (depth:6)
# input_file: go.obo    	file downloaded from http://purl.obolibrary.org/obo/go.obo (last visit Sep 20th) 
# output: depth         	integer
#
# dag.R was developed following the strategy TDD (Test driven development)
# R library Testthat was used for TDD, for this reason the script dag.R is acompanied by test_dag.R  
# Date: Oct 2018
# Author: Nelly Selem nselem84@gmail.com
#####################################################################################################

#----------------------------------------------------------------
## Required libraries  
#-------------------------------------------------------------------
if(!require(ontologyIndex)){
  install.packages("ontologyIndex")
  }
library(ontologyIndex)
########################################### End libraries  

#---------------------------------------------------------------
## Reading inputs
#-------------------------------------------------------------------
	# Reading input file
input_file<-"data/go.obo"

	# Reading Go terms
nodes<-commandArgs(trailingOnly = TRUE)


	# Defending against no Go terms 
cat ("\n--------------Reading inputs--------------------------------------\n")
if (length(nodes)==0){
	cat ("\ndag_ontology_depth will run with default node GO:0008153\n\n")
	nodes<-"GO:0008153"
	} else {
	for (node in nodes){
		st<-unlist(strsplit(node, ":"))
		id<-as.numeric(st[2])
		if (!is.null(st[1]) && st[1]=="GO" && !is.null(id) && id>0 && id<2001318){
			cat ("\n\nThis program will calculate the depth of",nodes,"\n")
		}else{
			cat ("\nERROR:This is not a valid GO id, ids must be in the form GO:number\n")
			cat ("and the number must be between 0000001 and 2001317\n")
			cat ("Example: GO:0008153\n\n")
			q()
		}
	}
}

	# Creating ontology from input file  
cat ("Creating Ontology from", input_file,", may take 2-3 minutes \n")
ontology <- get_ontology(input_file)
cat ("Ontology, has been created from", input_file," \n")

	# Setting roots  
roots=c(biological_process="GO:0008150", cellular_component="GO:0005575",molecular_function="GO:0003674")
########################### End reading data

## Declare depth function 
depth <- function(node){
	# start depth is 0 for roots or obsolete terms
  	depth_val=0         

 	# if obsolete then depth is -1 because node is not conected at all with roots
 	if (ontology$obsolete[node]=="TRUE") {
		depth_val=-1
	}else{# if not obsolete then the will will search backwards in the parents set until finding a root    
		# node_back will store step by step a list of nodes and their parents
  		node_back<-node	
 
    		while(length(intersect(node_back,roots))==0){ 
		# while set {{node}union{parents node}} intersection with set {root1,root2,root3} is empty
      			depth_val=depth_val+1                  #add one to depth_val 
      			node_back=unique(unlist(ontology$parents[node_back]))  
    			}
		}
  	return (depth_val)
  }
## For the future, would be better to also pass as variables ontology and roots
############################ End depth function   


#-----------------------------------
# Calculating depth of inputs 
#-----------------------------------------------------
cat ("\n---------------Depths of nodes   -----------------------\n")
for (node in nodes){
	node_depth<-depth(node)
	cat("depth",node_depth,"\n")
	}

#
#----------------------------------------------------------------
#########  Sesion info
cat ("\n---------------Sesion info   -----------------------\n")
sessionInfo()
