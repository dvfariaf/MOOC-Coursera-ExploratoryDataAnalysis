#Loading Libraries
if(!require("data.table")){
  print("'data.table' package required is being installed...")
  install.packages("data.table")
  print("'data.table' package required has finished installing...")
}
library(data.table)
#Setting Paths
setwd("~/Aprendizaje Personal/Data Science Specialization Coursera/4_Exploratory Data Analysis/Week1/Assignment 1")
if(!file.exists("./data/household_power_consumption.txt")){
  if(!file.exists("./data/household_power_consumption.zip")){
    print("Starting Download of files needed")
    fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL,"./data/household_power_consumption.zip")
  }
  print("Unzipping...")
  unzip("./data/household_power_consumption.zip",exdir="./data")  
  print("Done, data is ready")
}
#This might take some time...
if(!file.exists("./data/household_power_consumption_clean.txt")){
  wholeData<-readLines("./data/household_power_consumption.txt")
  wholeData<-gsub(";?",";-9999",wholeData,fixed=TRUE)
  setwd("./data/")
  con<-file(description="household_power_consumption_clean.txt",open="wt")
  writeLines(wholeData,con)
  close(con)
  setwd("..")
  rm(wholeData)
  #Data should be clean of "?" by now
}
dataPath<-"./data/household_power_consumption_clean.txt"
#only be using data from the dates 2007-02-01 and 2007-02-02
#Using data table format
colClass=c("Date","Date","numeric","numeric","numeric","numeric","integer","integer","integer")
data<-fread(dataPath,sep=";",na.strings="-9999",stringsAsFactors=FALSE)[Date %in% c("1/2/2007","2/2/2007")]
#data<-read.table(dataPath,sep=";",header=TRUE,dec=".",stringsAsFactors=FALSE)
#data_subset<-data[data$Date %in% c("1/2/2007","2/2/2007"),]
data[,Date/Time:=strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"]

#Plotting
Date_Time<-paste(data$Date,data$Time)
Sys.setlocale(category = "LC_TIME", locale = "C") #Changing time format to American
Date_Time<-strptime(Date_Time,"%d/%m/%Y %H:%M:%S")

#PLOT2
png("plot2.png")
plot(Date_Time,data$Global_active_power,"l",ylab="Global Active Power (kilowatts)",xlab="")
dev.off()