## This code is for system.file("doqtl2/setup.R", package = "qtl2shiny")

## Add Closed Reference OTUs
if(dir.exists(file.path(datapath, "otu"))) {
  peaks_otu <- readRDS(file.path(datapath, "otu", "peaks_OTU_CR.rds"))
  peaks_otu <- 
    dplyr::filter(
      peaks_otu,
      output %in% peaks_otu$output)
  peaks <- dplyr::bind_rows(peaks,
                            peaks_otu[, names(peaks)])
  
  analyses_otu <- 
    dplyr::filter(
      readRDS(file.path(datapath, "otu", "analyses_OTU_CR.rds")),
      output %in% peaks_otu$output)
  analyses_tbl <- 
    dplyr::bind_rows(analyses_tbl,
                     analyses_otu[, names(analyses_tbl)])
  
  pheno_otu <- readRDS(file.path(datapath, "otu", "pheno_OTU_CR.rds"))
  pheno_otu <- dplyr::select(
    as.data.frame(pheno_otu), 
    which(colnames(pheno_otu) %in% peaks_otu$pheno))
  tmp <- matrix(NA, nrow(pheno_data), ncol(pheno_otu))
  dimnames(tmp) <- list(rownames(pheno_data), colnames(pheno_otu))
  m <- match(rownames(pheno_otu), rownames(tmp))
  tmp[m,] <- as.matrix(pheno_otu)
  pheno_data <- cbind(pheno_data, 
                      as.data.frame(tmp))
  
  # Add model column to analyses_tbl
  analyses_tbl <- 
    dplyr::mutate(
      analyses_tbl,
      model = ifelse(pheno_type == "OTU_Bin",
                     "binary",
                     "normal"))
  analyses_tbl <- 
    dplyr::select(
      analyses_tbl,
      pheno:pheno_type, model, transf:ncol(analyses_tbl))
}
