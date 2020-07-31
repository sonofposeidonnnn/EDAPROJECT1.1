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

# add DateTime column
plotData <- cbind(plotData, ymd_hms(paste(plotData$Date, plotData$Time)))
names(plotData)[10] = "dateTime"

# change Global_active_power column data type to numeric
plotData <- mutate(plotData, Global_active_power = as.numeric(Global_active_power))

# change Voltage column data type to numeric
plotData <- mutate(plotData, Voltage = as.numeric(Voltage))

# change Global_reactive_power column data type to numeric
plotData <- mutate(plotData, Global_reactive_power = as.numeric(Global_reactive_power))

# open png graphics device
png(filename = "plot4.png", height = 480, width = 480)

par(mfrow = c(2,2))

# plot 1
with(plotData, plot(dateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

# plot 2
with(plotData, plot(dateTime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))

# plot 3
plotData <- mutate(plotData, Sub_metering_1 = as.numeric(Sub_metering_1), Sub_metering_2 = as.numeric(Sub_metering_2))
plot(plotData$dateTime, plotData$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
points(plotData$dateTime, plotData$Sub_metering_2, type = "l", col = "red")
points(plotData$dateTime, plotData$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty=1, col = c("black", "red", "blue"), bty = "n", legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), cex = 0.50)

# plot 4
with(plotData, plot(dateTime, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

# close the graphics device
dev.off()