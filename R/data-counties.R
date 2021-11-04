#' @title The Counties of South Carolina
#' @description The county shapefile will be used for checking
#' differences between useid id and spatial location county names.
#' SCDHEC's sw and gw sourceids have county names associated by the county code in its
#' userid or sourceid. The county information might not match the county location according to
#' their spatial (lat/long) coordinates. Usually, if the user's main location is located in for
#' example county x and it has its sources spread out in the same or neighboring county
#' then they labeled under the main county name. This can be a potential problem when we are looking at withdrawals
#' by counties. To avoid this confusion we want to include both, the spatial and userid county location for a source of
#' withdrawal.
#' @format A \code{sf and data.frame} with geometry and multiple column
#  attributes, two of which are:
#' \describe{
#' \item{COUNTYNM}{County name}
#' \item{SHAPE_AREA}{County's area}
#' \item{SHAPE_LEN}{County's length}
#' \item{geometry}{County's lat long}
#' }
"counties"
