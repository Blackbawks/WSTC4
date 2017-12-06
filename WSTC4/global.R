
#filler <- matrix("-", nrow = 1, ncol = 14,
#                 dimnames = list(NULL,c('First','Last','Email','Country','Affiliation','Career','Handle',
#                                        'TimeZone','TimeZoneDST','Title','Abstract','Keywords','Language','OtherAbs')))

## prepare the OAuth token and set up the target sheet:
##  - do this interactively
##  - do this EXACTLY ONCE

 #shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
 #saveRDS(shiny_token, "shiny_app_token.rds")
 #ss <- gs_new("WSTC4_Registration",
 #             row_extent = 1, col_extent = 14, input = filler)
 #ss$sheet_key # "1CQ-KvZLTvJTyuoocpGU-3gwLYI37MNfmZNdZlqlZuv0"

## if you version control your app, don't forget to ignore the token file!
## e.g., put it into .gitignore

googlesheets::gs_auth(token = "shiny_app_token.rds")
sheet_key <- "1MNdoeNY9ClGL5AFRZ-LYDaS8PB4O5l4XzotBAiSWeMM"
#sheet_key <- "1CQ-KvZLTvJTyuoocpGU-3gwLYI37MNfmZNdZlqlZuv0"
ss <- googlesheets::gs_key(sheet_key)
options(shiny.sanitize.errors = FALSE)