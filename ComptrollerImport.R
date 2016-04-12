#*************************************Required Libraries******************************************
library(xlsx)     # to read excel files
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
# *************************************Lookup Files*****************************************************
# Path<-"K:\\2007-01 PROFESSIONAL SERVICES\\R scripts and data\\"
# Path<-"~\\FPDS\\R scripts and data\\"
Path<-"C:\\Users\\Greg Sanders\\SkyDrive\\Documents\\R Scripts and Data SkyDrive\\"

require(plyr)
require(reshape2)

source(paste(Path,"helper.r",sep=""))
source(paste(Path,"lookups.r",sep=""))
source(paste(Path,"helper.r",sep=""))


# setwd("K:\\Development\\Budget")
setwd("C:\\Users\\Greg Sanders\\Documents\\Budget")

# debug(create_procedural_graphs
Procurement <- read.xlsx2("./Data/p1.xlsx", 
                            sheetName = "Exhibit P-1",
                            startRow=2)


Procurement$SourceFiscalYear<-2017

Procurement<-standardize_variable_names(Path,Procurement)
colnames(Procurement)[colnames(Procurement)=="Account"]<-"AccountDSI"

colnames(Procurement)
Procurement$FY.2015..Base...OCO..Quantity <- as.numeric(as.character(Procurement$FY.2015..Base...OCO..Quantity))
Procurement$FY.2015..Base...OCO..Amount <- as.numeric(as.character(Procurement$FY.2015..Base...OCO..Amount))
Procurement$FY.2016.Base.Enacted.Quantity <- as.numeric(as.character(Procurement$FY.2016.Base.Enacted.Quantity))
Procurement$FY.2016.Base.Enacted.Amount <- as.numeric(as.character(Procurement$FY.2016.Base.Enacted.Amount))
Procurement$FY.2016.OCO.Enacted.Quantity <- as.numeric(as.character(Procurement$FY.2016.OCO.Enacted.Quantity))
Procurement$FY.2016.OCO.Enacted.Amount <- as.numeric(as.character(Procurement$FY.2016.OCO.Enacted.Amount))
Procurement$FY.2016.Total.Enacted.Quantity <- as.numeric(as.character(Procurement$FY.2016.Total.Enacted.Quantity))
Procurement$FY.2016.Total.Enacted.Amount <- as.numeric(as.character(Procurement$FY.2016.Total.Enacted.Amount))
Procurement$FY.2017.Base.Quantity <- as.numeric(as.character(Procurement$FY.2017.Base.Quantity))
Procurement$FY.2017.Base.Amount <- as.numeric(as.character(Procurement$FY.2017.Base.Amount))
Procurement$FY.2017.OCO.Quantity <- as.numeric(as.character(Procurement$FY.2017.OCO.Quantity))
Procurement$FY.2017.OCO.Amount <- as.numeric(as.character(Procurement$FY.2017.OCO.Amount))
Procurement$FY.2017.Total.Quantity <- as.numeric(as.character(Procurement$FY.2017.Total.Quantity))
Procurement$FY.2017.Total.Amount <- as.numeric(as.character(Procurement$FY.2017.Total.Amount))
Procurement$FY.2017.OCO.Quantity <- as.numeric(as.character(Procurement$FY.2017.OCO.Quantity))



Procurement<-melt(Procurement,
                  id.vars=c("SourceFiscalYear"
                            ,"AccountDSI"
                         ,"AccountTitle"
                         ,"Organization"
                         ,"BudgetActivity"
                         ,"BudgetActivityTitle"
                         ,"LineNumber"
                         ,"BSA"
                         ,"BSAtitle"
                         ,"LineItem"
                         ,"LineItemTitle"
                         ,"CostType"
                         ,"CostTypeTitle"
                         ,"AddOrNonAdd"
                         ,"Classified"
                         )
)




Procurement$FiscalYear<-as.numeric(substring(as.character(Procurement$variable),4,7))
Procurement$variable<-substring(as.character(Procurement$variable),9,999)

unique(Procurement$variable)


 
#I'm probably going to switch this to a CSV
Procurement<-read_and_join(
    ""
    ,"RenameComptrollerColumns.csv"
    ,Procurement
)
# 
# 
# 
# Procurement$variable[Procurement$variable==".Base...OCO..Quantity"]<-"Quant.Actual" #"(Base & OCO)
# Procurement$variable[Procurement$variable==".Base...OCO..Amount"]<-"Actual" #"(Base & OCO)
# 
# Procurement$variable[Procurement$variable=="Base.Enacted.Quantity"]<-"Quant.Base.App"
# Procurement$variable[Procurement$variable=="Base.Enacted.Amount"]<-"Base.App"
# 
# Procurement$variable[Procurement$variable=="OCO.Enacted.Quantity"]<-"Quant.OCO.App"
# Procurement$variable[Procurement$variable=="OCO.Enacted.Amount"]<-"OCO.App"
#     
# Procurement$variable[Procurement$variable=="Total.Enacted.Quantity"]<-"Quant.App"
# Procurement$variable[Procurement$variable=="Total.Enacted.Amount"]<-"App"
# 
# Procurement$variable[Procurement$variable=="Base.Quantity"]<-"Quant.Base.PB"
# Procurement$variable[Procurement$variable=="Base.Amount"]<-"Base.PB"
# 
# Procurement$variable[Procurement$variable=="OCO.Quantity"]<-"Quant.OCO.PB"
# Procurement$variable[Procurement$variable=="OCO.Amount"]<-"OCO.PB"
#     
# Procurement$variable[Procurement$variable=="Total.Quantity"]<-"Quant.PB"
# Procurement$variable[Procurement$variable=="Total.Amount"]<-"PB"
# 
# Procurement$variable[Procurement$variable==""]<-"Actual"
# Procurement$variable[Procurement$variable=="CR.Quant"]<-"Quant.CR"
# Procurement$variable[Procurement$variable=="CR.OCO.Quant"]<-"Quant.CR.OCO"
# Procurement$variable[Procurement$variable=="Quant"]<-"Quant.Actual"

    
Procurement$variable<-ordered(Procurement$variable,c("PB",
                                                     "App",
                                                     "Actual",
                                                     "CR",
                                                     "CR_OCO",
                                                     "OCO_PB",
                                                     "Base_PB",
                                                     "OCO_App",
                                                     "Base_App",
                                                     "OCO_Sup",
                                                     "Quant_PB",
                                                     "Quant_App",
                                                     "Quant_Actual",
                                                     "Quant_CR",
                                                     "Quant_CR_OCO",
                                                     "Quant_OCO_PB",
                                                     "Quant_Base_PB",
                                                     "Quant_OCO_App",
                                                     "Quant_Base_App",
                                                     "Quant_OCO_Sup"
))
summary(Procurement$variable)
Procurement<-subset(Procurement,!is.na(value))
# unique(Procurement$variable)
# Procurement$Type[substring(as.character(Procurement$variable),1,5)=="Quant"]<-"Quantity"
# Procurement$Type[substring(as.character(Procurement$variable),1,5)!="Quant"]<-"Dollars"
# Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]<-
# substring(as.character(Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]),7,999)

str(Procurement)

# 
# 
# ProcurementAllColumns<-dcast(subset(Procurement,select=-c(variable,SourceColumn,Consolidate,OriginType)), 
#                    Account
#                    +BudgetActivity
#                    +BudgetActivityTitle
#                    +BSA
#                    +BSAtitle
#                    +LineItem
#                    +LineItemTitle
#                    +CostType
#                    +CostTypeTitle
#                    +AddOrNonAdd
#                    +Classified
#                    + FiscalYear~ AllColumns ,
#                    sum, 
#                    fill=NA_real_ )
# 
# write.csv(ProcurementAllColumns,paste("Data\\","P12016_AllColumns.csv",sep=""), row.names=FALSE,na="")
# str(ProcurementAllColumns)


ProcurementConsolidated<-reshape2::dcast(subset(Procurement,select=-c(variable,SourceColumn,AllColumns)), 
                             SourceFiscalYear
                             +AccountDSI
                             +BudgetActivity
                             +BudgetActivityTitle
                             +BSA
                             +BSAtitle
                             +LineItem
                             +LineItemTitle
                             +CostType
                             +CostTypeTitle
                             +Classified
                             + FiscalYear
                             + OriginType ~  Consolidate   ,
                             sum, 
                             fill=NA_real_ )




ProcurementsqlColumns<-c(	"ID"  ,
                          "SourceFiscalYear"  ,
                          "AccountDSI"  ,
                          "TreasuryAgencyCode"  ,
                          "MainAccountCode"  ,
                          "AccountTitle"  ,
                          "Organization"  ,
                          "BudgetActivity"  ,
                          "BudgetActivityTitle"  ,
                          "LineNumber" ,
                          "BSA"   ,
                          "BSAtitle"  ,
                          "LineItem"  ,
                          "LineItemTitle"  ,
                          "CostType"  ,
                          "CostTypeTitle"  ,
                          "AddOrNonAdd"  ,
                          "Classified"  ,
                          "Category"  ,
                          "FiscalYear"  ,
                          "OriginType" ,
                          "PBtotal" ,
                          "PBtype"  ,
                          "EnactedTotal"  ,
                          "EnactedType"  ,
                          "SpecialType"  ,
                          "ActualTotal"  ,
                          "QuantPBtotal"  ,
                          "QuantPBtype"  ,
                          "QuantEnactedTotal"  ,
                          "QuantEnactedType"  ,
                          "QuantSpecialTotal"  ,
                          "QuantActualTotal"  
) 

Missing<-ProcurementsqlColumns[!ProcurementsqlColumns %in% colnames(ProcurementConsolidated)]
ProcurementConsolidated[,Missing]<-NA
ProcurementConsolidated<-ProcurementConsolidated[,ProcurementsqlColumns]

write.csv(ProcurementConsolidated,paste("Data\\","P12016_Consolidated.csv",sep=""), 
          row.names=FALSE,
          na="")
str(ProcurementConsolidated)


RnD <- read.xlsx2("./Data/r1_display.xlsx", 
                            sheetName = "Exhibit R-1",
                            startRow=2)

RnD$SourceFiscalYear<-2017


RnD<-standardize_variable_names(Path,RnD)
colnames(RnD)[colnames(RnD)=="Account"]<-"AccountDSI"
colnames(RnD)


RnD$FY.2015..Base...OCO. <- as.numeric(as.character(RnD$FY.2015..Base...OCO.))
RnD$FY.2016.Base.Enacted <- as.numeric(as.character(RnD$FY.2016.Base.Enacted))
RnD$FY.2016.OCO.Enacted <- as.numeric(as.character(RnD$FY.2016.OCO.Enacted))
RnD$FY.2016.Total.Enacted <- as.numeric(as.character(RnD$FY.2016.Total.Enacted))
RnD$FY.2017.Base <- as.numeric(as.character(RnD$FY.2017.Base))
RnD$FY.2017.OCO <- as.numeric(as.character(RnD$FY.2017.OCO))
RnD$FY.2017.Total <- as.numeric(as.character(RnD$FY.2017.Total))


RnD$LineNumber <- as.numeric(as.character(RnD$LineNumber))


RnD<-melt(RnD
          , id.vars =c("SourceFiscalYear"
                       ,"AccountDSI"
                 ,"AccountTitle"
                 ,"Organization"
                 ,"BudgetActivity"
                 ,"BudgetActivityTitle"
                 ,"LineNumber"
                 ,"ProgramElement"
                 ,"ProgramElementTitle"
                 ,"IncludeInTOA"
                 ,"Classified"
                 )
          # ,value.name="DollarsThousands"
)



RnD$FiscalYear<-as.numeric(substring(as.character(RnD$variable),4,7))
RnD$variable<-substring(as.character(RnD$variable),9,999)
str(RnD$variable)

RnD<-read_and_join(
    ""
    ,"RenameComptrollerColumns.csv"
    ,RnD
)


# RnD$variable[RnD$variable==".Base...OCO."]<-"Actual" #"(Base & OCO)
# RnD$variable[RnD$variable=="Base.Enacted"]<-"Base.App"
# RnD$variable[RnD$variable=="OCO.Enacted"]<-"OCO.App"
# RnD$variable[RnD$variable=="Total.Enacted"]<-"Quant.App"
# RnD$variable[RnD$variable=="Base"]<-"Base.PB"
# RnD$variable[RnD$variable=="OCO"]<-"OCO.PB"
# RnD$variable[RnD$variable=="Total"]<-"PB"


RnD$variable<-ordered(RnD$variable,c("PB",
                                     "App",
                                     "Actual",
                                     "CR",
                                     "CR_OCO",
                                     "OCO_PB",
                                     "OCO_App",
                                     "OCO_Sup"
                                     
))


colnames(RnD)
RnD<-subset(RnD,!is.na(value))
str(RnD)

# 
# RnDallColumns<-dcast(subset(RnD,select=-c(variable,SourceColumn,Consolidate,OriginType)),
#                      Account+
#                AccountTitle+
#                Organization+
#                BudgetActivity+
#                BudgetActivityTitle+
#                LineNumber+
#                ProgramElement+
#             ProgramElementTitle+
#                IncludeInTOA+
#                Classified+ 
#                FiscalYear ~ AllColumns ,
#            sum, 
#            fill=NA_real_ )
# 
# 
# 
# 
# write.csv(RnDallColumns,paste("Data\\","R12016_AllColumns.csv",sep=""), row.names=FALSE,na="")
# 

RnDconsolidated<-dcast(subset(RnD,select=-c(variable,AllColumns)),
                     SourceFiscalYear+
                         AccountDSI+
                         AccountTitle+
                         Organization+
                         BudgetActivity+
                         BudgetActivityTitle+
                         LineNumber+
                         ProgramElement+
                         ProgramElementTitle+
                         IncludeInTOA+
                         Classified+ 
                         FiscalYear+
                         OriginType ~ Consolidate ,
                     sum, 
                     fill=NA_real_ )



RnDsqlColumns<-c("ID"
                 ,"SourceFiscalYear"
                 ,"AccountDSI"
                 ,"TreasuryAgencyCode"
                 ,"MainAccountCode"
                 ,"AccountTitle"
                 ,"Organization"
                 ,"BudgetActivity"
                 ,"BudgetActivityTitle"
                 ,"LineNumber"
                 ,"ProgramElement"
                 ,"ProgramElementTitle"
                 ,"IncludeInTOA"
                 ,"Classified"
                 ,"FiscalYear"
                 ,"OriginType"
                 ,"PBtotal"
                 ,"PBtype"
                 ,"EnactedTotal"
                 ,"EnactedType"
                 ,"SpecialType"
                 ,"ActualTotal") 

Missing<-RnDsqlColumns[!RnDsqlColumns %in% colnames(RnDconsolidated)]
RnDconsolidated[,Missing]<-NA
RnDconsolidated<-RnDconsolidated[,RnDsqlColumns]



write.csv(RnDconsolidated,paste("Data\\","R12016_Consolidated.csv",sep=""), 
          row.names=FALSE,
          na="")


