#' Function to get the contacts
#' 
#' @param a A sf multipolygon object 
#' @param predicate the predicate function to do for the proximity, default is st_touches
#' @param dist for predicate fnctions based on distance
#' @export

# Get adjacent nbs
get_adj_nbs <- function(a, predicate = 'st_touches', dist = 10){
  # a = s; predicate = 'st_touches'; dist = 0.1
  lapply(a$id, function(x){
    if(predicate == 'st_touches'){
      # x = 251
      nbi <- st_touches(a[a$id == x,], a)[[1]]  # Get adjacent nbs
    }else if(predicate == 'st_is_within_distance'){
      nbi <- st_is_within_distance(a[a$id == x,], a, dist = dist)[[1]]
    }
    nb <- a$id[nbi]
    nb[nb != x]
  })
}