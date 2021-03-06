% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetTopics.R
\name{TopTopicGenes}
\alias{TopTopicGenes}
\title{Extract Top Topic Genes}
\usage{
TopTopicGenes(model, ngenes)
}
\arguments{
\item{model}{LDA model.}

\item{ngenes}{Number of genes to extract for each topic.}
}
\value{
matrix containing top genes for each topic
}
\description{
This function extracts the top n scoring genes for each gene
}
\examples{
TopTopicGenes(LDA_model, 50)

}
