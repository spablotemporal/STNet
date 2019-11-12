# Round Coordinates (Has to be UTM)

RoundCoords <- function(Coords, fct){
  Crds <- floor(st_coordinates(Coords)/fct)
  Crds <- data.frame(Crds * fct)
  Crds <- st_as_sf(Crds, coords = c("X", "Y"), crs = st_crs(Coords))
  return(Crds)
}