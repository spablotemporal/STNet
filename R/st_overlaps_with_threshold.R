#' Function Overlap based on a treshold
#' 
#' @param x spatial object
#' @param y spatial object to overlap with
#' @param treshold A treshold for the overlap
#' @export
#' 
st_overlaps_with_threshold <- function(x, y, threshold) {
  int = st_intersects(x, y)
  lapply(seq_along(int), function(ix)
    if (length(int[[ix]]))
      int[[ix]][which(st_area(st_intersection(x[ix,], y[int[[ix]],])) > threshold)]
    else
      integer(0)
  )
}  