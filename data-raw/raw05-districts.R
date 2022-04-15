## This script is to identify legislative districts by regulatory basin
congress_districts <- st_read('data-raw//sourcefiles//RFA-districts//H3992.shp') 

house_districts <- st_read('data-raw//sourcefiles//RFA-districts//H3991.shp')
  
senate_districts <-st_read('data-raw//sourcefiles//RFA-districts//S815.shp')

regB <- st_read('data-raw//sourcefiles//SCBasins.shp') %>%
  st_transform(st_crs(congress_districts))


senate.S815 = st_intersection(senate_districts, regB) %>% 
  select(District, Basin) %>%
  mutate(lon = map_dbl(geometry, ~st_point_on_surface(.x)[[1]]),
       lat = map_dbl(geometry, ~st_point_on_surface(.x)[[2]]))

house.H3991 = st_intersection(house_districts, regB) %>% 
  select(District, Basin) %>%
  mutate(lon = map_dbl(geometry, ~st_point_on_surface(.x)[[1]]),
         lat = map_dbl(geometry, ~st_point_on_surface(.x)[[2]]),
         District=str_sub(District, 4))

congress.H3992 = st_intersection(congress_districts, regB) %>% 
  select(District, Basin) %>%
  mutate(lon = map_dbl(geometry, ~st_point_on_surface(.x)[[1]]),
         lat = map_dbl(geometry, ~st_point_on_surface(.x)[[2]]))

map_districts <- function(x) {
  ggplot(data=x) + 
    geom_sf(aes(fill=Basin, alpha=.1)) +
    ggrepel::geom_text_repel(
      aes(label=District, x=lon, y=lat, 
          colour=Basin, fontface='bold', alpha=2)) +
    guides(alpha=FALSE) }

map_districts(senate.S815) +
  ggtitle("Senate.S815 intersections with regulatory basins",
          "C. Alex Pellett, 11/4/2019")

map_districts(house.H3991) +
  ggtitle("House.H3991 intersections with regulatory basins",
          "C. Alex Pellett, 11/4/2019")

map_districts(congress.H3992) +
  ggtitle("Congress.H3992 intersections with regulatory basins",
          "C. Alex Pellett, 11/4/2019")

output_table <- 
  bind_rows(
    "senate.S815" = st_drop_geometry(senate.S815),
    "house.H3991" = st_drop_geometry(house.H3991),
    "congress.H3992" = st_drop_geometry(congress.H3992),
    .id='Type')

output_table1 <- output_table %>%
  group_by(Type, Basin) %>%
  summarise(Districts = comma_and(District)) %>%
  ungroup() %>%
  select(Basin, Type, Districts) %>%
  arrange(Basin, Type)

output_table2 <- output_table %>%
  select(Type, District, Basin) %>%
  mutate(Value=1) %>%
  spread(Basin, Value, fill=0)
  
write_excel_csv(output_table1, 'districts_by_basin1.csv')
write_excel_csv(output_table2, 'distrincts_by_basin2.csv')

getwd()

table(test[,c("District", "Basin")])


############# attach service areas to edisto permits,
############# and see what political districts they are in
############# (if they are outside the Edisto).
test_user_joins3 <- filter(test_user_joins2, UserID !='6')

test_user_permits2 <- dplyr::filter(
  permits_baseline, PermitID %in% unique(test_user_joins3$PermitID))

AreasServed2 <- AreasServed %>%
  inner_join(test_user_permits2, c("DistributionID"="PermitID")) %>%
  rename(WaterSupplier=Name) %>%
  st_buffer(dist=0) ## this fixes some topological issues

# serviceAreas2 <- inner_join(serviceAreas, test_user_permits) ## 0

ggplot(AreasServed2) + 
  geom_sf(data=regB) +
  geom_sf(fill='black')

congress_districts <- st_read('sourcefiles//RFA-districts//H3992.shp') %>%
  st_transform(st_crs(AreasServed2))

house_districts <- st_read('sourcefiles//RFA-districts//H3991.shp') %>%
  st_transform(st_crs(AreasServed2))

senate_districts <-st_read('sourcefiles//RFA-districts//S815.shp') %>%
  st_transform(st_crs(AreasServed2))

get_user_districts <- function(x) {
  st_intersection(x, st_transform(AreasServed2, st_crs(x))) %>%
    select(District, WaterSupplier) %>%
    st_drop_geometry() %>% unique() }

senate.edisto = get_user_districts(senate_districts)

house.edisto = get_user_districts(house_districts)

congress.edisto = get_user_districts(congress_districts)

output_edisto <- 
  bind_rows(
    "senate.S815" = senate.edisto,
    "house.H3991" = house.edisto,
    "congress.H3992" = congress.edisto,
    .id='Type')

## output_table2 is from districts.R
output_table3 <- anti_join(
  output_edisto,
  filter(output_table2, Edisto==1),
  by=c("Type", "District"))

write_excel_csv(output_table3, 'edisto_districts_by_WaterSupply.csv')

# rm(congress_districts, congress.edisto, congress.H3992, house_districts, house.edisto, house.H3991)
# rm(senate_districts, senate.edisto, senate.S815)
# rm(output_edisto, output_table, output_table2, output_table3)

