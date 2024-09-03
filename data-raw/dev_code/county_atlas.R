library(sf)
library(ggplot2)
library(purrr)
library(gridExtra)

generate_atlas <- function(sc_counties, plots_list) {
  # Ensure the input is an sf object
  if (!inherits(sc_counties, "sf")) {
    stop("sc_counties must be an sf object")
  }

  # Ensure the input is a list of ggplot objects
  if (!is.list(plots_list) || !all(sapply(plots_list, inherits, "gg"))){
    stop("plots_list must be a list of ggplot objects")
  }

  # Get the list of county names
  county_names <- unique(sc_counties$County)

  # Loop over each county
  for (county in county_names) {
    # Subset the sf object for the current county
    county_map <- sc_counties[sc_counties$NAME == county, ]

    # Create a plot of the county map
    county_plot <- ggplot() +
      geom_sf(data = county_map) +
      ggtitle(paste0("County: ", county))

    # Combine the county map with the list of plots
    all_plots <- c(list(county_plot), plots_list)

    # Arrange the plots in a grid
    grid_plot <- do.call(grid.arrange, all_plots)

    # Save the grid of plots as a PDF
    ggsave(paste0(county, ".pdf"), grid_plot, width = 11, height = 17)
  }
}


load("~/Rpackages/scsf/data/counties.rda")

counties2 <- counties %>%
  dplyr::mutate(County = stringr::str_to_upper(County))

population <- scpopulation::pop22

pop_plot_list <- lapply(counties2$County, FUN = function(county){
  pop <- dplyr::filter(population, County == county)
  county_plot <- ggplot2::ggplot(data=pop, mapping = ggplot2::aes(x=Year, y=Population, group=Type, color=Type)) +
    ggplot2::geom_line()
  return(county_plot)
})


generate_atlas(counties2, pop_plot_list)
