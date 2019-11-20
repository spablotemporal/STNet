# HexMap

HexMap <- function(Hex, Points){
  Hex %>%
    st_join(Points) %>%
    group_by(idhex) %>%
    summarise(N = n()) %>%
    mutate(N = ifelse(N == 1, NA, N))
}