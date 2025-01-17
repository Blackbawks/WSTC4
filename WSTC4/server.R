#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(googlesheets)

options(shiny.sanitize.errors = FALSE)

x <- read.csv("TZs.csv")

### This is a dictionary data frame to look up field values 
DF <- data.frame(codes=c('fn','ln','em','cn','af','cs','hn','tz','td','ti','ab','se','ke','la','ot'),
                 names=c('First name', 'Last name','E-mail','Country','Affiliation','Career stage',
                         'Twitter Handle', 'Time Zone (UTC)', 'Time Zone (UTC_DST)', 'Title', 'Abstract','Session',
                         'Keywords','Languages','Other Abstracts'))

### Function for getting the UTC values for submission to form
GETutcSubmit <- function(VAL){
  utco <- paste('UTC',substr(as.character(getTZ(VAL)[[1]]),1,3),sep=' ')
  utcoDST <- paste('UTC',substr(as.character(getTZ(VAL)[[2]]),1,3),sep=' ')
  return(list(utco,utcoDST))
}

### A generic function for checking if a text field is empty
EmptyFieldCheck <- function(Field,code){
  Fname <- DF$names[which(DF$codes == code)]
  if(nchar(Field) == 0){
    return(paste('<p class="error">Error: the field <strong>',Fname,'</strong> is empty',sep=''))
  }else{return('')}
}

## Function that merges the selection from the language check boxes
MergeSelect <- function(X){
  if(length(X) == 0){
    return('NoLuck')
  }else if(length(X) > 0){
    return(paste(X,collapse='; '))
  }
}



### Checks the Twitter handle to make sure it starts with the @
HandleCheck <- function(hn){
  if(substr(hn,1,1) != '@'){
    return('<p class="error">Error: your <strong>Twitter handle</strong> must start with an "@"')
  }else{return('')}
}

### Basic e-mail check - for now just checks to make sure it has @ and .
EmailCheck <- function(em){
  if(length(grep('@',em)) == 0 | length(grep('.',em)) == 0){
    return('<p class="error">Error: check to make sure your <strong>E-mail</strong> is valid')
  }else{return('')}
}

### Checks the length of the Abstract
AbstractCheck <- function(ab){
  if(length(strsplit(ab,' ')[[1]]) > 25){
    return('<p class="error">Error: your <strong>Abstract</strong> must be less than 250 words')
  }else{return('')}
  return()
}

### Checks for minimum of one Keyword
KeywordCheck <- function(ke){
  if(strsplit(ke,' ; ')[[1]][1] == ''){
    return('<p class="error">Error: you need a minimum of one <strong>Keyword</strong>')
  }else{return('')}
}

### Checks to make sure a language has been selected
LanguageCheck <- function(la){
  if(la == 'NoLang'){
    return('<p class="error">Error: please select a <strong>Language</strong> you wish to tweet in')
  }else{return('')}
}

############################################################################################################################
### This is the control function that checks all the fields for possible errors
DataCheck <- function(fn,ln,em,af,hn,ti,ab,se,ke,la){
  FNcheck <- EmptyFieldCheck(fn,'fn')
  LNcheck <- EmptyFieldCheck(ln,'ln')
  EMcheck <- EmptyFieldCheck(em,'em')
  AFcheck <- EmptyFieldCheck(af,'af')
  HNcheck <- EmptyFieldCheck(hn,'hn')
  TIcheck <- EmptyFieldCheck(ti,'ti')
  ABcheck <- EmptyFieldCheck(ab,'ab')
  SEcheck <- EmptyFieldCheck(se,'se')
  HANcheck <- HandleCheck(hn)
  EMAcheck <- EmailCheck(em)
  ABScheck <- AbstractCheck(ab)
  KEYcheck <- KeywordCheck(ke)
  LANcheck <- LanguageCheck(la)
  
  messagelist <- list(FNcheck,LNcheck,EMcheck,AFcheck,HNcheck,TIcheck,ABcheck,HANcheck,EMAcheck,ABScheck,KEYcheck,LANcheck)
  
  if(length(grep('<p*',messagelist)) == 0){
    return('<p style="font-family:Roboto;line-weight:300;font-size:14pt">Thanks for submitting to #WSTC4</p>')
  }else{
    message <- paste(messagelist,collapse='</p>')
    return(message)  
  }
  
  
}

#######################################################################################################

### Converts Olson Names to UTC based on the spreadsheet TZs.csv
getTZ <- function(Olson){
  utc <- x$UTC[which(x$OlsonName == Olson)]
  utcoff <- x$UTC_offset_DST[which(x$OlsonName == Olson)]
  return(list(utc,utcoff))
}



# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  values <- reactiveValues(
    
    # variable to keep track of whether or not the tab switching is manual (by the
    # user) or automatic (restoring the app's state on initialization or prev/next buttons)    
    autoNavigating = 0,
    
    # search string
    searchString = ""
  )
  
  
  observeEvent(session$clientData$url_search, {
    # if there is a history in the URL, restore the state
    if (nchar(session$clientData$url_search) > 1) {
      # when the app starts, the input$navbar gets triggered, but we don't
      # want to trigger the navigation function because the user didn't actively
      # navigate anywhere
      values$autoNavigating <- values$autoNavigating + 1
      
      restore(session$clientData$url_search)
    }
  })
  
  # restore the Shiny app's state based on the URL
  restore <- function(qs) {
    data <- parseQueryString(qs)
    
    if (!is.null(data[['page']])) {
      # we're about to change tabs programatically, so don't trigger the
      # navigation function
      values$autoNavigating <- values$autoNavigating + 1
      
      # change to the correct tab
      updateTabsetPanel(session, "navbar", data[['page']])
      
      # if the given tab has some more information we wnat to initialize,
      # do it here
      if (data[['page']] == "search") {
        if (!is.null(data[['query']])) {
          values$searchString <- data[['query']]
          updateTextInput(session, "text", value = data[['query']])
        }
      }
    }
  }
  
  # when the user changes tabs, save the state in the URL
  observeEvent(input$navbar, {
    if (values$autoNavigating > 0) {
      values$autoNavigating <- values$autoNavigating - 1
      return()
    }
    
    if (input$navbar == "search") {
      shinyjs::js$updateHistory(page = "search", query = values$searchString)
    } else {
      shinyjs::js$updateHistory(page = input$navbar)
    }
  })
  
  # when the user clicks prev/next buttons in the browser, restore the state
  observeEvent(input$navigatedTo, {
    restore(input$navigatedTo)
  })
  
  
  ###############################################################
  
  
  
  
  
  observeEvent(input$register, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "registration")
  })
  
  observeEvent(input$info, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "information")
  })
  
  
  observeEvent(input$timezone, {
    output$utcoff <- renderUI({
      utco <- substr(as.character(getTZ(input$timezone)[[1]]),1,3)
      utcoDST <- substr(as.character(getTZ(input$timezone)[[2]]),1,3)
      HTML('<p>your timezone offset is: UTC <strong>',utco, '</strong> and UTC <strong>',utcoDST, '</strong> for daylight savings</p>',sep='')
    })
    
  })
  
  observeEvent(input$submit,{
                output$success <- renderUI({HTML('<p style="font-size:14pt;color:red">Submitting data...</p>')})
                fn <- input$first
                ln <- input$last
                em <- input$email
                cn <- input$country
                af <- input$affiliation
                cs <- input$careerstage
                hn <- input$handle
                tz <- GETutcSubmit(input$timezone)[[1]]
                td <- GETutcSubmit(input$timezone)[[2]]
                sm <- MergeSelect(input$socmedia)
                ti <- input$title
                ab <- input$abstract
                se <- input$session
                ke <- paste(input$keyword1,input$keyword2,input$keyword3,input$keyword4,sep=' ; ')
                la <- MergeSelect(input$language)
                ot <- input$otherabs
                
                out <- DataCheck(fn,ln,em,af,hn,ti,ab,se,ke,la)
                
                #print(out)
                if(out == '<p style="font-family:Roboto;line-weight:300;font-size:14pt">Thanks for submitting to #WSTC4</p>'){
                  
                  showModal(modalDialog(
                    title = "Submission Details",
                    HTML(out),
                    footer = tagList(
                      actionButton("modalok", "OK")
                    )
                  ))
                  gs_add_row(ss,input=c(fn,ln,em,cn,af,cs,hn,tz,td,sm,ti,ab,se,ke,la,ot))
                }else{
                  
                  showModal(modalDialog(
                    title = "Submission Details",
                    HTML(out),
                    footer = tagList(
                      actionButton("goback","Go Back")
                    )
                  ))
                }
                
                
               
               #
               
               
               })
  observeEvent(input$modalok,{
    removeModal()
    js$refresh();
  })
  observeEvent(input$goback,{
    removeModal()
    output$success <- renderUI({HTML('')})
  })
  
  
  
})


