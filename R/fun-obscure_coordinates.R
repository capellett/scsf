#' @title Obscure the latitude and longitude in a given shapefile
#' @description The function obscures the original latitude and longitude
# provided in a shapefile. Input should be of 'sf' class: 'Simple features', A
# simple feature can contain geometry (points, lines, polygons) and coordinate
# reference system, to identify its location on Earth and additional attributes
# that describes the object such as its identity number/name, values, color, etc.
# The original decimal degrees can have 5-6 decimal places.
# (Fifth decimal place is worth 1.1 meters (3.6 ft) and can distinguish trees
# from each other.
# Sixth decimal place is worth 0.11 meters (0.36 ft). Good for laying out a
# structure's details, building roads or landscapes- GIS Stack Exchange
# https://gis.stackexchange.com/questions/8650/measuring-accuracy-of-latitude-and-longitude/.
# "round" function used within this function here is set to round the original
# coordinate decimals degrees to only two decimal places.
# The "jitter" function then adds randomness to the rounded coordinate up to a
# factor of 0.1. The factor adds small difference between the adjacent unique
# data point. This removes the possibility of coordinate points being stacked
# on top of each other.
# This function should only be used when sharing the data set for for external
# use.
#
# Note: Be careful when using this function for a dataset that will used for
# basin wise or county wise water withdrawal analysis. The function can shift
# the original withdrawal location to a neighboring county or basin.
# Example tried:
#
# original example point (-80.387312, 33.033245) for Charleston Water System
# Charleston CPW- Hanahan WTP (10WS004S03- Edisto River intake)
# Volumne Per= 8729.36
# It's withdrawal is located in the Edisto basin (Dorchester county),
# the "round" and "jitter" function (in trial 1) did not shift the withdrawal
# location to another basin or county, off setted by ~ 0.0003 miles.
# 2nd trial (06WS006G08):offset of ~0.0004 miles, no change in county or basin
# 3rd trial (24IN052G01):offset of ~0.0004 miles, no change in county or basin
# 4th trial (46WS001G03):offset of ~0.0003 miles, no change in county or basin
#
# the if statement checks if the input object is of 'sf' and 'data.frame' class.
# the stop argument will show an error if the input object is not of required
# class.
# the st_coordinates function extracts coordinate information from the input
# object and converts it in a data.frame.
# the original latitude and longitudes are rounded and jittered to hide the
# original exact point location.
# the data.frame is converted back to a sf class output along with the geometry
# added.
#' @param x is a shapefile with 'sf' class
#' @return a table of class sf and data.frame with geometry information,
# geographic CRS,and table of geometry (obscured coordinates) and its attributes.
#' @importFrom sf st_coordinates
#' @importFrom dplyr mutate
#' @importFrom sf st_as_sf
#' @importFrom sf st_crs
#' @importFrom tibble tibble
#' @importFrom sf st_set_geometry
#' @importFrom sf st_geometry
#' @importFrom methods is
#' @export
obscure_coordinates <- function(x) {
  if(!c("sf", "data.frame") %in% class(x) %>% all())
  {stop("Invalid class, input object must be of class 'sf' and 'data.frame'")}
  original_coord <- sf::st_coordinates(x) %>%
    data.frame()
  obscured_coord <-
    dplyr::mutate(original_coord,
                  lat = jitter(round(original_coord$Y, 2), .1),
                  lng = jitter(round(original_coord$X, 2), .1)) %>%
    sf::st_as_sf(coords=c("lat", "lng"), crs= sf::st_crs(x),agr= "identity")
  y <- x
  sf::st_set_geometry(y, sf::st_geometry(obscured_coord))
  return(y)
}
