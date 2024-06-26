
library(shiny)
library(shinythemes)
library(shinybusy)
library(tinytex)


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
               radioButtons("tipoInforme", "Selecciona el tipo de informe", choices = list("Jornada" = "Jornada", "Temporada" = "Temporada","Estadísticas Generales" = "Lideres")),
               
               conditionalPanel(
                 condition = "input.tipoInforme == 'Jornada'",
                 numericInput("jorn", "Jornada", "", min = 1, max = 38)
               ),
               conditionalPanel(
                 condition = "input.tipoInforme != 'Lideres'",
                 selectInput("Jugador", "Elige el jugador", choices = c('Elige' = '', jugadores), selectize = TRUE)
               ),
               downloadButton("report", "Generar informe"),
               add_busy_spinner(spin = "fading-circle")
               
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$report <- downloadHandler(
    filename = function() {
      if (input$tipoInforme == "Jornada") {
        paste0(input$Jugador, "-Jornada", input$jorn, ".pdf")
      } else if(input$tipoInforme == "Lideres"){
        paste0("LideresEstadisticasOSM",".pdf")
      }
      else {
        paste0(input$Jugador, "-Temporada.pdf")
      }
    },
    content = function(file) {
      if (input$tipoInforme == "Jornada") {
        params <- list(Jornada = input$jorn, jugador = input$Jugador)
        out <- rmarkdown::render(
          "Estadisticas.Rmd",
          params = params,
          output_file = paste0(input$Jugador, "-Jornada", input$jorn, ".pdf"),
          envir = new.env(parent = globalenv())
        )
      } else if (input$tipoInforme == "Lideres"){
        out <- rmarkdown::render("Lideres.Rmd",output_file = "LideresEstadisticasOSM.pdf",
        envir = new.env(parent = globalenv())
        )
      }
      else {
        params <- list(jugador = input$Jugador)
        out <- rmarkdown::render(
          "EstadisticasMedias.Rmd",
          params = params,
          output_file = paste0(input$Jugador, "-Temporada.pdf"),
          envir = new.env(parent = globalenv())
        )
      }
      file.rename(out, file)
    }
  )
}


# Run the application 
shinyApp(ui = ui, server = server)
