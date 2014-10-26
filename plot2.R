## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Keep only Baltimore results, having fips == "24510"
NEI <- NEI[NEI$fips == "24510", ]

# Sum the emissions by year
emissions <- c(sum(NEI[NEI$year == 1999, "Emissions"]),
               sum(NEI[NEI$year == 2002, "Emissions"]),
               sum(NEI[NEI$year == 2005, "Emissions"]),
               sum(NEI[NEI$year == 2008, "Emissions"]))
years <- c("1999", "2002", "2005", "2008")

# Create and save the plot
png(filename = "plot2.png") 
plot(years, emissions, 
        type="l", 
        main=expression("PM"[2.5]*" emission in Baltimore City, Maryland"), 
        xlab="Year", 
        ylab=expression("PM"[2.5]*" emission (tons)"))
dev.off()