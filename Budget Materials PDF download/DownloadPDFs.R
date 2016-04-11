# DOD BUDGET PDFS AUTOMATIC DOWNLOAD PROJECT
# L.Lipsey for DIIG - April 2016

################################################################################
# THIS SCRIPT WILL PREPARE TO DOWNLOAD PDFs FROM A LIST OF DOD WEBSITES
# (pagelist.txt)
#
# - check all websites listed in the pagelist.txt file in this folder
# - find all available PDF files linked on those pages
# - create a logical directory structure for the PDFs within the 
#   "Budget Materials PDF download" directory in this folder
# - download PDFs into appropriate directories
################################################################################

library(stringr)        # for extracting text strings from webpage contents
library(httr)           # for reading html
library(RCurl)          # for downloading

# Save original working directory
originalwd <- getwd()

# Set location for downloads
setwd("K:/Development/Budget/Budget Materials PDF download")

# Read in URLS from pagelist file
pagelist <- as.character(unlist(read.table("pagelist.txt")))

# Initialize lists for PDF URLs and local save locations
URLsToSave <- vector("character", length = 0)
PathsToSave <- vector("character", length = 0)



################################################################################
# PDF-FINDING LOOP: 
# Read one URL from the pagelist file and add all PDFs from that page to
# the for-download lists (URLsToSave and PathsToSave)
###############################################################################

for(i in seq_along(pagelist)) {
      
      # read the contents of the webpage into a character variable      
      url <- as.character(pagelist[i])
      html = GET(url)
      contents = content(html, as="text")
      
      # build a list of the URLs of all PDFs linked within the read website
      pdfs <- unlist(str_extract_all(contents,
                                     '/[A-Za-z0-9-._~:/?#@!%$&()*+,;=]*?\\.pdf'))
      
      # Create "from" and "pagename" vectors to determine file structure when saving
      # "from" : which agency produced the PDF
      # "pagename": which page was the PDF found on
      if(grepl("comptroller.defense.gov", url)){
            pdfurl <- paste("http://comptroller.defense.gov", pdfs, sep="")
            from <- "Comptroller"
            pagename <- unlist(strsplit(
                  url,"http://comptroller.defense.gov/BudgetMaterials/"))[2]
            pagename <- unlist(strsplit(pagename, "\\.aspx"))[1]
      }
      
      else if(grepl("saffm.hq.af.mil", url)){
            pdfurl <- paste("http://www.saffm.hq.af.mil", pdfs, sep = "")
            from <- "AirForce"
            pagename <- unlist(strsplit(
                  url, "http://www.saffm.hq.af.mil/budget/pbfy"))[2]
            pagename <- unlist(strsplit(pagename, "\\.asp"))[1]
            if(is.na(pagename)){pagename <- "Current"}
      }
      
      else if(grepl("secnav.navy.mil", url)){
            pdfurl <- paste("http:", pdfs, sep = "")
            from <- "Navy"
            pagename <- unlist(strsplit(url,
                                        "http://www.secnav.navy.mil.*Fiscal-Year-"))[2]
            pagename <- unlist(strsplit(pagename,"\\.aspx"))[1]
      }
      
      else{
            from <- "MiscOther"
            pagename <- character(0)
      }
      
      
      ### Create file structure
      dir.create(from, showWarnings = FALSE)
      if(length(pagename) != 0){dir.create(file.path(from, pagename),
                                           showWarnings = FALSE)}
      
      
      ### Create the individual file name for the PDF as it will be saved
      pdfname <- str_extract(pdfurl, "/[A-Za-z0-9-._~:?#@!%$&()*+,;=]*?\\.pdf")
      
      ### Combine the agency, page, and file names to create the entire filepath
      savepath <- vector("character", length = 0)
      for(j in seq_along(pdfurl)){
            savepath[j] <- paste(from, "/", pagename, pdfname[j],
                                 sep = "")
      }
      
      PathsToSave <- append(PathsToSave, savepath)
      URLsToSave <- append(URLsToSave, pdfurl)
}

print("Building list of PDFs for download - This should take <5 minutes")



################################################################################
# READ ARMY PDF LIST FROM A LOCAL FILE
# Special case for the Army, as explained in README.txt
################################################################################

contents <- paste(readLines("view-source_www.asafm.army.mil_Document.aspx.html"),
                  collapse="\n")

pdfs <- unique(unlist(str_extract_all(contents,
                                      '/[A-Za-z0-9-._~:/?#@!%$&()*+,;=]*?\\.pdf')))

pagename <- vector("character", length = 0)
pagenames <- vector("character", length = 0)
from <- "Army"
pdfurl <- paste("http:", pdfs, sep = "")
pdfname <- str_extract(pdfurl, "/[A-Za-z0-9-._~:?#@!%$&()*+,;=]*?\\.pdf")
savepath <- vector("character", length = 0)

for(j in seq_along(pdfs)){
      pagenames[j] <-  unlist(strsplit(pdfs[j], "(?i)/fy"))[2]
      pagename[j] <- substr(pagenames[j], 1,2)
      if(is.na(pagename[j])){pagename[j] <- "17"}
      
      
      savepath[j] <- paste(from, "/", pagename[j], pdfname[j],
                           sep = "")
}

PathsToSave <- append(PathsToSave, savepath)
URLsToSave <- append(URLsToSave, pdfurl)


### Create file structure for Army
subdirs <- unique(pagename)
dir.create(from, showWarnings = FALSE)
for(j in seq_along(subdirs)){
      dir.create(file.path(from, subdirs[j]), showWarnings = FALSE)
}

################################################################################
# DOWNLOAD FILES
################################################################################

for(i in seq_along(URLsToSave)){
      if(!file.exists(PathsToSave[i]) | file.size(PathsToSave[i]) < 500){
            download.file(URLsToSave[i], PathsToSave[i], method = "libcurl",
                          mode="wb")
            cat(paste("Downloaded Successfully", i, URLsToSave[i], sep = "\n"))
      }
}



# Cleanup: return to original working directory
setwd(originalwd)