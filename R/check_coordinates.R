#' @title Point in or outside the South Carolina state boundary.
#' @description Checks if a point with longitude and latitude information, lies
# inside the "SC boundary" polygon. Input object should be of 'sf' class.
# SC_boundary is a South Carolina state boundary shapefile used to check
# if all the withdrawal locations in the shapefile are within the state
# boundary.
# The 'st_transform' function is used to transform the coordinate
# system of the input object (here, 'x') to match the coordinate system of the
# SC_boundary shapefile.
# The 'st_contains' function is used to find if the point withdrawals in the
# point shapefile falls within the SC_boundary polygon. As the SC_boundary
# shapefile had two polygons, one of them is a 3 mile coastal extension polygon,
# apply(2, any) was used to include the second polygon as well when using the
# st_contains function.
#' @param x is a point shapefile with two of its columns for longitude and
# latitude.
#' @return a logical output (TRUE if point lies inside the polygon)
#' @importFrom sf st_transform
#' @importFrom sf st_crs
#' @importFrom sf st_contains
#' @export
check_points_in_SC <- function(x) {
  if(!c("sf", "data.frame") %in% class(x) %>% all())
    {stop("Invalid class, input object must be of class 'sf' and 'data.frame'")}
  coord_prj <- sf::st_transform(x, sf::st_crs(SC_boundary_new))
  sf::st_contains(SC_boundary_new, coord_prj,sparse = FALSE) %>% apply(2, any) %>%
    return()
}


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

#' @title Drop geometry
#' @description the function can remove geometry from a data set with class 'sf'
#  i.e removes the crs and geometry information.
# 'SC_boundary' is a shape file with class 'sf' and 'data.frame'.
# When the shape file is viewed it has two polygons, each with attributes
# (columns of) for 'State', 'Area', 'Name', 'Shape_Area', 'Shape_Len', 'XCoord',
# 'YCoord', 'geometry', and CRS information.
# After using this function, the attribute columns are preserved, except
# geometry column. Thereby converting the shape file into a regular data frame.
#' @param x a shape file with class 'sf' and 'data.frame'
#' @importFrom sf st_drop_geometry
#' @return a data.frame
#' @export
st_drop_geometry_if <- function(x) {
  if(is(x, "sf")) {
    return(sf::st_drop_geometry(x))
  } else {
    return(x)}
}


#' @title Convert projection
#' @description function converts projections
#' @param x dataframe, column, vector
#' @importFrom sp spTransform
#' @export
convCRS <- function(x) {
  sp::spTransform(
    x, "+init=epsg:4269 +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0") }
