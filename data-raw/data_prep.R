#Steps to import spatial data and save it as an sf object in this R package
## 1. save the spatial data into the data-raw folder, include any documentation that came with it.
## 2. import the data using sf::st_read()
## 3. Modify as needed. For example, select and rename columns, or remove extraneous features.
## 4. usethis::use_data()
## 5. Create an .R file in the R folder to document the data object.
## See the existing .R files for formatting examples.
library(tidyverse)

### State Boundary
boundary <- sf::st_read("data-raw//SC_boundary_new.shp") %>%
  dplyr::select() # %>% sf::st_transform(4269)

usethis::use_data(boundary)

# boundary2 <- sf::st_cast(boundary, "POLYGON")
# usethis::use_data(boundary2)


####### Basins
## The SC_major_river_basins shapefile was downloaded from the SCDHEC's website
## https://sc-department-of-health-and-environmental-control-gis-sc-dhec.hub.arcgis.com/datasets/sc-major-river-basins/explore?location=33.617600%2C-80.935600%2C8.34
## The shapefile was then edited to extend a small coastal region of the Santee basin,
## to match the latest SC boundary shapefile.
## Not all of the shapefile is edited to match the coastal extent of the latest SC Boundary shapefile.
basins <- sf::st_read(
  dsn = "C:/Users/morep/Documents/R_package/scwaterwithdrawaldata/data_DHEC/GIS_data/SC_Major_River_Basins.shp") %>%
  dplyr::select(c(-OBJECTID,-Document, -Archived_S)) %>%
  dplyr::rename('Spatial_basin' = 'Basin' ) %>%
  st_transform(st_crs(ground_with_coord_sf)) %>%
  sf::st_as_sf() %>%
  dplyr::select(basin=BASIN8)

usethis::use_data(basins)

basins <- sf::st_transform(basins, 4269)

basins <- dplyr::rename(basins, Basin=basin)

usethis::use_data(basins, overwrite=T)

######## Counties
counties <- sf::st_read("data-raw//counties.shp") %>%
  dplyr::select(County=COUNTYNM) %>%
  # sf::st_as_sf() %>%
  sf::st_transform(4269)

# counties <- SC_counties %>%
#   dplyr::select(County=COUNTYNM) %>%
#   # sf::st_as_sf() %>%
#   sf::st_transform(4269)

usethis::use_data(counties)


## Add capacity use and drought management attributes
capacity_use <- tibble::tribble(
  ~Name, ~Date_Established, ~Counties, ~Aliases,
  "Waccamaw", "6/22/1979", c("Horry", "Georgetown"), "waccamaw",
  "Lowcountry", "7/24/1981", c("Jasper", "Beaufort", "Colleton"), "Low Country",
  "Hampton (Lowcountry)", "6/10/2008", c("Hampton"), "",
  "Trident", "8/8/2002",  c("Charleston", "Berkeley", "Dorchester"), "trident",
  "Pee Dee", "2/12/2004", c("Marion", "Marlboro", "Darlington", "Dillon", "Florence", "Williamsburg"), "PeeDee",
  "Western", "11/8/2018", c("Aiken", "Bamberg", "Barnwell", "Calhoun", "Allendale", "Lexington", "Orangeburg"), "western",
  "Santee-Lynches", "7/15/2021", c("Chesterfield", "Clarendon", "Kershaw", "Lee", "Richland", "Sumter"), "SanteeLynches") %>%
  dplyr::select(Capacity_Use_Zone = Name, Capacity_Use_Date = Date_Established,
                County=Counties) %>%
  tidyr::unnest(cols=c(County))

counties2 <- dplyr::left_join(counties, capacity_use)

counties2 %>% sf::st_drop_geometry() %>% View()




### the custom CRS used in the GMS Groundwater Model
crs_GMS <- readRDS("~/Rpackages/scsf/data-raw/crs_GMS.rds")
usethis::use_data(crs_GMS)

crs_leaflet <- '+proj=longlat +datum=WGS84'
usethis::use_data(crs_leaflet)
