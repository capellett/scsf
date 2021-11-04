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
