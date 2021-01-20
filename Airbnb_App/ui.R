dashboardPage(skin = 'red',
    dashboardHeader(title = span(tagList(icon('search-dollar'),'Market Your Airbnb')),
                    titleWidth = 250),
    
    #SIDEBAR - ALL TABS CAN BE FOUND HERE
    dashboardSidebar(
        width = 250,
        sidebarMenu(
            menuItem('Introduction', tabName = 'intro', icon = icon('question-circle')),
            menuItem('Put it on the Map!',tabName = 'mymap',icon=icon('globe-americas')),
            menuItem('Listing Insights',tabName = 'data',icon=icon('chart-bar')),
            menuItem('About the Author', tabName = 'about', icon = icon('ghost')
                     )
            )
        ),
    
    dashboardBody(
        tabItems(
            
            #INTRODUCTION TAB
            tabItem(tabName = 'intro',
                    HTML('
                         <h1><center><b>How to Make Your Airbnb Stand Out</b></center></h1>
                         <h3><center><b>Based on 2019 NYC data insights</b></center></h3>
                         <h4><center><b>by Val Garland</b></center></h4>
                         <p><center>
                         <img src="https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260" 
                         alt="NYC Skyline" width="650px" style="float:center"/>
                         <br>
                         <br>
                         Have you ever thought of renting out your place on AirBnb, but didn&#39;t know where to start? 
                         You&#39;ve come to the right place! This app will guide you through some basic insights, such as: common prices, 
                         best listing neighbourhoods, and more!. </center></p>
                         <p><center>Below is an outline of the main sections of the app - click on the side menu to see each section
                         in detail.
                         <br>
                         <br>
                         <style>
                         table {
                         float: center;
                         }
                         th, td {
                         padding: 5px;
                         }
                         #th {
                         #text-align: center;
                         #}
                         </style>
                         <table style="width:50%"><center>
                         <tr>
                         <th>Section</th>
                         <th>Summary</th> 
                         </tr>
                         <tr>
                         <td>&#128217;  Introduction</td>
                         <td>Summary of the app (you are here now  &#128526;)</td>
                         </tr>
                         <tr>
                         <td>&#127758;  Put it on the Map!</td>
                         <td>Looking at price and review distributions per neighbourhood & borough</td>
                         </tr>
                         <tr>
                         <td>&#127968;  Listing Insights</td>
                         <td>An in-depth look at success metrics to best help you</td>
                         </tr>
                         <tr>
                         <td>&#129299;  About the Author</td>
                         <td>Short and sweet description about the author of this app</td>
                         </tr>
                         </table></center>'
                         )),
            
            #LISTINGS MAP TAB - PUT IT ON THE MAP
            tabItem(tabName = 'mymap',
                    
                    #Using leaflet for the map itself
                    #leafletOutput(outputId = 'map', height = '600px'),
                    
                    #Adding the main selection panel, where listing details can be chosen for potential hosts to review
                    absolutePanel(id = 'controls', 
                                  class = 'panel panel-default',  
                                  fixed = TRUE, 
                                  draggable = TRUE,
                                  top = 70, 
                                  left = 270, 
                                  right = 'auto', 
                                  bottom = 'auto', 
                                  width = 310, 
                                  height = 'auto',
                                  h2('Learning from Listings'),
                                  checkboxGroupInput(inputId = 'boro', label = h4('Borough'),
                                                     choices = unique(listings_data_2019$neighbourhood_group_cleansed), selected = 'Manhattan'),
                                  checkboxGroupInput(inputId = 'room', label = h4('Room Type'),
                                                     choices = unique(listings_data_2019$room_type), selected = 'Entire home/apt'),
                                  sliderInput(inputId = 'unavailability', label = h4('How Booked? (%)'),
                                              min = 0, max = 100, step = 5, value = c(70, 90)),
                                  sliderInput(inputId = 'review_score', label = h4('Review Score'),
                                              min = 0, max = 100, step = 5, value = c(80, 100)),
                                  h6(strong('NOTE: '), 'Data taken throughout 2018 and 2019 from: ',
                                     a('Inside Airbnb', href = 'http://insideairbnb.com/get-the-data.html', target = '_blank')),
                                  style = "opacity: 0.65; z-index: 10;"), #this adds opacity to the panel, making it visible on top of leaflet!!
                    
                    
                    #Using leaflet for the map itself
                    leafletOutput(outputId = 'map', height = '800px')
                    ),
            
            
            
            #LISTING INSIGHTS TAB
            tabItem(tabName = 'data',
                    fluidRow(
                        column(
                            6,
                            selectizeInput(inputId = 'hood1',
                                           label = 'Neighbourhood',
                                           choices = sort(unique(listings_data_2019$neighbourhood_cleansed))),
                            plotOutput('room_type_insight1'),
                            plotOutput('host_insight1')),
                        column(
                            6,
                            selectizeInput(inputId = 'hood2',
                                           label = 'Neighbourhood',
                                           choices = sort(unique(listings_data_2019$neighbourhood_cleansed))),
                            plotOutput('room_type_insight2'),
                            plotOutput('host_insight2'))
                        )
            ),
            
            
            #ABOUT THE AUTHOR TAB
            tabItem(tabName = 'about',
                    HTML('
                         <h1><center><b>Hello, world!  I&#39;m Val</b></center></h1>
                         <br>
                         <br>
                         <p>
                         <img src="val.JPG" align="left"
                         alt="Val at Montmartre, Paris (March 2020)" width="350px" style="float:left; padding-right:50px;"/>
                         Thanks for stopping by and I hope you collected valuable insights from my app.
                         <br>
                         <br>
                         <b>About Me</b>
                         <br>
                         I graduated from the University of Toronto in 2018 with a Bachelor&#39;s degree in Mineral Engineering. 
                         I&#39;ve worked in a gold mine in arctic Russia and found a deep passion for data through my engineering work. 
                         Having only basic data manipulation knowledge, I wanted to pursue a better, broader, and more efficient 
                         understanding of how data can manipulated and translated into a story. After all, it&#39;s a story that 
                         captures attention!
                         <br>
                         Back in December 2020, I obtained a Certificate in Data Science from the New York Science Data Academy &#127891;  
                         #goBDS023!
                         <br>
                         <br>
                         <b>Let&#39;s Connect!</b>
                         <br>
                         Here are some links to get in touch with me or if you&#39;re curious to see the behind-the-scenes of the app.
                         <br>
                         <a href="mailto:valeria.garland1@gmail.com">Email Me</a>
                         <br>
                         <a href="https://www.linkedin.com/in/valgarland/">LinkedIn</a>
                         <br>
                         <a href="https://github.com/valgarland">GitHub</a>
                         <br>
                         <a href="https://github.com/valgarland/ShinyApp">Airbnb Market - R Shiny App</a>
                         </p>
                         ')
                    )
            ),
    
            #Colours in dashboard
            tags$head(tags$style(HTML('
            .main-header .logo {
            font-family: "Montserrat", sans-serif;
            font-weight: bold;
            font-size: 18px;
            background-color: #ff5a5f !important;
            }
            .navbar {
            background-color: #ff5a5f !important;
                                      }')))
            
    )
    )
    
