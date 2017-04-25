#

usePackage <- function(p) 
{
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  require(p, character.only = TRUE)
}
usePackage("RMySQL")
usePackage("XLConnect")
setwd("~/pCloud Sync/work/2017/EarlyChildhoodDevelopment")
dfMomConnect <-read.csv("all_ending_subs.csv")

head(dfMomConnect)

con <- dbConnect(MySQL(), user="root", 
                 dbname="charles", host="localhost",client.flag=CLIENT_MULTI_STATEMENTS)
dbListTables(con)
dbWriteTable(con,"momconnect_2month",dfMomConnect,overwrite=T)
dbDisconnect(con)
