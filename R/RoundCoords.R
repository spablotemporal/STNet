#' Function to round teh coordinates, used to de-identify data. Coordinates must be in UTM
#' 
#' @param Coords The coordinates that want to round.
#' @param fct A factor at which the coordinates will be rounded
#' @export


RoundCoords <- function(Coords, fct){
  Crds <- floor(st_coordinates(Coords)/fct)
  Crds <- data.frame(Crds * fct)
  Crds <- st_as_sf(Crds, coords = c("X", "Y"), crs = st_crs(Coords))
  return(Crds)
}