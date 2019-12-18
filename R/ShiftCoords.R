#' Function to Shift a set of coordinates, used to de-identify data
#' 
#' @param x The set of coordinates to be used, must be in a data.frame format
#' @export
#' 
ShiftCoords <- function(x){
  e1 <- rnorm(1, 5)
  e2 <- rnorm(1, 4)
  xs <- x[,1] + e1
  ys <- x[,2] + e2
  
  return(cbind(X = xs, Y = ys))
}