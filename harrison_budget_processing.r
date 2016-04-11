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
Path<-"K:\\2007-01 PROFESSIONAL SERVICES\\R scripts and data\\"
# Path<-"~\\FPDS\\R scripts and data\\"
# Path<-"C:\\Users\\Greg Sanders\\SkyDrive\\Documents\\R Scripts and Data SkyDrive\\"

require(plyr)
require(reshape2)

source(paste(Path,"helper.r",sep=""))
source(paste(Path,"lookups.r",sep=""))
source(paste(Path,"helper.r",sep=""))


setwd("K:\\Development\\Budget")
# setwd("C:\\Users\\Greg Sanders\\Documents\\Budget")

# debug(create_procedural_graphs
Procurement<-read.csv(
    paste("Data\\","Harrison_Procurement_Budget_Database_Export_2015.csv",sep=""),
    header=TRUE, sep=",", na.strings="", dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)
colnames(Procurement)
Procurement<-reshape2::melt(Procurement
      , id=c("ID"
          ,"Account"
          ,"Budget.Activity"
          ,"Budget.Activity.Title"
          ,"BSA"
          ,"BSA.Title"
          ,"Line.Item"
          ,"Line.Item.Title"
          ,"Cost.Type"
          ,"Cost.Type.Title"
          ,"Category"
          ,"Classified")
      )


Procurement$FiscalYear<-as.numeric(substring(as.character(Procurement$variable),4,7))
Procurement$variable<-substring(as.character(Procurement$variable),9,999)
Procurement$variable[Procurement$variable==""]<-"Actual"
Procurement$variable[Procurement$variable=="CR.Quant"]<-"Quant.CR"
Procurement$variable[Procurement$variable=="CR.OCO.Quant"]<-"Quant.CR.OCO"
Procurement$variable[Procurement$variable=="Quant"]<-"Quant.Actual"
Procurement$variable<-ordered(Procurement$variable,c("PB",
                                                     "App",
                                                     "Actual",
                                                     "CR",
                                                     "CR.OCO",
                                                     "OCO.PB",
                                                     "OCO.App",
                                                     "OCO.Sup",
                                                     "Quant.PB",
                                                     "Quant.App",
                                                     "Quant.Actual",
                                                     "Quant.CR",
                                                     "Quant.CR.OCO",
                                                     "Quant.OCO.PB",
                                                     "Quant.OCO.App",
                                                     "Quant.OCO.Sup"
                                                     ))
summary(Procurement$variable)
Procurement<-subset(Procurement,!is.na(value))
# unique(Procurement$variable)
# Procurement$Type[substring(as.character(Procurement$variable),1,5)=="Quant"]<-"Quantity"
# Procurement$Type[substring(as.character(Procurement$variable),1,5)!="Quant"]<-"Dollars"
# Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]<-
    # substring(as.character(Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]),7,999)

Procurement<-dcast(Procurement, ID
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
                   + FiscalYear~ variable ,sum, fill=NA_real_ )




write.csv(Procurement,paste("Data\\","Long_Procurement_Budget_Database_Export.csv",sep=""), row.names=FALSE,na="")


max(nchar(as.character(Procurement$Line.Item)))



RnD<-read.csv(
    paste("Data\\","Harrison_RnD_Budget_Database_Export.csv",sep=""),
    header=TRUE, sep=",", na.strings="", dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)
colnames(RnD)
RnD<-melt(RnD
                  , id=c("ID"
                         ,"PE"
                         ,"PE.Title"
                         ,"Budget.Activity"
                         ,"Budget.Activity.Title"
                         ,"Account"
                         ,"Classified")
                  # ,value.name="DollarsThousands"
)



RnD$FiscalYear<-as.numeric(substring(as.character(RnD$variable),4,7))
RnD$variable<-substring(as.character(RnD$variable),9,999)
RnD$variable[RnD$variable==""]<-"Actual"
RnD$variable<-ordered(RnD$variable,c("PB",
                                                     "App",
                                                     "Actual",
                                                     "CR",
                                                     "CR.OCO",
                                                     "OCO.PB",
                                                     "OCO.App",
                                                     "OCO.Sup"
                                  
))

RnD<-subset(RnD,!is.na(value))
RnD<-dcast(RnD, ID+
                         PE+
                         PE.Title+
                         Budget.Activity+
                         Budget.Activity.Title+
                         Account+
                         Classified+ FiscalYear~ variable ,
           sum, 
           fill=NA_real_ )




max(nchar(as.character(RnD$PE)))
write.csv(RnD,paste("Data\\","Long_RnD_Budget_Database_Export.csv",sep=""), row.names=FALSE,na="")

str(RnD)