#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(countrycode)
library(shinyjs)
library(V8)
options(shiny.sanitize.errors = FALSE)

jscode <- "shinyjs.refresh = function() { history.go(0); }"

x <- read.csv("TZs.csv")

shinyUI(fluidPage(
  useShinyjs(),
  extendShinyjs(text = jscode),
  windowTitle = 'WSTC4 registration',
  selected = 'Home',
  tags$head(
    tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Roboto:100,300,500")
  ),
  theme = shinytheme('spacelab'),
  includeCSS("style.css"),
  
  tabsetPanel(
    id = "tabs",
    
    tabPanel('Home',
             fluidRow(class='homrow1',
                      column(12,
                             img(src='WSTC4_header_white_light.png',width='65%')
                      )
                      
             ),
             
             absolutePanel(top="63%",class='homrow2',
                           fluidRow(
                             column(12,
                                    htmlOutput('timervalue')
                             )
                           )              
             ),
             fluidRow(class='homrow3',
               column(8,
                      tags$button(
                        id = "register",
                        type="button",
                        class = "btn action-button shiny-bound-input",
                        img(src = "register_now.png", width = "450px")
                      )
               ),
               column(4,
                      img(id='bb',src="BrownBoob.png",width='75%')) 

             ),
             fluidRow(class='footer',
                column(1,
                       img(src='Blackbawks.png',width='100%')
                       ),
                column(2,style='margin-top:40px;',
                       HTML('<p style="vertical-align:bottom">site created by <a href="http://www.blackbawks.net">Black bawks data science</a></p>')
                       )
             )
             
             
             
             
    ),
    
    
    
    tabPanel(title = "Registration",value='registration',
             fluidRow(class='regrow1',
                      
                      column(3,
                             img(src='WSTC4_logo_only.png',width='45%')
                             #h2('Register here for the 4th annual World Seabird Twitter Conference (#WSTC4)')
                      ),
                      column(4,
                             h1('Please register below'))
                      ),
             
             fluidRow(class='regrow2',
                      column(8,class='regrow2Col', offset=2,
                          fluidRow(
                            column(12,h1('Personal Information')),
                            column(6,
                                   textInput("first","First Name:")
                            ),
                            column(6,
                                   textInput("last","Last Name:")
                            ),
                            column(6,
                                   textInput("email","E-mail:")
                            ),
                            column(6,
                                   selectInput("country", "Country:",
                                               as.character(countrycode_data$country.name.en))
                            ),
                            column(12,
                                   textInput("affiliation","Affiliation:")
                            ),
                            column(6,
                                   selectInput("careerstage","Career stage:",
                                               c('Undergraduate','Masters Student','PhD Student',
                                                 'Postdoc','Professor (<5 years)', 'Professor (>=5 years)',
                                                 'Manager','Analyst','Lab technician','Field technician',
                                                 'Enthusiast'))
                            ),
                            column(6,
                                   textInput("handle","Twitter handle:",width='75%')
                            ),
                            column(8,
                                   selectInput("timezone", "Time Zone:",
                                               as.character(x$OlsonName)),
                                   p(htmlOutput('utcoff'))       
                            )
                          )                           
                             
                      )       
               
               
                      
             ),
             fluidRow(class='regrow3',
                      column(12,h1('Abstract Information')),
                      column(12,textInput("title","Title:")),
                      column(12,textAreaInput("abstract","Abstract:",width='200%',placeholder='250 words max please')),
                      
                      column(12,h2("Please enter up to 4 keywords that describe your work (Minimum ONE keyword)")),
                      
                      column(3,textInput("keyword1",'')),
                      column(3,textInput("keyword2",'')),
                      column(3,textInput("keyword3",'')),
                      column(3,textInput("keyword4",'')),
                      
                      column(4,
                             checkboxGroupInput('language','Which language would you like to tweet?',choices = list('English','French','Spanish'))
                      ),
                      column(4,
                             radioButtons('otherabs','Have you already or do you plan to submit another abstract?',choices = list('Yes','No'))
                      ),
                      column(12,hr()),
                      column(12,
                             actionButton('submit','Submit Abstract',class='btn-lrg btn-info')
                             ),
                      column(12,htmlOutput('success'))
             ),
             fluidRow(class='footer',
               column(1,
                      img(src='Blackbawks.png',width='100%')
               ),
               column(2,style='margin-top:40px;',
                      HTML('<p style="vertical-align:bottom">site created by <a href="http://www.blackbawks.net">Black bawks data science</a></p>')
               )
             )
             
    ),
    tabPanel("More information",
             h1('contact us here')
    )
    
  )
  
  

  )
)








