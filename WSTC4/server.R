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
DF <- data.frame(codes=c('fn','ln','em','cn','af','cs','hn','tz','td','ti','ab','ke','la','ot'),
                 names=c('First name', 'Last name','E-mail','Country','Affiliation','Career stage',
                         'Twitter Handle', 'Time Zone (UTC)', 'Time Zone (UTC_DST)', 'Title', 'Abstract',
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
    return(paste('<p style="color:red">Error: the field <strong>',Fname,'</strong> is empty',sep=''))
  }else{return('')}
}

## Function that merges the selection from the language check boxes
MergeLanguage <- function(la){
  if(length(la) == 1){
    return(la)
  }else if(length(la == 2)){
    return(paste(la[1],la[2],sep=' ; '))
  }else if(length(la == 3)){
    return(paste(la[1],la[2],la[3],sep=' ; '))
  }else if(length(la) == 0){
    return('NoLang')
  }
}




### Checks the Twitter handle to make sure it starts with the @
HandleCheck <- function(hn){
  if(substr(hn,1,1) != '@'){
    return('<p style="color:red">Error: your <strong>Twitter handle</strong> must start with an "@"')
  }else{return('')}
}

### Basic e-mail check - for now just checks to make sure it has @ and .
EmailCheck <- function(em){
  if(length(grep('@',em)) == 0 | length(grep('.',em)) == 0){
    return('<p style="color:red">Error: check to make sure your <strong>E-mail</strong> is valid')
  }else{return('')}
}

### Checks the length of the Abstract
AbstractCheck <- function(ab){
  if(length(strsplit(ab,' ')[[1]]) > 25){
    return('<p style="color:red">Error: your <strong>Abstract</strong> must be less than 250 words')
  }else{return('')}
  return()
}

### Checks for minimum of one Keyword
KeywordCheck <- function(ke){
  if(strsplit(ke,' ; ')[[1]][1] == ''){
    return('<p style="color:red">Error: you need a minimum of one <strong>Keyword</strong>')
  }else{return('')}
}

### Checks to make sure a language has been selected
LanguageCheck <- function(la){
  if(la == 'NoLang'){
    return('<p style="color:red">Error: please select a <strong>Language</strong> you wish to tweet in')
  }else{return('')}
}

############################################################################################################################
### This is the control function that checks all the fields for possible errors
DataCheck <- function(fn,ln,em,af,hn,ti,ab,ke,la){
  FNcheck <- EmptyFieldCheck(fn,'fn')
  LNcheck <- EmptyFieldCheck(ln,'ln')
  EMcheck <- EmptyFieldCheck(em,'em')
  AFcheck <- EmptyFieldCheck(af,'af')
  HNcheck <- EmptyFieldCheck(hn,'hn')
  TIcheck <- EmptyFieldCheck(ti,'ti')
  ABcheck <- EmptyFieldCheck(ab,'ab')
  HANcheck <- HandleCheck(hn)
  EMAcheck <- EmailCheck(em)
  ABScheck <- AbstractCheck(ab)
  KEYcheck <- KeywordCheck(ke)
  LANcheck <- LanguageCheck(la)
  
  messagelist <- list(FNcheck,LNcheck,EMcheck,AFcheck,HNcheck,TIcheck,ABcheck,HANcheck,EMAcheck,ABScheck,KEYcheck,LANcheck)
  #messagelist <- list(FNcheck,LNcheck)
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

## The Function for counting down to April 17th,2018
Counter <-function(){
  CurTime <- format(Sys.time(),tz='UTC')
  EvTime <- as.POSIXct("2018-04-17 00:00:00",tz="UTC",format='%Y-%m-%d %H:%M:%S')
  Dtime <- difftime(EvTime,CurTime)
  mins <-  as.numeric(Dtime,units='secs') / 60
  days <- mins %/% (24 * 60)
  ct <- as.POSIXct(60 * mins, origin = "1970-01-01", tz = "UTC")
  HH <- substring(ct,12,13)
  MM <- substring(ct,15,16)
  SS <- substring(ct,18)
  return(list(days,HH,MM,SS))
}


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  
  observeEvent(input$register, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "registration")
  })
  
  
  
  output$timervalue <- renderUI({
    invalidateLater(1000, session)
    y <- Counter()
    HTML(paste('<h1 style="font-size:24pt;font-family:Roboto;font-weight:500">',as.character(y[[1]]),'D  ',as.character(y[[2]]),'H  ',as.character(y[[3]]),
               'M  ',as.character(y[[4]]),'S </h1>',sep=''))
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
                ti <- input$title
                ab <- input$abstract
                ke <- paste(input$keyword1,input$keyword2,input$keyword3,input$keyword4,sep=' ; ')
                la <- MergeLanguage(input$language)
                ot <- input$otherabs
                
                out <- DataCheck(fn,ln,em,af,hn,ti,ab,ke,la)
                
                
                if(out == '<p style="font-family:Roboto;line-weight:300;font-size:14pt">Thanks for submitting to #WSTC4</p>'){
                  
                  gs_add_row(ss,input=c(fn,ln,em,cn,af,cs,hn,tz,td,ti,ab,ke,la,ot))
                  
                  showModal(modalDialog(
                    title = "Submission Details",
                    HTML(out),
                    footer = tagList(
                      actionButton("modalok", "OK")
                    )
                  ))
                  
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


