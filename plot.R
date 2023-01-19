battles <- read_csv("battles_backup.csv")

firstDf <- as.data.frame(battles$First)
secondDf <- as.data.frame(battles$Second)
colnames(firstDf) <- c("Combatant")
colnames(secondDf) <- c("Combatant")
combatantsDf <- rbind(firstDf,secondDf)
countedDf <- combatantsDf %>% count(Combatant)

countedDf <- countedDf %>% filter(n > 2)

battles <- battles %>% filter(First %in% countedDf$Combatant) %>% filter(Second %in% countedDf$Combatant)

chordDiagram(battles, annotationTrack = "grid", 
             preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(battles))))))
# we go back to the first track and customize sector labels
circos.track(track.index = 1, panel.fun = function(x, y) {
  circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
              facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
}, bg.border = NA) # here set bg.border to NA is important