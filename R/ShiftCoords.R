## Function to shift the coordinates, (data frame of x and Y needed)
ShiftCoords <- function(x){
  e1 <- rnorm(1, 5)
  e2 <- rnorm(1, 4)
  xs <- x[,1] + e1
  ys <- x[,2] + e2
  
  return(cbind(X = xs, Y = ys))
}