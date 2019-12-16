# FUnction to get the contacts
CreateNetwork <- function(DF, DTh, coords = c("X", "Y"), DateTime = "DateTime", ID = "ID"){
  ### Test data
  # DF <- GPSc; ID <- "CollarID"; DateTime <- "DateTime"; coords <- c("X", "Y"); DTh = 1
  # DTh <- 10
  TimePoints <- unique(DF[DateTime]) # Get unique timepoints
  
  D_DF <- data.frame(Var1 = NA, Var2 = NA, X.x = NA, Y.x = NA, X.y = NA, Y.y = NA, Distance = NA, DateTime = TimePoints[1,]) # Create a data frame to fill with the data
  
  # Loop to get the contacts
  for(i in 1:nrow(TimePoints)){
    # i <- 1
    DF_i <- DF %>%
      filter(DateTime == TimePoints[i,])
    SP_i <-  DF_i %>%
      st_as_sf(coords = coords)
    
    D_DF_i <- expand.grid(SP_i$CollarID, SP_i$CollarID) %>% # Create a data frame for all combinations of possible Origin-Destination
      left_join(DF_i[,c(ID, coords)], by = c("Var1" = ID)) %>%
      left_join(DF_i[,c(ID, coords)], by = c("Var2" = ID))
    
    V1 <- match(D_DF_i$Var1, DF_i[,ID]) # match variables from the O-D data frame to the spatial points for origins
    V2 <- match(D_DF_i$Var2, DF_i[,ID]) # match variables from the O-D data frame to the spatial points for destinations
    # Calculate distance
    D_DF_i$Distance <- st_distance(SP_i[V1,], # order by matched origin variables
                                   SP_i[V2,], # order by matched Destination variables 
                                   by_element = T) 
    
    D_DF_i <- D_DF_i %>%
      mutate(DateTime = TimePoints[i,]) %>%
      filter(Var1 != Var2) %>% # Exclude the ones that are same origin-destination
      filter(Distance <= DTh) # Filter to the ones that are under the Spatial treshold
    
    D_DF <- rbind(D_DF, D_DF_i)
  }
  D_DF <- D_DF[-1,] %>%
    group_by(Distance, DateTime) %>%
    summarise_all(.funs = first)
  
  return(D_DF)
}