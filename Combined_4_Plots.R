# ==============================================================================
#                             Load Packages
# ==============================================================================
library(data.table)
library(dplyr)

# ==============================================================================
# 1. Get working directory & set it as path
# 2. create url variable to store URL of the zip file
# 3. create the zipfile variable where the zip file will be downloaded
# 4. create the txt_file variable where the extracted file will be
# 5. Download the file from url & store it in the zipfile location
# 6. Unzip the downloaded zipfile
# ==============================================================================
path = getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- file.path(path, "exdata_data_household_power_consumption.zip")
txt_file <- file.path(path, "household_power_consumption.txt")
download.file(url, zipfile)
unzip(zipfile)

# ==============================================================================
#                             Preparing the data
# ==============================================================================
overall_df <- data.table::fread(txt_file, sep = ";", na.strings = "?")
overall_df$Datetime <- as.POSIXct(paste(overall_df$Date, overall_df$Time), format = "%d/%m/%Y %H:%M:%S")
feb_df<- filter(overall_df, (year(Datetime)==2007 & month(Datetime)==2) & (day(Datetime) == 1 | day(Datetime) == 2))

# ==============================================================================
#                             Plot 1
# ==============================================================================
png("Plot1.png", width = 480, height = 480)
hist(feb_df$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power", col="red")
dev.off()
# ==============================================================================
#                             Plot 2
# ==============================================================================
png("Plot2.png", width = 480, height = 480)
plot(feb_df$Datetime, feb_df$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off()
# ==============================================================================
#                             Plot 3
# ==============================================================================
png("Plot3.png", width = 480, height = 480)
plot(feb_df$Datetime, feb_df$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(feb_df$Datetime, feb_df$Sub_metering_2, type = "l", col="red")
lines(feb_df$Datetime, feb_df$Sub_metering_3, type = "l", col="blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1)
dev.off()
# ==============================================================================
#                             Plot 4
# ==============================================================================

png("Plot4.png", width = 480, height = 480)
par(mfcol=c(2,2))

plot(feb_df$Datetime, feb_df$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

plot(feb_df$Datetime, feb_df$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(feb_df$Datetime, feb_df$Sub_metering_2, type = "l", col="red")
lines(feb_df$Datetime, feb_df$Sub_metering_3, type = "l", col="blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1, bty = "n")

with(feb_df, plot(Datetime, Voltage, xlab = "datetime", ylab = "Voltage", type = "l"))

with(feb_df, plot(Datetime, Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "l"))

dev.off()
# ==============================================================================
#                             Plot 4 - End 
# ==============================================================================
