dashboardPage(
    dashboardHeader(title = 'Airbnb Market in NYC'),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem('Introduction', tabName = 'intro', icon = icon('question-circle')),
            menuItem('Listing Insights',tabName = 'map',icon=icon('airbnb')),
            menuItem('Data',tabName = 'data',icon=icon('database')),
            menuItem('COVID-19 Impact', tabName = 'covid', icon = icon('virus')),
            menuItem('About the Creator', tabName = 'aboutme', icon = icon('ghost')
                     )
            )
        ),
    
    dashboardBody(
    
    #Colours in dashboard
    #tags$head(tags$style(HTML(
    #'.content-wrapper {background-color: #fff;}
    #.main-sidebar {background-color: #FAF5F4;}
    #.sidebar-menu {background-color: #FBEEE6;}'
    #                          )
    #                     )
    #          )
    )
)
