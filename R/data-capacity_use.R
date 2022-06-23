#' @title capacity_use
#' @description A table of capacity use zones in SC (not spatial)
#' @format A \code{data.frame} with columns:
#' \describe{
#' \item{Name}{Name of capacity use zone}
#' \item{Date_Established}{date the capacity use zone was formally established}
#' \item{Counties}{A list column of counties in each zone}
#' \item{Aliases}{Other ways of spelling the Name of the zone}
#' }
"capacity_use"


#' @title capacity_use_counties
#' @description A table to join counties and capacity use zones
#' @format A \code{data.frame} with columns:
#' \describe{
#' \item{County}{Name of the county}
#' \item{cap_use_zone}{Name of capacity use zone}
#' }
"capacity_use_counties"

