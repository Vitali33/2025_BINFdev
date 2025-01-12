################################################
## LOAD LIBRARIES                             ##
################################################
################################################

library(optparse)
library(ggplot2)
library(RColorBrewer)
library(pheatmap)

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
option_list <- list(
  make_option(c("-i", "--input_file"), type="character", default=NULL, metavar="path", help="Input sample file"),
  make_option(c("-g", "--geneFunctions_file"), type="character", default=NULL, metavar="path", help="Gene Functions file."),
  make_option(c("-a", "--annoData_file"), type="character", default=NULL, metavar="path", help="Annotation Data file."),
  make_option(c("-p", "--outprefix"), type="character", default='projectID', metavar="string", help="Output prefix.")
)


opt_parser <- OptionParser(option_list=option_list)
opt        <- parse_args(opt_parser)

sampleInput=opt$input_file
geneInput=opt$geneFunctions_file
annoInput=opt$annoData_file
outprefix=opt$outprefix

testing="Y"
if (testing == "Y"){
  sampleInput="data/sampleData.csv"
  geneInput="data/geneFunctions.csv"
  annoInput="data/annoData.csv"
  outprefix="test"
}


if (is.null(sampleInput)){
  print_help(opt_parser)
  stop("Please provide an input file.", call.=FALSE)
}

################################################
################################################
## READ IN FILES##
################################################
################################################
setwd("./")

sampleData=read.csv(sampleInput,row.names=1)
annoData=read.csv(annoInput,row.names=1)
geneFunctions=read.csv(geneInput,row.names=1)

################################################
################################################
## Set colors##
################################################
################################################
annoColors <- list(
  gene_functions = c("Oxidative_phosphorylation" = "#F46D43",
                     "Cell_cycle" = "#708238",
                     "Immune_regulation" = "#9E0142",
                     "Signal_transduction" = "beige", 
                     "Transcription" = "violet"), 
  Group = c("Disease" = "darkgreen",
            "Control" = "blueviolet"),
  Lymphocyte_count = brewer.pal(5, 'PuBu')
)

################################################
################################################
## Create a basic heatmap##
################################################
################################################

pdf(paste0("basic_heatmap_", outprefix, ".pdf"))
pheatmap(
  sampleData,
  clustering_distance_rows = "euclidean",
  clustering_distance_cols = "euclidean",
  clustering_method = "ward.D",
  main = "Basic Heatmap",
  fontsize_row = 6,
  fontsize_col = 6
)
dev.off()

################################################
################################################
## Create a complex heatmap##
################################################
################################################

pdf(paste0("complex_heatmap_", outprefix, ".pdf")) 
pheatmap(
  sampleData,
  annotation_col = annoData,      # Add annotation for columns
  annotation_colors = annoColors, # Use predefined colors
  clustering_distance_rows = "euclidean",
  clustering_distance_cols = "euclidean",
  clustering_method = "ward.D",
  show_rownames = FALSE,   # Hide row names
  show_colnames = FALSE,   # Hide column names
  legend_breaks = c(min(sampleData), mean(sampleData), max(sampleData)), 
  legend_labels = c("Low", "Medium", "High"),
  main = "Complex Heatmap"
)

dev.off()
