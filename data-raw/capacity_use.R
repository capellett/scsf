## Consider providing spatial polygons of capacity use areas?
## or is it easier just to join to counties...

capacity_use <- tibble::tribble(
  ~Name, ~Date_Established, ~Counties, ~Aliases,
  "Waccamaw", "6/22/1979", c("Horry", "Georgetown"), "waccamaw",
  "Lowcountry", "7/24/1981", c("Jasper", "Beaufort", "Colleton"), "Low Country",
  "Hampton (Lowcountry)", "6/10/2008", c("Hampton"), "",
  "Trident", "8/8/2002",  c("Charleston", "Berkeley", "Dorchester"), "trident",
  "Pee Dee", "2/12/2004", c("Marion", "Marlboro", "Darlington", "Dillon", "Florence", "Williamsburg"), "PeeDee",
  "Western", "11/8/2018", c("Aiken", "Bamberg", "Barnwell", "Calhoun", "Allendale", "Lexington", "Orangeburg"), "western",
  "Santee-Lynches", "7/15/2021", c("Chesterfield", "Clarendon", "Kershaw", "Lee", "Richland", "Sumter"), "SanteeLynches")

usethis::use_data(capacity_use, overwrite=T)

capacity_use_counties <- tidyr::unnest(capacity_use, Counties) %>%
  dplyr::select(County = Counties, cap_use_zone = Name)

usethis::use_data(capacity_use_counties, overwrite=T)

## This is a rough draft
## I copied it above to edit, bc I didn't want to mess up the "original" text I copied form.
# capacity_use <- tibble::tribble(
#   ~Name, ~Date_Established, ~Counties, ~Aliases,
#   "Waccamaw", "June 22, 1979, Horry and Georgetown Counties
# "Lowcountry" – established July 24, 1981, Jasper, Beaufort, and Colleton Counties (Hampton County added June 10, 2008)
# "Trident" – established August 8, 2002, Charleston, Berkeley, and Dorchester Counties
# "Pee Dee" – established February 12, 2004, Marion, Marlboro, Darlington, Dillon, Florence, and Williamsburg Counties.
# "Western" – established November 8, 2018, Aiken, Bamberg, Barnwell, Calhoun, Allendale, Lexington, and Orangeburg Counties.
# "Santee-Lynches" – established July 15, 2021, Chesterfield, Clarendon, Kershaw, Lee, Richland, and Sumter Counties.
# )
