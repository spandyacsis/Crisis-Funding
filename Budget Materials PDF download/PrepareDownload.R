# DOD BUDGET PDFS AUTOMATIC DOWNLOAD PROJECT
# April 2016

################################################################################
# THIS SCRIPT WILL PREPARE TO DOWNLOAD PDFs FROM A LIST OF DOD WEBSITES
#
# - check all websites listed in the pagelist.txt file in this folder
# - find all available PDF files linked on those pages
# - generate a list of PDF URLs for use by the DownloadPDFs.R script
# - generate a list of local filenames for use by the DownloadPDFs.R script 
# - create a logical directory structure for the PDFs within the 
#   "Budget Materials PDF download" directory in this folder
#
# AFTER YOU RUN THIS, YOU MUST RUN DownloadPDFs.R TO ACTUALLY DOWNLOAD THE FILES
################################################################################

library(stringr)        # for extracting text strings from webpage contents
library(httr)           # for reading html

# Save original working directory
originalwd <- getwd()

# Set location for downloads
setwd("K:/Development/Budget/Budget Materials PDF download")

# Read in URLS from pagelist file
# pagelist <- as.character(unlist(read.delim("pagelist.txt")))
pagelist <- as.character(unlist(read.delim("test_pagelist.txt")))

# Initialize lists for PDF URLs and local save locations;
# These are eventually written out as PDFURLs.txt and PDFNames.txt
URLsToSave <- vector("character", length = 0)
PathsToSave <- vector("character", length = 0)



################################################################################
# MAIN LOOP: READ ONE URL FROM THE PAGELIST FILE AND ADD ALL PDFs ON THAT PAGE
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
      if(grep("comptroller.defense.gov", url)){
            pdfurl <- paste("http://comptroller.defense.gov", pdfs, sep="")
            from <- "Comptroller"
            pagename <- unlist(strsplit(
                  url,"http://comptroller.defense.gov/BudgetMaterials/"))[2]
            pagename <- unlist(strsplit(pagename, "\\.aspx"))[1]
      }

      
      
      
      
      
      
### Create file structure
      dir.create(from, showWarnings = FALSE)
      dir.create(file.path(from, pagename), showWarnings = FALSE)
      
      
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