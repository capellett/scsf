
#' @export
geom_if <- function(data, ...) {
  if(missing(data)) return(NULL)
  if(nrow(data) ==0) return(NULL)
  return(ggplot2::geom_sf(data=data, ...))
}
