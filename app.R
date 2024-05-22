
library(shiny)
library(shinythemes)
library(shinybusy)
library(tinytex)
if (!tinytex::is_tinytex()) {
  tinytex::install_tinytex()
}

jugadores <- c("Jota","Andu","Cerve","Juanqui","Diego","Blesa","Adri")
# Define UI for application that draws a histogram
ui = fluidPage(theme = shinytheme("cerulean"),
               
               
               tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
                        tags$h2(class = 'jumbotron-heading', style = 'margin-bottom:0px;margin-top:0px', 'Estadísticas OSM 2024/25'),
                        p('Consulta de estadísticas')
               ),
               
               
               div(style = "position: absolute; top: 35px; left: 10;", 
                   tags$img(src = "https://golab.es/wp-content/uploads/2021/07/cropped-Logo-web-Golab-1.png", width = 100, height = 100)
               ),
               
               numericInput("jorn",
                            "Jornada","", min = 1, max = 38),
               selectInput("Jugador", "Elige el jugador",c(Elige = '', jugadores),selectize = TRUE),
               
               downloadButton("report", "Generar informe de partido"),
               add_busy_spinner(spin = "fading-circle")
               
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$report <- downloadHandler(
    filename = function() {
      paste0(input$Jugador, "-Jornada", input$jorn, ".pdf")
    },
    content = function(file) {
      params <- list(Jornada = input$jorn, jugador = input$Jugador)
      out <-rmarkdown::render(
        "Estadisticas.Rmd",
        params = params,
        output_file = file,
        envir = new.env(parent = globalenv())
      )
      file.rename(out,file)
    }
  )
}


# Run the application 
shinyApp(ui = ui, server = server)
