#' @title Update Bounding Box
#' @description Update the bounding box of an 'sf' or 'sfc' object. Bounding box information
#' is typically handled internally by the sf package. However, if you modify a geometry directly,
#' the bounding box is not necessarily updated to reflect the modifications. This function can
#' be used to provide an updated bounding box.
#' @param x an object with class 'sf' or 'sfc'
#' @importFrom sf st_cast
#' @importFrom sf st_coordinates
#' @importFrom sf st_geometry
#' @return x, but with an updated bounding box
#' @export
st_bbox_update <- function(x) {
  pts <- sf::st_cast(x=x, to="POINT", warn=FALSE)
  coords <- sf::st_coordinates(x=pts)
  new_bbox <- c(xmin=min(coords[,1], na.rm=T),
                ymin=min(coords[,2], na.rm=T),
                xmax=max(coords[,1], na.rm=T),
                ymax=max(coords[,2], na.rm=T))
  attr(new_bbox, "class") <- "bbox"
  attr(sf::st_geometry(obj=x), "bbox") <- new_bbox
  return(x)
}


# st_geometry(nc[nc$NAME == "Dare", ]) <-  st_sfc(st_point(c(-80, 40)))
#
# sf_poly[[1]][[1]][[1]] <- new_coords
#
#
# test$geometry[[1]][[1]]
#
# sf::st_bbox(test)
#
# test$geometry[[1]][[1]] <- -1000
#
# sf::st_bbox(test)
#
# test1 <- st_bbox_update(test)


#' @title Replace Selected Point Coordinates
#' @description Replace the point geometry for selected index in an sf object.
#' @param sf an object with class 'sf' or 'sfc'
#' @param x the new x coordinate (longitude), or NA to leave as is.
#' @param y the new y coordinate (latitude), or NA to leave as is.
#' @importFrom sf st_cast
#' @importFrom dplyr coalesce
#' @return sf, but with updated point coordinates
#' @export
replace_point_coords <- function(sf, index, x=NA, y=NA) {
  sf::st_geometry(sf)[[index]][[1]] <- dplyr::coalesce(
    x, sf::st_geometry(sf)[[index]][[1]])

  sf::st_geometry(sf)[[index]][[2]] <- dplyr::coalesce(
    y, sf::st_geometry(sf)[[index]][[2]])

  out <- st_bbox_update(sf)

  return(out)
}
