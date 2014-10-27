############################################################################## 
# Read data.
# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

############################################################################## 
# I'm getting coal related sectors by looking at Sector names containing "coal' 
# Should return a three elements list:
#[13] "Fuel Comb - Comm/Institutional - Coal"                    
#[18] "Fuel Comb - Electric Generation - Coal"              
#[23] "Fuel Comb - Industrial Boilers, ICEs - Coal"

# Search sectors containg word "coal"
search_coal <- function(s){ 
  if(grepl("coal", s , ignore.case = TRUE))
    s
}
result <- sapply(levels(SCC$EI.Sector), search_coal)

# Get only those elements which have not returned NULL when searched for coal
coal_related <- result[-(which(sapply(result, is.null), arr.ind=TRUE))]

# Subset SCC to get only coal related sources
coalSCC <- SCC[SCC$EI.Sector %in% coal_related, ]

# Subset NEI to ge only coal related emissions (will have 28480 rows)
coalNEI <- NEI[NEI$SCC %in% coalSCC$SCC, ]

############################################################################## 
# Plot total emission from coal related sources

# Import ggplot2 package. Install it if it's not already instaled
if(!require(ggplot2)){install.packages("ggplot2")}

coalNEI$year <- factor(coalNEI$year)

# Create and save the plot
png(filename = "plot4.png") 
p <-  ggplot(coalNEI, aes(x = year, y = Emissions)) +
  stat_summary(fun.y = sum, geom="line", aes(group =1)) +
  xlab("Year") + 
  ylab(expression("PM"[2.5]*" emission (tons)")) +
  ggtitle(expression("PM"[2.5]*" coal emission"))
print(p)
dev.off()