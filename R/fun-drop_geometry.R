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
