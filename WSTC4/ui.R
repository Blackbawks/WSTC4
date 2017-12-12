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
  extendShinyjs("www/app-shinyjs.js", functions = c("updateHistory")),
  tags$head(
    tags$script(src="countdown.js"),
    tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Roboto:100,300,500")
    ),
  windowTitle = 'WSTC4 registration',
  selected = 'Home',
  theme = shinytheme('spacelab'),
  includeCSS("style.css"),
  includeCSS("countdown.css"),
  tabsetPanel(
    id = "tabs",
    
    tabPanel('Home',
             fluidRow(class='homrow1',
                      column(12,
                             tags$a(img(src='WSTC4_header_white_light.png',width='65%'),href='https://twitter.com/search?f=tweets&vertical=default&q=%23WSTC4&src=typd&lang=en')
                      ),
                      column(4,offset=8,
                             fluidRow(
                               column(12,class='timer',
                                      h1('Countdown to #WSTC4')
                                      ),
                               column(12,HTML("<div class='countdown' data-date='2018-04-17'></div>"))     
                             )
                             
                             )
             ),

             fluidRow(class='homrow3',
               column(4,class='col-xs-6 col-md-3 col-lg-3',
                      tags$button(
                        id = "register",
                        type="button",
                        class = "btn action-button shiny-bound-input",
                        img(src = "register_now.png", width = "100%")
                      )
               ),
               column(3,class='col-xs-6 col-md-3 col-lg-3',
                      tags$button(
                        id = "info",
                        type="button",
                        class = "btn action-button shiny-bound-input",
                        img(id='bb',src="BrownBoob.png",width='100%')
                      )),
               column(3,class='col-xs-6 col-md-3 col-lg-3',
                      tags$a(
                        img(id='bb',src="img-thing.png",width='100%'),
                        href='https://twitter.com/seabirders'
                      ))
               
                       

             ),
             fluidRow(class='footer',
                      column(2,class='col-xs-3 col-lg-1 col-md-2',
                             img(src='Blackbawks.png',width='100%')
                      ),
                      column(2,style='margin-top:40px;',class='col-xs-3',
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
                      column(8,class='regrow2Col col-xs-10 col-xs-offset-1', offset=2,
                          fluidRow(
                            column(12,h1('Personal Information')),
                            column(6,
                                   textInput("first","First Name:")
                            ),
                            column(6,
                                   textInput("last","Last Name:")
                            ),
                            column(6,
                                   textInput("email","E-mail: (xxxxx@xxxxx.xxx format)")
                            ),
                            column(6,
                                   selectInput("country", "Country:",
                                               as.character(countrycode_data$country.name.en))
                            ),
                            column(12,
                                   textInput("affiliation","Affiliation:")
                            ),
                            column(6,
                                   selectInput("careerstage","Position:",
                                               c('Student','Early career scientist (<5 years since graduation)','Academia',
                                                 'Government','Non-profit','Field Technician'))
                            ),
                            column(6,
                                   textInput("handle","Twitter handle: (make sure to add '@' as the first character)",width='75%')
                            ),
                            column(8,
                                   selectInput("timezone", "Time Zone:",
                                               as.character(x$OlsonName)),
                                   p(htmlOutput('utcoff'))       
                            ),
                            column(12,
                                   checkboxGroupInput('socmedia','Which social media platforms do you use (optional)?',
                                                      choices = list('Facebook','Instagram','Reddit','Google+',
                                                                     'Tumblr','Snapchat','Pinterest','ResearchGate','LinkdIn'))
                            )
                          )                           
                             
                      )       
               
               
                      
             ),
             fluidRow(class='regrow3',
                      column(12,h1('Abstract Information')),
                      column(12,textInput("title","Title:")),
                      column(12,textAreaInput("abstract","Abstract:",placeholder='250 words max please')),
                      column(12,selectInput("session","Which session would you like to be in?:",
                                            c('Behavior', 'Breeding Biology','Climate Change','Conservation Biology',
                                              'Contaminants and Marine Debris','Fisheries','Foraging Ecology',
                                              'Genetics','Management, Policy and Planning','Non-breeding Biology',
                                              'Physiology','Population Biology','Tools and Techniques','Tracking and Distribution'))),
                      
                      
                      column(12,h2("Please enter up to 4 keywords (hashtags) that describe your work (Minimum ONE keyword)")),
                      
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
               column(2,class='col-xs-3 col-lg-1 col-md-2',
                      img(src='Blackbawks.png',width='100%')
               ),
               column(2,style='margin-top:40px;',class='col-xs-3',
                      HTML('<p style="vertical-align:bottom">site created by <a href="http://www.blackbawks.net">Black bawks data science</a></p>')
               )
             )
             
    ),
    tabPanel("Rules and Guidelines",value='information',
             fluidRow(class='inforow1',
                      column(4,offset=4,class='inforow1col',
                             img(src='WSTC4_header_white_light.png',width='100%')
                      )),
             fluidRow(
                column(8,offset=2,
                       h1('We are excited to announce the 4th annual 
                          World Seabird Twitter Conference #WSTC4 This 
                          is an opportunity to participate in science and 
                          seabird research around the world from the comfort 
                          of your home, office, or field station', style='font-weight:300'),
                       hr(),
                       h2('Past WSTCs',style='font-size:20pt'),
                       HTML("
                            <p style='font-size:18pt;font-weight:300'>The World Seabird Twitter Conference has been a success three years running. 
                            Since February 2017, the hashtag #WSTC3 was tweeted 7,895 times by 1,781 people 
                            from 52 countries, seen by over 3.9 million people, over 11 million times</p>
                            "),
                       hr()
                ),  
               column(8, offset=2,
                      h2('Rules'),
                      HTML(
                        '<ol>
                            <li>You must have a twitter account/handle</li>
                            <li>Register between <strong>Jan 15 - Feb 15, 2018</strong></li>
                            <li>Your presentation can be a maximum of 4 tweets (each tweet is 280 characters)</li>
                            <li>Every tweet needs to be numbered (1-4 and start with the hashtag #WSTC4 and your session (e.g., 1 #WSTC4 #ClimateChange1)</li>
                            <li>Your tweets should follow the logic of a conference presentation (intro, methods, results, summary) </li>
                            <li>Links to extra text describing your research are NOT ALLOWED</li>
                            <li>Pictures and graphs are encouraged</li>
                            <li>Postings will be curated and organized after the competition (see previous years for examples)</li>
                        </ol>'
                      ),
                      hr(),
                      h2('Guidelines'),
                      HTML('<ul>
                           <li>TIMING: You will be assigned a time slot (15min) in which to tweet your research. We will be assigning these times based on your geographic location so please ensure you give us the correct time zone information when your register!&nbsp;</li>
                           <li>PLANNING: It is best to draft your tweets ahead of time to avoid issues during the event. Make sure your account is public and tweets are not protected so they are visible to everyone</li>
                           <liFOLLOWING ALONG: Follow the event with hashtag #WSTC4 and keep up to date by following @Seabirders. There are outside platforms such as TweetDeck which aid in following along. For example, you can set up threads to show only&nbsp;tweets which contain certain hashtags like #WSTC4. You can also subscribe to the twitter list of participants which we will publish before the conference</li>
                           <li>PARTICIPATION: You are encouraged to participate with discussion and questions. When asking a question, please direct the tweet at the individual using their handle&nbsp;and use the hashtag #WSTC4&nbsp;<br />Example: @Seabirders #WSTC4 How easy is it to use twitter to participate in this great event?</li>
                           </ul>'),
                      hr(),
                      h2('Tips and Tricks'),
                      HTML("<ul>
                            <li>If you are new to twitter, it would be worthwhile to follow some of the larger 
                                  seabird groups - this will help you get an idea of tweeting best practices, 
                                  but also will help you to connect with other researchers in the field<br />Suggestions: 
                                  @Seabirders @PacificSeabirds @TheSeabirdGroup @ LAseabirdgroup @AUS_NZ_Seabirds @Seabird_SOS</li>
                            <li>Space out your tweets, but not too much- you will have 14 minutes to present your 6 tweets. 
                                  Our advice is one tweet per minute - allowing plenty of time&nbsp;&nbsp;for comments and questions</li>
                            <li>Follow topic specific presentations - when we are introducing talks, we will use appropriate topic tags, 
                                  making it easy for you to follow presentations of particular interest.</li>
                            <li>Get creative! The strict character limit forces you to be creative with how you present your work. 
                                  Use graphics, photos, infographics and more to get people's attention</li>
                            </ul>"),
                      img(src='EwanTweetPic.jpg'),
                      HTML("<ul>
                             <li>Links! Your presentation is a great opportunity to showcase your recent work, whether it is a 
                                  publication or a poster. Shameless self promotion never hurt anyone!</li>
                            </ul>"),
                      img(src='ChrisTweetPic.jpg'),
                      HTML("<ul>
                             <li>Interact! Your participation (questions, comments, retweets) will likely engage more people in 
                                  your own presentation. Spend some time looking through the conference manual and noting which 
                                  presentations you would like to see. Each session is separated by a break - use these to reach out
                                  if you didn't manage to do so during the session. Always remember to use the #WSTC4 hashtag to 
                                  allow others to see and join the conversation!</li>
                            </ul>"),
                      img(src='BethTweetPic.jpg'),
                      HTML("<ul>
                             <li>You can help draw in a very large audience if you use hashtags in a clever way. 
                                  Many people follow hashtags such as #ornithology and #seabirds and depending on your topic of 
                                  presentation you may be able to draw in a much larger audience than just the 
                                  conference attendees. For inspiration of useful hashtags for ornithologists, check out the list below</li>
                           </ul>"),
                      img(src='RuediTweetPic.jpg'),
                      hr(),
                      HTML("<table class='table table-bordered'>
                              <tr>
                                <td>#Seabirds</td>
                                <td>#SeabirderSaturday</td>
                                <td>#Birdbanding</td>
                                <td>#Birdmigration</td>
                              </tr>
                              <tr>
                                <td>#Migration</td>
                                <td>#MigratorySpecies</td>
                                <td>#Ornithology</td>
                                <td>#Petrelhead</td>
                              </tr>
                              <tr>
                                <td>#TeamAuk</td>
                                <td>#TeamGull</td>
                                <td>#TeamPetrel</td>
                                <td>#TeamSkua</td>
                              </tr>
                          </table>"),
                      hr(),                              
                      h2('FAQs'),
                      HTML("
                           <h3><strong>What is a twitter conference?</strong></h3>
                           <h4>A Twitter conference is a social media event that occurs from the comfort of your living room!! (or wherever you might be currently seated). This event is meant to bring together seabird scientists from around the world in an online setting to encourage communication and collaboration, particularly when costs of travel are currently high.</h4>
                           <h3><strong>How do I participate?</strong></h3>
                           <h4>Start by getting a twitter account if you don't already have one - you can get one easily at http://www.twitter.com. If you are interested in being a spectator only, you only need to search for the twitter hashtag #WSTC4 to see all posts related to the conference. If you want to present, please register and submit an abstract before the deadline.</h4>
                           <h3><strong>How much time am I expected to spend on this if I participate?</strong></h3>
                           <h4>After the signup closes, everyone will be allocated a 15 minute time slot for you to present your 6 tweets. It is vital that you are available during your presentation time slot to present and then answer potential questions you might receive, indeed just like at any conference. After signup closes, we will circulate a list of abstracts and time slots so that you can pinpoint which presentations you might want to catch. You are encouraged to participate is much or as little as you would like.</h4>
                           <h3><strong>What if I am unable to present during my time slot?</strong></h3>
                           <h4>If you are unable to present during your allocated time slot, you can schedule your tweets (using services such as Tweetdeck, Hootsuite, or Buffer) so that they get posted automatically without you having to be online.</h4>
                           <h3><strong>What if I don't know how to use twitter?</strong></h3>
                           <h4>The key is experience - no better way to learn about twitter than on the site. There are also many guides on how to use Twitter online, including by:</h4>
                              <ul style='font-size:18pt'>
                                  <li>British Ornithology Union:&nbsp;<a href='http://www.bou.org.uk/tweeting&shy;better&shy;1/'>http://www.bou.org.uk/tweeting&shy;better&shy;1/</a></li>
                                  <li>Twitter:&nbsp;<a href='https://www.youtube.com/watch?v=J0xbjIE8cPM'>https://www.youtube.com/watch?v=J0xbjIE8cPM</a></li>
                              </ul>")
                      

             ))
  
    )
    
  )
  
  

  )
)


