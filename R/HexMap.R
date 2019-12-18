#' Function to Plot a Hexagonal grid map of counts
#' 
#' @param Hex A hexagon grid, see HexGrid function on how to create it
#' @param Points A set of points that will be counted by cell
#' @export

HexMap <- function(Hex, Points){
  Hex %>%
    st_join(Points) %>%
    group_by(idhex) %>%
    summarise(N = n()) %>%
    mutate(N = ifelse(N == 1, NA, N))
}