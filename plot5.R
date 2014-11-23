############################################################################## 
# Read data.
# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Keep only Baltimore results
NEI <- NEI[NEI$fips == "24510", ]

############################################################################## 
# I'm getting mobile sectors by looking at Sector names containing 'mobile' 
# Should return a ten elements list:
#[43] "Mobile - Aircraft"                                 
#[44] "Mobile - Commercial Marine Vessels"                
#[45] "Mobile - Locomotives"                              
#[46] "Mobile - Non-Road Equipment - Diesel"              
#[47] "Mobile - Non-Road Equipment - Gasoline"            
#[48] "Mobile - Non-Road Equipment - Other"               
#[49] "Mobile - On-Road Diesel Heavy Duty Vehicles"       
#[50] "Mobile - On-Road Diesel Light Duty Vehicles"       
#[51] "Mobile - On-Road Gasoline Heavy Duty Vehicles"     
#[52] "Mobile - On-Road Gasoline Light Duty Vehicles"     

# Search sectors containg word "coal"
search_mobile <- function(s){ 
  if(grepl("mobile", s , ignore.case = TRUE))
    s
}
result <- sapply(levels(SCC$EI.Sector), search_mobile)

# Get only those elements which have not returned NULL when searched for mobile
mobile_related <- result[-(which(sapply(result, is.null), arr.ind=TRUE))]

# Subset SCC to get only mobile related sources
mobileSCC <- SCC[SCC$EI.Sector %in% mobile_related, ]

# Subset NEI to ge only mobile related emissions (will have 1564 rows)
mobileNEI <- NEI[NEI$SCC %in% mobileSCC$SCC, ]

############################################################################## 
# Plot total emission from mobile related sources in Baltimore City

# Import ggplot2 package. Install it if it's not already instaled
if(!require(ggplot2)){install.packages("ggplot2")}

mobileNEI$year <- factor(mobileNEI$year)

# Create and save the plot
png(filename = "plot5.png") 
p <-  ggplot(mobileNEI, aes(x = year, y = Emissions)) +
  stat_summary(fun.y = sum, geom="line", aes(group =1)) +
  xlab("Year") + 
  ylab(expression("PM"[2.5]*" emission (tons)")) +
  ggtitle(expression("PM"[2.5]*" motor vehicle emission"))
print(p)
dev.off()