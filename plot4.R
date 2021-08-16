# set working directory

# load packages

library(tidyverse)
library(lubridate)

# calculate memory requirement for dataset. The dataset has 2,075,259 rows and 9 columns

bytes <- 2075259*9*8
mb <-bytes/(2^20)
gb <- mb/1000
gb

# download file and unzip

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("data")) {
        dir.create("data")
}

download.file(url, "./data/data.zip", method="curl")
list.files("./data")
dataDownloaded <- date()
dataDownloaded

unzip("./data/data.zip", exdir = "data")

# read in only lines with dates 2007-02-01 and 2007-02-02

69515-66637

read.table("./data/household_power_consumption.txt", sep=";", nrows=1, 
           skip=66637)
read.table("./data/household_power_consumption.txt", sep=";", nrows=1, 
           skip=69516)
data <- read.table("./data/household_power_consumption.txt", sep=";", 
                   col.names=c("date", "time", "global_active_power", 
                               "global_reactive_power", "voltage", 
                               "global_intensity", "sub_metering_1", 
                               "sub_metering_2", "sub_metering_3"), 
                   na.strings=c("?"), nrows=2880, skip=66637
)

head(data)
tail(data)

# create tibble

data_tbl <- tibble(data)

# convert columns one and two to datetime

data_tbl <- data_tbl %>% 
        mutate(date_time = paste(date, time)) %>% 
        select(date_time, global_active_power:sub_metering_3)

data_tbl$date_time <- dmy_hms(data_tbl$date_time)

# reconstruct plot 4

png(filename="plot4.png", width=480, height=480)

par(mfcol=c(2,2), mar=c(4,4,1,1))

#plot topleft
with(data_tbl, plot(date_time, global_active_power, type="l", xlab="", 
                    ylab= "Global Active Power (kilowatts)")
)

# plot bottomleft
with(data_tbl, plot(date_time, sub_metering_1, type="l", xlab="", 
                    ylab="Energy sub metering"),
)
with(data_tbl, lines(date_time, sub_metering_2, type="l", col="red"))
with(data_tbl, lines(date_time, sub_metering_3, type="l", col="blue"))
legend("topright", col = c("black", "red", "blue"), lty= 1, box.lty=0, cex = 0.7, legend=c("sub_metering_1","sub_metering_2", "sub_metering_3"))

# plot topright - voltage date_time
with(data_tbl, plot(date_time, voltage, type="l", xlab="datetime", ylab="Voltage"))

# plot bottomright - date_time, global_reactive_power
with(data_tbl, plot(date_time, global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power"))

dev.off()