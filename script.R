library(tidyverse)
library(rvest)


url <- "https://marvelcinematicuniverse.fandom.com/wiki/Category:Wars"
page <- read_html(url)
links <- page %>% html_nodes(".category-page__member-link") %>% html_attr("href")
links <- as.data.frame(links)
colnames(links) <- c("Link")
links <- cbind(links,War=NA)
links$War <- page %>% html_nodes(".category-page__member-link") %>% html_attr("title")
links$Link <- paste("https://marvelcinematicuniverse.fandom.com",links$Link,sep="")

battles <- as.data.frame(matrix(ncol=3,nrow=0))
colnames(battles) <- c("First","Second","War")

returnCombatants <- function(url,warName) {
  page <- read_html(url)
  
  first <- page %>% html_nodes("td[data-source=side1]") %>% html_nodes("a") %>% html_attr("title")
  second <- page %>% html_nodes("td[data-source=side2]") %>% html_nodes("a") %>% html_attr("title")
  
  combatDf <- as.data.frame(matrix(ncol=3,nrow=0))
  colnames(combatDf) <- c("First","Second","War")
  
  for (i in first) {
    for (j in second) {
      combatRow <- as.data.frame(matrix(ncol=3,nrow=1))
      colnames(combatRow) <- c("First","Second","War")
      combatRow$First <- i
      combatRow$Second <- j
      combatRow$War <- warName
      combatDf <- rbind(combatDf,combatRow)
    }
  }
  
  combatDf <- unique(combatDf)
  
  return(combatDf)
}

for (i in 1:length(links$Link)) {
  row <- returnCombatants(links[i,]$Link,links[i,]$War)
  battles <- rbind(battles,row)
  message(i)
}

