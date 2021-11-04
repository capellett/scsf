#' @title Convert projection
#' @description function converts projections
#' @param x dataframe, column, vector
#' @importFrom sp spTransform
#' @export
convCRS <- function(x) {
  sp::spTransform(
    x, "+init=epsg:4269 +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0") }
