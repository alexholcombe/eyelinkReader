#' Extract display coordinates from an event message
#'
#' @description Extracts display coordinates from a message that adheres to a
#' \code{<message_prefix> <label>} format. Please note that this function \strong{is not} called
#' during the \code{\link{read_edf}} call and you need to call it separately.
#'
#' @param object Either an \code{\link{eyelinkRecording}} object or data.frame with events,
#' i.e., \code{events} slot of the \code{\link{eyelinkRecording}} object.
#' @param message_prefix Beginning of the message string that identifies the DISPLAY_COORDS message.
#' Defaults to \code{"DISPLAY_COORDS"}.
#'
#' @return A \code{\link{eyelinkRecording}} object with an additional \code{display_coords} slot (if that was \code{object} type),
#' Either a four element numeric vector with display coordinates, or \code{NULL} if \code{object} was an \code{events} table of
#' \code{\link{eyelinkRecording}} object. See \code{\link{eyelinkRecording}} for details.
#'
#' @seealso read_edf, eyelinkRecording
#' @export
#'
#' @examples
#' if (eyelinkReader::is_compiled()) {
#'     recording <- read_edf(system.file("extdata", "example.edf", package = "eyelinkReader"))
#'
#'     # by passing the recording
#'     recording <- extract_display_coords(recording)
#'
#'     # by passing events table
#'     extract_display_coords(recording$events)
#' }
extract_display_coords <- function(object, message_prefix = "DISPLAY_COORDS") { UseMethod("extract_display_coords") }


#' @rdname extract_display_coords
#' @export
#' @importFrom dplyr %>% filter
#' @importFrom rlang .data

extract_display_coords.data.frame <- function(object, message_prefix = "DISPLAY_COORDS") {
  if (!is.null(object)){
    display_coord_msg <- dplyr::filter(object, .data$trial == 0, startsWith(.data$message, message_prefix))

    if (nrow(display_coord_msg) == 0) {
      warning("No DISPLAY_COORDS message found.")
      return(NULL)
    } else if (nrow(display_coord_msg) > 1) {
      warning("Multiple DISPLAY_COORDS messages found. Using the first one.")
      display_coord_msg <- display_coord_msg[1, ]
    }

    # decomposing message into components
    message_components <- unlist(strsplit(trimws(display_coord_msg$message[1]), split = " "))
    if (length(message_components) != 5) {
      warning("Invalid DISPLAY_COORDS.")
      return(NULL)
    }
    as.numeric(message_components[-1])
  }
}

#' @rdname extract_display_coords
#' @export
extract_display_coords.eyelinkRecording <- function(object, message_prefix = "DISPLAY_COORDS"){
  object$display_coords <- extract_display_coords(object$events, message_prefix)
  object
}