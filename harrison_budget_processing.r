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
    header=TRUE, sep=",", na.strings=c("","NULL"), dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)

Procurement<-standardize_variable_names(Path,Procurement)
colnames(Procurement)[colnames(Procurement)=="Account"]<-"MainAccountCode"

colnames(Procurement)
Procurement<-reshape2::melt(Procurement
      , id=c("ID"
          ,"MainAccountCode"
          ,"BudgetActivity"
          ,"BudgetActivityTitle"
          ,"BSA"
          ,"BSAtitle"
          ,"LineItem"
          ,"LineItemTitle"
          ,"CostType"
          ,"CostTypeTitle"
          ,"Category"
          ,"Classified")
      )


Procurement$FiscalYear<-as.numeric(substring(as.character(Procurement$variable),4,7))
Procurement$variable<-substring(as.character(Procurement$variable),9,999)


Procurement<-read_and_join(
    ""
    ,"RenameComptrollerColumns.csv"
    ,Procurement
)

# Procurement$variable[Procurement$variable==""]<-"Actual"
# Procurement$variable[Procurement$variable=="CR.Quant"]<-"Quant.CR"
# Procurement$variable[Procurement$variable=="CR.OCO.Quant"]<-"Quant.CR.OCO"
# Procurement$variable[Procurement$variable=="Quant"]<-"Quant.Actual"
Procurement$AllColumns<-ordered(Procurement$AllColumns,c("PB",
                                                     "App",
                                                     "Actual",
                                                     "CR",
                                                     "CR_OCO",
                                                     "OCO_PB",
                                                     "OCO_App",
                                                     "OCO_Sup",
                                                     "Quant_PB",
                                                     "Quant_App",
                                                     "Quant_Actual",
                                                     "Quant_CR",
                                                     "Quant_CR_OCO",
                                                     "Quant_OCO_PB",
                                                     "Quant_OCO_App",
                                                     "Quant_OCO_Sup"
                                                     ))
summary(Procurement$AllColumns)
Procurement<-subset(Procurement,!is.na(value))
# unique(Procurement$variable)
# Procurement$Type[substring(as.character(Procurement$variable),1,5)=="Quant"]<-"Quantity"
# Procurement$Type[substring(as.character(Procurement$variable),1,5)!="Quant"]<-"Dollars"
# Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]<-
    # substring(as.character(Procurement$variable[substring(as.character(Procurement$variable),1,5)=="Quant"]),7,999)

# ProcurementAllColumns<-dcast(subset(Procurement,select=-c(variable,SourceColumn,Consolidate,OriginType)), 
#                    ID
#                    +MainAccountCode
#                    +BudgetActivity
#                    +BudgetActivityTitle
#                    +BSA
#                    +BSAtitle
#                    +LineItem
#                    +LineItemTitle
#                    +CostType
#                    +CostTypeTitle
#                    +Category
#                    +Classified
#                    + FiscalYear~ AllColumns ,sum, fill=NA_real_ )
# 
# 
# 
# 
# write.csv(ProcurementAllColumns,paste("Data\\","Procurement_Budget_Database_Export_All_Columns.csv",sep=""), row.names=FALSE,na="")


RnD$Consolidate<-ordered(RnD$Consolidate,c("PBtotal",#Amounts
                                           "PBtype",
                                           "EnactedTotal",
                                           "EnactedType",
                                           "SpecialType",
                                           "ActualTotal",
                                           "QuantPBtotal",#Quantities
                                           "QuantPBtype",
                                           "QuantEnactedTotal",
                                           "QuantEnactedType",
                                           "QuantSpecialTotal",
                                           "QuantActualTotal"
                                           
))

unique(Procurement$Consolidate)

ProcurementConsolidated<-reshape2::dcast(subset(Procurement,select=-c(variable,SourceColumn,AllColumns)), 
                                         ID
                                         +MainAccountCode
                                         +BudgetActivity
                                         +BudgetActivityTitle
                                         +BSA
                                         +BSAtitle
                                         +LineItem
                                         +LineItemTitle
                                         +CostType
                                         +CostTypeTitle
                                         +Category
                                         +Classified
                                         + FiscalYear
                                         + OriginType~  Consolidate   ,
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

write.csv(ProcurementConsolidated,paste("Data\\","Procurement_Budget_Database_Export_Consolidated.csv",sep=""), 
          row.names=FALSE,
          na="")
str(ProcurementConsolidated)


max(nchar(as.character(Procurement$LineItem)))



RnD<-read.csv(
    paste("Data\\","Harrison_RnD_Budget_Database_Export.csv",sep=""),
    header=TRUE, sep=",", na.strings=c("","NULL"), dec=".", strip.white=TRUE, 
    stringsAsFactors=TRUE
)

RnD<-standardize_variable_names(Path,RnD)
colnames(RnD)[colnames(RnD)=="Account"]<-"MainAccountCode"

colnames(RnD)
RnD<-melt(RnD
                  , id=c("ID"
                         ,"ProgramElement"
                         ,"ProgramElementTitle"
                         ,"BudgetActivity"
                         ,"BudgetActivityTitle"
                         ,"MainAccountCode"
                         ,"Classified")
                  # ,value.name="DollarsThousands"
)



RnD$FiscalYear<-as.numeric(substring(as.character(RnD$variable),4,7))
RnD$variable<-substring(as.character(RnD$variable),9,999)
# RnD$variable[RnD$variable==""]<-"Actual"

RnD<-read_and_join(
    ""
    ,"RenameComptrollerColumns.csv"
    ,RnD
)

RnD$AllColumns<-ordered(RnD$AllColumns,c("PB",
                                                     "App",
                                                     "Actual",
                                                     "CR",
                                                     "CR_OCO",
                                                     "OCO_PB",
                                                     "OCO_App",
                                                     "OCO_Sup"
                                  
))

RnD$Consolidate<-ordered(RnD$Consolidate,c("PBtotal",
                                         "PBtype",
                                         "EnactedTotal",
                                         "EnactedType",
                                         "SpecialType",
                                         "ActualTotal"
                                         
))

RnD<-subset(RnD,!is.na(value))
# RnDallColumns<-dcast(subset(RnD,select=-c(variable,SourceColumn,Consolidate,OriginType)), 
#            ID+
#                          ProgramElement+
#                          ProgramElementTitle+
#                          BudgetActivity+
#                          BudgetActivityTitle+
#                          MainAccountCode+
#                          Classified+ FiscalYear~ AllColumns ,
#            sum, 
#            fill=NA_real_ )
# 
# 
# 
# 
# # max(nchar(as.character(RnD$ProgramElement)))
# write.csv(RnDallColumns,paste("Data\\","RnD_Budget_Database_All_Columns.csv",sep=""), row.names=FALSE,na="")




RnDconsolidated<-reshape2::dcast(subset(RnD,select=-c(variable,SourceColumn,AllColumns)), 
                                         ID+  
                                     ProgramElement+
                                     ProgramElementTitle+
                                     BudgetActivity+
                                     BudgetActivityTitle+
                                     MainAccountCode+
                                     Classified+
                                    FiscalYear +                                 
                                     OriginType ~  Consolidate   ,
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


write.csv(RnDconsolidated,paste("Data\\","RnD_Budget_Database_Consolidated.csv",sep=""), 
          row.names=FALSE,
          na="")
str(ProcurementConsolidated)

