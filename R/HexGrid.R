#' Function to Create a Hexagonal grid in a spatial field
#' 
#' @param mycellsize The size of each cell of the grid.
#' @param Shp A shapefile which will be used as the area for the grids, must be in UTM
#' @export

HexGrid <- function (cellsize, Shp){
  DFsp <- Shp %>% as("Spatial")
  HexPts <- sp::spsample(DFsp, type = "hexagonal", offset = c(0,0), cellsize = cellsize)
  HexPols <- sp::HexPoints2SpatialPolygons(HexPts)
  df <- data.frame(idhex = gsub("ID", "", getSpPPolygonsIDSlots(HexPols)))
  row.names(df) <- sp::getSpPPolygonsIDSlots(HexPols)
  hexgrid <- sp::SpatialPolygonsDataFrame(HexPols, data = df) %>% 
    st_as_sf(crs = st_crs(Shp))
  return(hexgrid)
}