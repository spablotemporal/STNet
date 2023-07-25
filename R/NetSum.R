#' Function to get a network summary
#' 
#' @param x a igraph or tbl grpah object.
#' @export

NetSum <- function(x){
  x = tidygraph::as_tbl_graph(x)
  data.frame(
    Edges = x %E>% data.frame() %>% nrow(),
    Nodes = x %N>% data.frame() %>% nrow(),
    Density = igraph::graph.density(x),
    Components = igraph::components(x)$no,
    Diameter = igraph::diameter(x),
    AvgPathLength = igraph::average.path.length(x),
    # Assortativity = igraph::assortativity(x),
    Transitivity = igraph::transitivity(x, type = 'global'),
    MeanDegree = igraph::degree(x) %>% mean(),
    MedianDegree = igraph::degree(x) %>% median(),
    AvgNbs = igraph::neighborhood.size(x) %>% mean(),
    Modularity = cluster_walktrap(x) %>% modularity(),
    CentDegree = centralization.degree(x)$centralization,
    CentBetweenness = centralization.betweenness(x)$centralization,
    CentCloseness = centralization.closeness(x)$centralization
  ) %>% t() %>% 
    round(., 4) %>% 
    data.frame()
}