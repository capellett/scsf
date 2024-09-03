#' @export
test_spatial <- function(x) {
  if(missing(x)) {return(FALSE)}
  if('located' %in% names(x)) {x <- dplyr::filter(x, x$located)}
  x <- sf::st_crop(x, xmin=-83.35403, ymin=32.03440,
                   xmax=-78.54271, ymax=35.21559)
  if(nrow(x)==0) {return(FALSE)}
  return(x)}

#' @export
#' @title Add Leaflet Markers If They Exist
#' @description Add markers to a leaflet map if there is sufficient data.
#' @param map a map widget object created from leaflet()
#' @param data the data object from which the argument values are derived.
#' @param ... additional arguments passed to leaflet::addCircleMarkers() or ggplot2::geom_sf()
addIfExistMarkers <- function(map=NULL, data, map_format='pdf', ...) {
  data <- test_spatial(data)
  if(rlang::is_false(data)) {return(map)}
  if(map_format=='html'){
    return(leaflet::addCircleMarkers(map=map, data=data, ...))
  } else if(map_format=='pdf'){
    return(ggplot2::geom_sf(data=data, ...))
  }
}

#' @export
#' @title Add Leaflet Polylines If They Exist
#' @description Add polylines to a leaflet map if there is sufficient data.
#' @param map a map widget object created from leaflet()
#' @param data the data object from which the argument values are derived.
#' @param ... additional arguments passed to addPolylines()
addIfExistLines <- function(map=NULL, data, map_format='pdf', ...) {
  data <- test_spatial(data)
  if(rlang::is_false(data)) {return(map)}
  if(map_format=='html') {
    return(leaflet::addPolylines(map=map, data=data, ...))
  } else if(map_format=='pdf') {
    return(ggplot2::geom_sf(data=data, ...))
  }
}


#' @export
#' @title Add Leaflet Polygons If They Exist
#' @description Add polygons to a leaflet map if there is sufficient data.
#' @param map a map widget object created from leaflet()
#' @param data the data object from which the argument values are derived.
#' @param ... additional arguments passed to addPolygons()
addIfExistPolygons <- function(map=NULL, data, map_format='pdf', ...) {
  data <- test_spatial(data)
  if(rlang::is_false(data)) {return(map)}
  if(map_format=='html'){
    return(leaflet::addPolygons(map=map, data=data, ...))
  }else if(map_format=='pdf') {
    return(ggplot2::geom_sf(data=data, ...))
  }
}

#' @export
insertLayer <- function(P, after=0, ...) {
  #  P     : Plot object
  # after  : Position where to insert new layers, relative to existing layers
  #  ...   : additional layers, separated by commas (,) instead of plus sign (+)

  if (after < 0)
    after <- after + length(P$layers)

  if (!length(P$layers))
    P$layers <- list(...)
  else
    P$layers <- append(P$layers, list(...), after)

  return(P)
}


