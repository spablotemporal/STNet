# server ------------------
function(input, output){
  ## Reactivity ---------------
  # Table of edges
  Edges <- eventReactive(input$UploadEdges, {
    Edges <- read.csv(input$UploadEdges$datapath)
  })
  
  # Create the network
  Net <- eventReactive(input$CreateNetwork, {
    Edges()[, c(input$From, input$To)] %>% 
      as_tbl_graph() %N>% 
      mutate(Indegree = centrality_degree(mode = 'in'),
             Outdegree = centrality_degree(mode = 'out'),
             Authority = centrality_authority())
  })
  
  
  ## Outputs ------------------
  output$FromUI <- renderUI({
    opts <- colnames(Edges())
    selectInput('From', 'From', opts, selected = opts[1], width = '30%')
  })
  
  output$ToUI <- renderUI({
    opts <- colnames(Edges())
    selectInput('To', 'To', opts, selected = opts[2], width = '30%')
  })
  
  output$DateUI <- renderUI({
    opts <- colnames(Edges())
    selectInput('Date', 'Date', opts, selected = opts[1], width = '30%')
  })
  
  output$ColUI <- renderUI({
    opts <- colnames(Edges())
    selectInput('Col', 'Col', opts, width = '50%')
  })
  
  output$SizeUI <- renderUI({
    opts <- Net() %N>%  data.frame() %>% colnames()
    selectInput('Size', 'Size', opts[-1], width = '50%')
  })
  
  output$EdgeTbl <- renderDT({
    Edges() %>% 
      head(n = 100) %>% 
      DT::datatable(data =  ., 
                    options = list(
                      pageLength = 5
                    ))
  })
  
  output$NetPlot <- renderPlot({
    Size <- ifelse(is.null(input$Size), 1, input$Size)
    ggraph(graph = Net(), layout = 'kk') +
      geom_edge_link() +
      geom_node_point(aes_string(size = Size)) +
      theme_void()
  })
  
  output$HistPlot <- renderPlot({
    d <- Net() %N>% data.frame()
    
    ggplot(data = d) +
      geom_histogram(aes_string(input$Size)) +
      theme_minimal()
  })
  
  
} %>% 
  shinyServer()