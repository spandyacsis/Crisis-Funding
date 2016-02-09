#*************************************Required Libraries******************************************
require(plyr)
require(grid)
require(reshape2)
require(stringr)
require(ggplot2)
# require(logging)
# debug(VariableNumericalFormat)
#*************************************Options*****************************************************
options(error=recover)
options(warn=1)
# basicConfig()
# logdebug("not shown, basic is INFO")
# logwarn("shown and timestamped")

# system("defaults write org.R-project.R force.LANG en_US.UTF-8")
# debug("CreateCSV")

# debug(apply_lookups)
# debug(CreateDuration)
#*************************************Lookup Files*****************************************************
# Path<-"K:\\2007-01 PROFESSIONAL SERVICES\\R scripts and data\\"
# Path<-"~\\FPDS\\R scripts and data\\"
Path<-"C:\\Users\\Greg Sanders\\SkyDrive\\Documents\\R Scripts and Data SkyDrive\\"

require(plyr)
require(reshape2)

source(paste(Path,"helper.r",sep=""))
source(paste(Path,"lookups.r",sep=""))
source(paste(Path,"helper.r",sep=""))
source(paste(Path,"statistics_aggregators.r",sep=""))
source(paste(Path,"create_procedural_graphs.r",sep=""))

# setwd("K:\\Development\\Budget")
setwd("C:\\Users\\Greg Sanders\\Documents\\Budget")

# debug(create_procedural_graphs
Procurement<-read.csv(
    paste("Data\\","Harrison_Procurement_Budget_Database_Export_2015.csv",sep=""),
    header=TRUE, sep=",", na.strings="", dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)
colnames(Procurement)
Procurement<-melt(Procurement
      , id=.(ID
          ,Account
          ,Budget.Activity
          ,Budget.Activity.Title
          ,BSA
          ,BSA.Title
          ,Line.Item
          ,Line.Item.Title
          ,Cost.Type
          ,Cost.Type.Title
          ,Category
          ,Classified)
      )


Procurement$FiscalYear<-as.numeric(substring(as.character(Procurement$variable),4,7))
Procurement$variable<-substring(as.character(Procurement$variable),9,999)
unique(Procurement$variable)
Procurement$Type[substring(as.character(Procurement$variable),1,5)=="Quant"]<-"Quantity"
Procurement$Type[substring(as.character(Procurement$variable),1,5)!="Quant"]<-"Dollars"
Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]<-
    substring(as.character(Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]),7,999)

Procurement$variable<-as.factor(Procurement$variable)

CasProcurement<-dcast(Procurement, ID
                      +Account
                      +Budget.Activity
                      +Budget.Activity.Title
                      +BSA
                      +BSA.Title
                      +Line.Item
                      +Line.Item.Title
                      +Cost.Type
                      +Cost.Type.Title
                      +Category
                      +Classified
                      +variable
                      + FiscalYear~ Type , sum)





RnD<-read.csv(
    paste("Data\\","Harrison_RnD_Budget_Database_Export.csv",sep=""),
    header=TRUE, sep=",", na.strings="", dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)
colnames(RnD)
RnD<-melt(RnD
                  , id=.(ID
                         ,PE
                         ,PE.Title
                         ,Budget.Activity
                         ,Budget.Activity.Title
                         ,Account
                         ,Classified)
                  # ,value.name="DollarsThousands"
)



RnD$FiscalYear<-as.numeric(substring(as.character(RnD$variable),4,7))
RnD$variable<-substring(as.character(RnD$variable),9,999)
RnD$variable<-as.factor(RnD$variable)

