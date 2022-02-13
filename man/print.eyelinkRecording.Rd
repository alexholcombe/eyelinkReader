% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print.R
\name{print.eyelinkRecording}
\alias{print.eyelinkRecording}
\title{Print info about \code{\link{eyelinkRecording}}}
\usage{
\method{print}{eyelinkRecording}(x, ...)
}
\arguments{
\item{x}{\code{\link{eyelinkRecording}} object}

\item{...}{Addition parameters (unused)}
}
\description{
Print info about \code{\link{eyelinkRecording}}
}
\examples{
if (eyelinkReader::is_compiled()) {
    recording <- read_edf(system.file("extdata", "example.edf", package = "eyelinkReader"))
    print(recording)
}
}