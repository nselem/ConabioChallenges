#!/usr/bin/env Rscript
#--------------Setting libraries ----------------------------------------
if(!require(testthat)){
  install.packages("testthat")
}

if(!require(ontologyIndex)){
  install.packages("ontologyIndex")
}
library("ontologyIndex")
library("testthat")
#____________________________
# source the code to test
cat ("###############################################\n")
cat("--start testing of gad_ontology_depth------------\n")
source("dag_ontology_depth.R")

#____________________General observations _________________________________
## Setting cases (All cases for depth 0 and depth 1, some cases for depth 2, 3 and n)
## Depth 0: Roots
## GO:0008153 depth:6 (particular example)
## obsolete  depth -1 (Has no depth because it does not conect with root)
## Root  Has 0 depth and 1 ancestor (itself)
## Nodes with depth 1 (First children of root, two ancestors)
## There are possibly the following cases
## Nodes with three ancestors depth 1
## Nodes with three ancestors depth 2
## Nodes with four ancestors depth 1
## Nodes with four ancestors depth 2
## Nodes with four ancestors depth 3

#######################################################################################
#____________________________________________________________________________________
## Some set of nodes to run test  ------------------------------------------------------
#ontology <- get_ontology("data/go.obo") ##maybe not need it 
#ontology is an Ontology index with data from file data/go.obo
## variable created at gad_ontology_depth

ontology$number_of_ancestors <- sapply(ontology$ancestors, length)
with1ancestors<-which(ontology$number_of_ancestors==1) #roots or obsolete, depth=0 or -1
with2ancestors<-which(ontology$number_of_ancestors==2) # First child, depth=1
with3ancestors<-which(ontology$number_of_ancestors==3) # depth=1 or depth=2
obsolete<-which(ontology$obsolete=="TRUE")
## First five in each list, I choose first five and not random to always have the same test
head5_1anc<-head(with1ancestors,5)
head5_2anc<-head(with2ancestors,5)
head5_3anc<-head(with3ancestors,5)

############################################################################
#                 TESTS                  
#_______________________________________________________________________
context("DAG depth tests")
test_that("DAG_depth returns 0 in root nodes",{
  expect_equal(unlist(lapply(roots,depth),recursive = "TRUE",use.names = FALSE), unlist(rep(0,length(roots))))
  #expect_equal(0, 0)
})

test_that("DAG_depth returns -1 in obsolete nodes",{
  expect_equal(unlist(lapply(obsolete,depth),recursive = "TRUE",use.names = FALSE), unlist(rep(-1,length(obsolete))))
  #expect_equal(0, 0)
})

test_that("DAG_depth returns 1 in direct childs of Roots",{ ## Testing an individual case  
	expect_equal(unlist(lapply(head5_2anc,depth),recursive = "TRUE",use.names = FALSE), unlist(rep(1,5)))
})

test_that("DAG_depth returns 6 in GO:0008153",{ ## Testing an individual case  
  node="GO:0008153"
  expect_equal(depth(node), 6)

})

cat("--start testing of gad_ontology_depth------------\n")


## General considerations for future implementation of depth in a general class dag
## a parent of b implies depth(b) <= depth (a) 
#                            1       2
#                        depth (b) <= dist (b,a)+depth(a) 
##          _D
##         c  |         
##        /   \     
##        a    \
##          \__ \               
##              b

## Structure DAG 
## function distance
## fucntion depth
