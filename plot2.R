# Check if data exists in working directory (or sub directories) 
# if not download data 

# create vector of ALL file paths 
file_list<-list.files(getwd(), all.files=TRUE, full.names=TRUE, recursive=TRUE)

# check if "household power consumption.txt" file exists  
exists = sum(grepl("household_power_consumption.txt", file_list))

#initialise variable
data_source <- character()

# if file does not exist download to working directory and extract it
if (sum(grepl("household_power_consumption.txt", file_list))!=1) {
       
      # Set source url
      SourceUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      # set destination 
      dest<- paste(getwd(), "/exdata-data-household_power_consumption.zip", sep="")
      
      #download file
      download.file(SourceUrl, dest)
      # extract file
      unzip(dest)
      # set source file location
      data_source <- paste (getwd(), "/household_power_consumption.txt", sep="")
}
# set source file location if it wasn't downloaded
if (length(data_source)==0) data_source <- file_list[which(grepl("household_power_consumption.txt", file_list)==1)]

# read data into R using read lines
data <- readLines(data_source)

#create regular expression string to filter data to table
x <-paste("^2/2/2007","^1/2/2007", sep="|")

# read relevant data to table
data<-read.table(text=data[grep(x, data)],sep=";",header=FALSE,comment.char="", colClasses = c("character", "character", "numeric","numeric","numeric","numeric","numeric", "numeric", "numeric"))

# add column names
colnames(data)<- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# convert date and create datetime
data$Date <- as.Date(data$Date,"%d/%m/%Y")
data$DateTime = as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

# create plot 2
png(file="plot2.png")
plot(data$DateTime, data$Global_active_power,
     ylab="Global Active Power (kilowatts)",
     xlab="", type="l")
dev.off()

