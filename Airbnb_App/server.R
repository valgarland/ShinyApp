function(input, output, session) {

    #LISTINGS ON MAP
    #Making the absolutePanel() portion reactive
    map_listings = reactive({
        listings_data_2019 %>% 
            filter(neighbourhood_group_cleansed %in% input$boro &
                                          room_type %in% input$room &
                                          ave_unavailability >= input$unavailability[1] &
                                          ave_unavailability <= input$unavailability[2] &
                                          review_scores_rating >= input$review_score[1] &
                                          review_scores_rating <= input$review_score[2])
    })
    
    #Adding the physical map to the tab
    output$map = renderLeaflet({
        leaflet() %>%
            addProviderTiles("CartoDB.Positron") %>%
            #addLegend("bottomright", pal = colour_scale(room_type), values = room_type, title = 'Listing Type') %>%
            setView(lng = -74.0059, lat = 40.7128, zoom = 15)
    })
    
    #Making circle markers with the reactive portion from absolutePanel()
    #NOTE: Two groups will be present here, individual markers and area clusters
    observe({
        proxy = leafletProxy('map', data = map_listings()) %>%
            clearMarkerClusters() %>%
            clearMarkers() %>%
            addCircleMarkers(lng = ~longitude, lat = ~latitude, radius = 1.5, 
                             color = ~colour_scale(room_type),
                             group = 'Individual Listing',
                             popup = ~paste('Room Type: ', room_type, '<br>',
                                            'Rating: ', review_scores_rating, '<br>',
                                            'Booked %: ', ave_unavailability, '<br>',
                                            'Price: ', price)
                            ) %>%
            addCircleMarkers(lng = ~longitude, lat = ~latitude, clusterOptions = markerClusterOptions(),
                             group = 'Listings By Area',
                             popup = ~paste('Room Type: ', room_type, '<br>',
                                            'Rating: ', review_scores_rating, '<br>',
                                            'Booked %: ', ave_unavailability, '<br>',
                                            'Price: ', price)
                            ) %>%
            
            #Select whether you want individual or cluster listings
            addLayersControl(
                baseGroups = c("Individual Listing","Listings by Area"),
                options = layersControlOptions(collapsed = FALSE)
            )
    })
    
    
    
    #INSIGHTS DATA 
    #Making input reactive
    insights_data1 = reactive(
        listings_data_2019 %>%
            filter(neighbourhood_cleansed==input$hood1)
    )
    
    #Room type frequency
    output$room_type_insight1 = renderPlot(
        insights_data1() %>%
            mutate(index=1) %>%
            group_by(room_type) %>%
            summarise(sum=sum(index)) %>%
            ggplot(aes(x = room_type, y=sum)) + 
            geom_col(fill = '#ff5a5f') +
            geom_text(aes(label = sum))+
            theme(panel.background = element_rect('white',fill=NA), panel.border = element_rect('black',fill=NA)) +
            xlab('')+
            ylab('')+
            ggtitle('Listing Type Frequency')
            
    )
    
    output$host_insight1 = renderPlot(
        insights_data1() %>% 
            group_by(room_type) %>%
            summarise(ave=mean(calculated_host_listings_count)) %>%
            ggplot(aes(x = room_type, y = ave))+
            geom_col(fill = '#F9E79F')+
            #geom_text(aes(label = ave)+
            theme(panel.background = element_rect('white',fill=NA), panel.border = element_rect('black',fill=NA))+
            xlab('')+
            ylab('')+
            ggtitle('Number of Listings per Host')
    )

    
    #Repeated graphs for comparing neighbourhoods for host (ie: which is better for host)
    #Making input reactive
    insights_data2 = reactive(
        listings_data_2019 %>%
            filter(neighbourhood_cleansed==input$hood2) %>%
            mutate(index=1)
    )

    
    #Room type frequency
    output$room_type_insight2 = renderPlot(
        insights_data2() %>%
            mutate(index=1) %>%
            group_by(room_type) %>%
            summarise(sum=sum(index)) %>%
            ggplot(aes(x = room_type, y=sum)) + 
            geom_col(fill = '#ff5a5f') +
            geom_text(aes(label = sum))+
            theme(panel.background = element_rect('white',fill=NA), panel.border = element_rect('black',fill=NA)) +
            xlab('')+
            ylab('')+
            ggtitle('Listing Type Frequency')
        )
    
    output$host_insight2 = renderPlot(
        insights_data2() %>% 
            group_by(room_type) %>%
            summarise(ave=mean(calculated_host_listings_count)) %>%
            ggplot(aes(x = room_type, y = ave))+
            geom_col(fill = '#F9E79F')+
            #geom_text(aes(label = ave)+
            theme(panel.background = element_rect('white',fill=NA), panel.border = element_rect('black',fill=NA))+
            xlab('')+
            ylab('')+
            ggtitle('Number of Listings per Host')
    )
    
    
    
}