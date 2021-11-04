#' @title South Carolina state boundary shapefile documentation
#' @description The shapefile will be used for checking location errors for
#' withdrawal points of the sourceids. This .R file is created to document the dataset
#' and is similar to documenting a function, but instead here the name of the dataset
#' is used to document it. The shapefile also includes the 3 mile coastal extension area.
#' @format A \code{sf and data.frame} with geometry and multiple column
#  attributes, two of which are:
#' \describe{
#' \item{XCoord}{longitude}
#' \item{YCoord}{latitude}
#' }
"SC_boundary_new"

#Steps to import a shapefile and save it as a .rda file:
# 1. import shapefile:
# SC_boundary_new <- sf::st_read("C:/Users/morep/Documents/R_package/scwaterwithdrawaldata/data_DHEC/GIS_data/SC_boundary_new.shp")

# 2. Create a .R file to describe the shapefile data.

# 3. Save data as .rda:
# save(SC_boundary_new, file = "data_DHEC/GIS_data/SC_boundary_new.rda")
