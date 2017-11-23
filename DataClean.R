CEmi<-read.table("CO2EmissionsData.txt", header=TRUE,as.is = TRUE)
Dist<-read.table("FlightData.txt",header=TRUE,as.is = TRUE)
for(i in 1:length(Dist$ORIG)){
Dist[i,"Path"]<-paste(sort(c(Dist[i,"ORIG"],Dist[i,"DEST"]))[1],sort(c(Dist[i,"ORIG"],Dist[i,"DEST"]))[2],sep="-")
}
for(i in 1:length(CEmi$ORIG)){
CEmi[i,"Path"]<-paste(sort(c(CEmi[i,"ORIG"],CEmi[i,"DEST"]))[1],sort(c(CEmi[i,"ORIG"],CEmi[i,"DEST"]))[2],sep="-")
}
CEmi$Count<-1
Dist$Count<-1
Dist<-with(Dist,Dist[order(Dist$Path),])
CEmi<-with(CEmi,CEmi[order(CEmi$Path),])
rownames(Dist)<-Dist$SORT
rownames(CEmi)<-CEmi$SORT
Dist<-Dist[,c(4,5,6)]
CEmi<-CEmi[,c(4,5,6)]
FlightData<-aggregate(cbind(Distance,Count) ~ Path, data= Dist, FUN = sum)
FlightData$CO2<-aggregate(cbind(CO2_Emissions.tons_per_passenger.,Count) ~ Path, data= CEmi, FUN = sum)[,2]
FlightData$DistInd<-unique(Dist)[,1]
FlightData$CEmiInd<-unique(CEmi)[,1]
FlightData$First<-substr(FlightData$Path,1,3)
FlightData$Secon<-substr(FlightData$Path,5,7)
FlightData$FirstLong<-Airports[match(FlightData$First,Airports$Code),"Longitude"]
FlightData$FirstLat<-Airports[match(FlightData$First,Airports$Code),"Latitude"]
FlightData$SeconLong<-Airports[match(FlightData$Secon,Airports$Code),"Longitude"]
FlightData$SeconLat<-Airports[match(FlightData$Secon,Airports$Code),"Latitude"]
FlightData$FirstElev<-Airports[match(FlightData$First,Airports$Code),"Elevation"]
FlightData$SeconElev<-Airports[match(FlightData$Secon,Airports$Code),"Elevation"]
FlightData<-FlightData[rowSums(is.na(FlightData))==0,]
save(FlightData,file="FlightDataClean.Rda")

Airports<-read.table("airports.txt",sep=",")
Airports<-Airports[,c(3,4,5,7,8,9)]
colnames(Airports)<-c("City","Country","Code","Latitude","Longitude","Elevation")
