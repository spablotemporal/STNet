# Load libraries
library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(tidygraph)
library(ggraph)
library(ggplot2)

# Increase max upload size
options(shiny.maxRequestSize=500*1024^2)