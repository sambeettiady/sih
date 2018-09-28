dashboardPage(
    dbHeader <- dashboardHeader(title = "Ministry of Power"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Hourly Prediction Report", tabName = "dashboard1"),
            menuItem("View Historical Load", tabName = "dashboard2"),
            menuItem("View Historical Availability", tabName = "dashboard3"),
            menuItem("Daily Data - Maharashtra", tabName = "dashboard4")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem("dashboard1",
                    fluidRow(
                        column(width = 6,selectInput('state1',label = 'Select Region:',choices = c('Overall',regvars),selected = 'Overall')),
                        column(width = 6,selectInput('load_type1',label = 'Select Load Type:',choices = c('Overall','Domestic','Commercial','Agricultural','Industrial','Others'),selected = 'Overall'))
                    ),
                    fluidRow(
                        valueBoxOutput("pred_demand",width = 6),
                        valueBoxOutput("pred_supply",width = 6)
                    ),
                    fluidRow(
                        valueBoxOutput("dygraph1_text",width = 12)
                    ),
                    fluidRow(
                        dygraphOutput("dygraph1")
                    )
                ),
            tabItem("dashboard2",
                    fluidRow(
                        column(width = 4,selectInput('state2',label = 'Select Region:',choices = c('Overall',regvars),selected = 'Overall')),
                        column(width = 4,selectInput('load_type2',label = 'Select Load Type:',choices = c('Overall','Domestic','Commercial','Agricultural','Industrial','Others'))),
                        column(width = 4,dateRangeInput('dateRange1',label = 'Date Range Input:',
                                                        start = min_date, end = max_date))
                    ),
                    fluidRow(
                        valueBoxOutput("dygraph2_text",width = 12)
                    ),
                    fluidRow(
                        dygraphOutput("dygraph2")
                    )
            ),
            tabItem("dashboard3",
                    fluidRow(
                        column(width = 4,selectInput('state3',label = 'Select Region:',choices = c('Overall',regvars),selected = 'Overall')),
                        column(width = 4,selectInput('energy_type',label = 'Select Energy Type:',choices = c('Solar & Wind','Wind','Solar'))),
                        column(width = 4,dateRangeInput('dateRange2',label = 'Date Range Input:',
                                                        start = min_date, end = max_date))
                    ),
                    fluidRow(
                        valueBoxOutput("dygraph3_text",width = 12)
                    ),
                    fluidRow(
                        dygraphOutput("dygraph3")
                    )
            ),
            tabItem("dashboard4",
                    fluidRow(
                        column(width = 6,selectInput('state4',label = 'Select Region:',choices = c('Overall','Maharashtra'),selected = 'Maharashtra'))
                    ),
                    fluidRow(
                        valueBoxOutput("dygraph4_text",width = 12)
                    ),
                    fluidRow(
                        dygraphOutput("dygraph4")
                    )
            )
        )
    )
)