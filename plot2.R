# load necessary packages
library(lubridate)
library(dplyr)

# create the directory if it doesn't exist
if(!file.exists("./data")){
        dir.create("./data")
}

# download and unzip the 'DataSet.zip' file if it doesn't exist
if(!file.exists("./data/DataSet.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","./data/DataSet.zip")
        unzip(zipfile = "./data/DataSet.zip", exdir = "./data")
}

# read entire file
data <- read.table("data/household_power_consumption.txt", header = TRUE, sep = ";")

# change Date column data type to Date
data <- mutate(data, Date = dmy(Date))

# filter data based on required dates
plotData <- data %>% filter(Date>=ymd("2007-02-01") & Date<=ymd("2007-02-02"))

# change Global_active_power column data type to numeric
plotData <- mutate(plotData, Global_active_power = as.numeric(Global_active_power))

# add DateTime column
plotData <- cbind(plotData, ymd_hms(paste(plotData$Date, plotData$Time)))
names(plotData)[10] = "dateTime"

# open png graphics device
png(filename = "plot2.png", height = 480, width = 480)

# send the plot to the graphics device
with(plotData, plot(dateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))

# close the graphics device
dev.off()