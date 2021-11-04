############################
## The SC_major_river_basins shapefile was downloaded from the SCDHEC's website
## https://sc-department-of-health-and-environmental-control-gis-sc-dhec.hub.arcgis.com/datasets/sc-major-river-basins/explore?location=33.617600%2C-80.935600%2C8.34
## The shapefile was then edited to extend a small coastal region of the Santee basin,
## to match the latest SC boundary shapefile.
## Not all of the shapefile is edited to match the coastal extent of the latest SC Boundary shapefile.

SC_major_river_basins_edited <- sf::st_read(dsn = "C:/Users/morep/Documents/R_package/scwaterwithdrawaldata/data_DHEC/GIS_data/SC_Major_River_Basins.shp") %>%
  dplyr::select(c(-OBJECTID,-Document, -Archived_S)) %>%
  dplyr::rename('Spatial_basin' = 'Basin' ) %>%
  st_transform(st_crs(ground_with_coord_sf))
