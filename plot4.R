## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#[13] "Fuel Comb - Comm/Institutional - Coal"                    
#[18] "Fuel Comb - Electric Generation - Coal"              
#[23] "Fuel Comb - Industrial Boilers, ICEs - Coal"   
# Search sectors containg word "coal"
search_coal <- function(s){ 
    if(grepl("coal", s , ignore.case = TRUE))
      s
  }
res <- sapply(levels(SCC$EI.Sector), search_coal)
coal_related <- r[-(which(sapply(r, is.null), arr.ind=TRUE))]