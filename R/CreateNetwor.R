#' Function to get the contacts
#' 
#' @param DF A data.frame object with the information of the GPS Locations.
#' @param DTh The distance treshold in meters.
#' @param coords the names of the columns with the coordinates in the data.frame object.
#' @param DateTime The name of the column with the temporal information o fhte GPS record.
#' @param ID The name of the column with the unique Identifier for the subjects.
#' @export

CreateNetwork <- function(DF, DTh, coords = c("X", "Y"), DateTime = "DateTime", ID = "ID"){
  ### Test data
  # DF <- data.frame(GPSc); ID <- "CollarID"; DateTime <- "DateTime"; coords <- c("X", "Y"); DTh = 1
  # DF <- GPSc; DateTime = "date"; ID = "id"; coords = c("Longitude", "Latitude")
  # DTh <- 1
  TimePoints <- unique(DF[DateTime]) # Get unique timepoints
  
  D_DF <- data.frame(Var1 = NA, Var2 = NA, X.x = NA, Y.x = NA, X.y = NA, Y.y = NA, Distance = NA, DateTime = TimePoints[1,]) # Create a data frame to fill with the data
  # D_DF <- matrix(ncol = 8)
  
  # Loop to get the contacts
  for(i in 1:nrow(TimePoints)){
    # i <- 1
    DF_i <- DF[which(DF[,DateTime] == TimePoints[i,]),]
    
    SP_i <-  DF_i %>%
      st_as_sf(coords = coords)
    
    D_DF_i <- expand.grid(DF_i[, ID], DF_i[, ID]) %>% # Create a data frame for all combinations of possible Origin-Destination
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
    
    colnames(D_DF_i) <- colnames(D_DF)
    
    D_DF <- rbind(D_DF, D_DF_i)
  }
  D_DF <- D_DF[-1,] %>%
    group_by(Distance, DateTime) %>%
    summarise_all(.funs = first)
  
  return(D_DF)
}