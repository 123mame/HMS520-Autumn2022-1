# COVID data viewer

library("shiny")
library("data.table")
library("ggplot2")
library("stringr")


# load data ---------------------------------------------------------------
counts <- fread("counts.csv")

state_map <- setDT(map_data("state"))
state_map[, region := gsub("Of", "of", str_to_title(region))]
setnames(state_map, "region", "state_name")

state_names <- fread("https://raw.githubusercontent.com/jasonong/List-of-US-States/master/states.csv")
names(state_names) <- c("state_name", "state")


# process data ------------------------------------------------------------
counts <- merge(counts, state_names, by = "state")

data_heat_map <- counts[
    ,
    lapply(.SD, mean),
    by = "state_name",
    .SDcols = c("ifr", "mr")
]
data_heat_map <- merge(data_heat_map, state_map, by = "state_name")

variable_names <- list(
    time_series = c("deaths", "cases", "new_deaths", "new_cases", "ifr", "mr"),
    heat_map = c("ifr", "mr")
)


# define UI ---------------------------------------------------------------
ui <- fluidPage(
    navbarPage(
        "COVID Data Viewer",
        tabPanel(
            "Time series",
            sidebarPanel(
                selectInput(
                    inputId = "state",
                    label = "State",
                    choices = state_names$state_name,
                    selected = "Washington",
                    multiple = TRUE
                ),
                selectInput(
                    inputId = "variable_time_series",
                    label = "Variable",
                    choices = variable_names$time_series,
                    selected = variable_names$time_series[1]
                ),
                checkboxInput(
                    inputId = "y_log_scale",
                    label = "log-scale Y",
                    value = FALSE
                )
            ),
            mainPanel(plotOutput("plot_time_series"))
        ),
        tabPanel(
            "Heat map",
            sidebarPanel(
                selectInput(
                    inputId = "variable_heat_map",
                    label = "Variable",
                    choices = variable_name$heat_map,
                    selected = variable_name$heat_map[1]
                )
            ),
            mainPanel(plotOutput("plot_heat_map"))
        )
    )
)


# define server -----------------------------------------------------------
server <- function(input, output) {
    get_time_series_info <- reactive({
        data <- counts[state_name %in% input$state]
        if (startsWith(input$variable_time_series, "new")) {
            data <- data[date != min(date),]
        }
        list(
            data = data,
            state = paste(input$state, collapse = " & "),
            variable = input$variable_time_series,
            y_log_scale = input$y_log_scale
        )
    })
    
    get_heat_map_info <- reactive({
        list(variable = input$variable_heat_map)
    })
    
    output$plot_time_series <- renderPlot({
        info <- get_time_series_info()
        fig <- ggplot(info$data) +
            geom_line(aes_string(x = "date", y = info$variable, color="state")) +
            ggtitle(info$state)
        if (info$y_log_scale) {
            return(fig + scale_y_log10())
        }
        fig
    })
    
    output$plot_heat_map <- renderPlot({
        info <- get_heat_map_info()
        ggplot(data_heat_map) +
            geom_polygon(
                aes_string(x = "long", y = "lat", group = "group",
                           fill = info$variable)
            )
    })
}

shinyApp(ui = ui, server = server)