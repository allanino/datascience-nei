## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Keep only Baltimore results
NEI <- NEI[NEI$fips == "24510", ]

# Factor type and year, as they were originally character
NEI$type <- factor(NEI$type)
NEI$year <- factor(NEI$year)

# Get sample data to speed up testing (will keep it here for future reference)
# sNEI <- NEI[sample(nrow(NEI), 10000), ]

# Import ggplot2 package. Install it if it's not already instaled
if(!require(ggplot2)){install.packages("ggplot2")}

# Create and save the plot
png(filename = "plot3.png") 
p <-  ggplot(NEI, aes(x = year, y = Emissions)) +
      stat_summary(fun.y = sum, geom="line", aes(group =1)) +
      facet_grid(type ~ ., scales = "free") + 
      xlab("Year") + 
      ylab(expression("PM"[2.5]*" emission (tons)")) +
      ggtitle(expression("PM"[2.5]*" emission by source type in Baltimore City, Maryland"))
print(p)
dev.off()
