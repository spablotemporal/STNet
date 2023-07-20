#' Function to get the contacts
#' 
#' @param x A sf data.frame
#' @export

sp_lims <- function(x){
  bb <- st_bbox(x)
  lims(x = bb[c(1, 3)], y = bb[c(2, 4)])
}