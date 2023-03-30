### These functions are used to create a frame that locates the
### main map area within the mini-map.
### This probably only works in cartesian projections, idk.

#' @param bbox a bounding box to expand.
#' @param expansion the proportion you want to expand the bbox by.
#' @param minimum the minimum size bbox (length of its side) bounding box you want to show on the mini-map.
#'   smaller bboxes will be expanded to at least this size.
#' @export
bbox_expander <- function(bbox, expansion=0.1, minimum=2000) {
  x_range <- max(bbox$xmax - bbox$xmin, 1, na.rm=TRUE)
  y_range <- max(bbox$ymax - bbox$ymin, 1, na.rm=TRUE)
  old_aspect <- x_range / y_range  # aspect <- width / height

  bbox2 <- bbox
  ### the map will always occupy a square.
  if(old_aspect < 1) {
    x_correction <- 0.5*(y_range-x_range)
    bbox2$xmin <- bbox2$xmin - x_correction
    bbox2$xmax <- bbox2$xmax + x_correction
  } else {
    y_correction <- 0.5*(x_range-y_range)
    bbox2$ymin <- bbox2$ymin - y_correction
    bbox2$ymax <- bbox2$ymax + y_correction }

  x_expand <- (bbox2$xmax - bbox2$xmin) * 0.5 * expansion
  y_expand <- (bbox2$ymax - bbox2$ymin) * 0.5 * expansion

  bbox2$xmin <- bbox2$xmin - x_expand
  bbox2$xmax <- bbox2$xmax + x_expand
  bbox2$ymin <- bbox2$ymin - y_expand
  bbox2$ymax <- bbox2$ymax + y_expand

  x_range2 <- bbox2$xmax - bbox2$xmin
  if(x_range2 < minimum) {
    x_expand2 <- (minimum-x_range2)*0.5
    bbox2$xmin <- bbox2$xmin - x_expand2
    bbox2$xmax <- bbox2$xmax + x_expand2
  }

  y_range2 <- bbox2$ymax - bbox2$ymin
  if(y_range2 < minimum) {
    y_expand2 <- (minimum-y_range2)*0.5
    bbox2$ymin <- bbox2$ymin - y_expand2
    bbox2$ymax <- bbox2$ymax + y_expand2
  }

  bbox2 <- unlist(bbox2)
  names(bbox2) <- c("xmin", "ymin", "xmax", "ymax")
  bbox2 <- sf::st_bbox(bbox2, crs=sf::st_crs(bbox))
  return(bbox2) }

#' @description Given an sf object, create a new sf object
#'  which is a bounding box of the input. The bbox sf can be mapped on a mini-map.
#'  It can also be used to find neighboring features.
#' @export
create_frame_from_sf <- function(sf, expansion=0.1) {
  sf %>%
    sf::st_transform(2958) %>% ## NAD83 UTM 17N
    sf::st_bbox() %>%
    bbox_expander(expansion=expansion) %>%
    sf::st_as_sfc() %>%
    sf::st_transform(sf::st_crs(sf)) }

#' @export
create_frame_from_sfs <- function(..., expansion=0.1) {
  create_frame_from_sf(
    rbind(lapply(list(...), dplyr::select)),
    expansion=expansion)
  }
