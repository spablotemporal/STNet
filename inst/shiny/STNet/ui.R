# ui -----------------
## header -----------
header <- dashboardHeader(title = 'App')

## Sidebar-----------
# Define la barra del menu lateral
sidebar <- dashboardSidebar(
  sidebarMenu(
    # Menus para los tabs
    menuItem(text = 'Network', tabName = 'Network_tab'),
    hr()
    # inputs globales
  )
)

## Body ------------
body <- dashboardBody(
  tabItems(
    # Agrega los tabs del cuerpo de la aplicacion 
    tabItem(tabName = 'Network_tab',
            # Agrega aqui mas detalles de tu interfaz de usuario (p.ej. texto, inputs, outputs, etc)
            fluidRow(
              box(title = 'Input data', width = 12, collapsible = T, 
                  fileInput(inputId = 'UploadEdges', label = 'Edges'),
                  # Head of the edges
                  DTOutput('EdgeTbl'),
                  hr(), 
                  'Select Origin and Destinations: ',
                  uiOutput(outputId = 'FromUI'),
                  uiOutput(outputId = 'ToUI'),
                  uiOutput(outputId = 'DateUI'),
                  actionButton(inputId = 'CreateNetwork', label = 'Create Network')
                  ),
              box(title = 'Network', width = 9,
                  plotOutput('NetPlot'),
                  plotOutput('HistPlot', height = 150)
                  ),
              box(title = 'Network Options', width = 3,
                  uiOutput(outputId = 'ColUI'),
                  uiOutput(outputId = 'SizeUI')
                  # selectInput('Size', 'Size', choices = c('Indegree', 'Outdegree'), width = '30%')
                  )
            )
            
    )
  )
)

## Integrar UI ----------
dashboardPage(header = header, 
              sidebar = sidebar, 
              body = body) %>% 
  shinyUI()