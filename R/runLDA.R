#' Runs LDA Model
#'
#'
#' This function runs an LDA model on scRNA-seq expression data
#'
#' @param Object Seurat object containing the data the model was created with.
#' @param ntopics Number of topics to be used in the model
#' @param alpha the value for alpha in the LDA model
#' @param beta the value for beta in the LDA model
#' @param varFeatures the number of variable features to use in the LDA model. The more features that are used, the slower the model will run and the more noise that will be introduced, but the model will be more complete in representing your entire dataset.
#' @param iterations the number of iterations used when learning the LDA model. 
#' @param burnin number of iterations to run to allow the model to learn before calculating certain statistics. Models start at random points, so this allows model to get closer to the fit before certain statistics are calculated.
#' 
#'
#' @examples
#' runLDA(SeuratObj, ntopics = 20)
#'
#' @return LDA Model
#'
#'
#' @export
#'
#' @import Seurat
#' @import lda


runLDA <- function(Object, ntopics, alpha = 50, beta = 0.1, varFeatures = 5000, iterations = 500, burnin = 250) {
  
  #Normalize and extract the gene expression data from the Seurat Object
  Object        <- NormalizeData(Object, assay = "RNA", normalization.method = "CLR")
  Object        <- FindVariableFeatures(Object, assay = "RNA", nfeatures = varFeatures)
  Object.sparse <- GetAssayData(Object, slot = "data",assay = "RNA")
  Object.sparse <- Object[VariableFeatures(Object, assay = "RNA"),]
  
  #convert data into the proper input format for lda.collapsed.gibbs.sampler
  data.use      <- Matrix::Matrix(Object.sparse, sparse = T)
  data.use      <- data.use * 10 ## OG 10
  data.use      <- round(data.use)
  data.use      <- Matrix::Matrix(data.use, sparse = T)
  sumMat        <- Matrix::summary(data.use)
  cellList      <- split(as.integer(data.use@i), 
                    sumMat$j)
  ValueList     <- split(as.integer(sumMat$x), 
                     sumMat$j
  )
  cellList      <- mapply(rbind, cellList, ValueList, SIMPLIFY=F)
  Genes         <- rownames(data.use)
  cellList      <- lapply(cellList, function(x) {colnames(x) <- Genes[x[1,]+1];x})
  
  #Run model
  Model <- lda.collapsed.gibbs.sampler(
    cellList, 
    ntopics, 
    Genes, 
    num.iterations=iterations, 
    alpha=alpha, 
    eta=beta, 
    compute.log.likelihood = TRUE, 
    burnin=burnin)[-1]
  
  return(Model)
}
