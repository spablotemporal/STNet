# Function to get the grids:
HexGrid <- function(mycellsize, Shp) {
  DFsp <- Shp %>%
    as("Spatial")
  HexPts <- sp::spsample(DFsp, type="hexagonal", offset=c(0,0), cellsize=mycellsize)
  # Create Grid
  HexPols <- sp::HexPoints2SpatialPolygons(HexPts)
  # Conver to spatialpolygon DF
  df <- data.frame(idhex = getSpPPolygonsIDSlots(HexPols))
  row.names(df) <- sp::getSpPPolygonsIDSlots(HexPols)
  hexgrid <- sp::SpatialPolygonsDataFrame(HexPols, data = df) %>% st_as_sf()
  return(hexgrid)
}