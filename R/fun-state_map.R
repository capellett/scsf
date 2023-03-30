#' @export
#' @title
#' @description Make a basic state map using ggplot
#' @param x
ggmap_state_map <- function(x=T, basin=c('Broad')) {

  basin <-  scsf::basins %>%
    dplyr::filter(Basin == basin)

  main_map <- ggplot2::ggplot() +
    ggplot2::geom_sf(data=frame, alpha=0, linetype='blank', show.legend=FALSE) + # color='red'
    ggplot2::theme(
      panel.background=ggplot2::element_rect(color='black', fill=NA),
      axis.ticks=ggplot2::element_line(color='black'),
      axis.text=ggplot2::element_text(color='black', size=8),
      legend.position='bottom', panel.ontop=TRUE,
      panel.grid=ggplot2::element_blank(),
      axis.title.x=ggplot2::element_blank(),
      axis.title.y=ggplot2::element_blank(),
      legend.box='vertical') # + ggplot2::coord_sf(label_graticule = "SE")

  ## The bbox is a feature in the minimap
  bbox <-ggplot2::ggplot_build(main_map)$layout$panel_params[[1]][c("x_range","y_range")]
  bbox_st <- sf::st_bbox(c(xmin=bbox[[1]][1],ymin=bbox[[2]][1],
                           xmax=bbox[[1]][2],ymax=bbox[[2]][2])) %>%
    sf::st_as_sfc(crs=4326)
  sf::st_crs(bbox_st) <- 4326

  ## Get neighboring features from other wsystems
  bbox_neighborhood <- create_frame_from_sf(frame, 0.5)

  serviceAreas_n <- scwaterdemand::serviceAreas %>%
    sf::st_crop(bbox_neighborhood) %>%
    dplyr::anti_join(
      sf::st_drop_geometry(serviceAreas_i), 'ShapeID') %>%
    dplyr::filter(., category %in% c("Water Supply", "Manufacturing; Water Supply"))

  zones_n <- scwaterdemand::i_zones %>%
    sf::st_crop(bbox_neighborhood) %>%
    dplyr::anti_join(
      sf::st_drop_geometry(zones_i), 'ZoneID') %>%
    dplyr::filter(., category %in% c("Agriculture", "Golf"))

  pipes_n <- scwaterdemand::pipes %>%
    sf::st_crop(bbox_neighborhood) %>%
    dplyr::anti_join(
      sf::st_drop_geometry(pipes_i), 'PipeID') %>%
    dplyr::mutate(TypeCode2 = dplyr::if_else(TypeCode=="D", "D", "W"))

  polygon_labels <- c(
    supply="Water Supply Area", sewer="Sewer Service Area", irrigation="Irrigated Area")

  polygon_colors <- c(
    supply='aquamarine3', sewer='darkgoldenrod4', irrigation='limegreen')

  main_map2 <- main_map +
    ggplot2::geom_sf(data=scsf::counties, fill=NA, size=1.5, color='gray',
                     alpha=0.2) +
    addIfExistPolygons(data=serviceAreas_n, color='gray', alpha=0.1, show.legend='polygon',
                       mapping=ggplot2::aes(fill=Type)) +
    addIfExistPolygons(data=zones_n, fill='limegreen', alpha=0.1, show.legend='polygon') + # color='gray', ) +
    addIfExistMarkers(data=pipes_n, color='gray', show.legend="point",
                      mapping=ggplot2::aes(shape=TypeCode2)) +
    addIfExistPolygons(data=parcels_i, fill=NA, color='gray', size=0.2) +
    addIfExistPolygons(data=serviceAreas_i, alpha=0.4, show.legend='polygon',
                       mapping=ggplot2::aes(fill=Type)) +
    addIfExistPolygons(data=zones_i, fill='limegreen', alpha=0.4, show.legend='polygon') +
    ggplot2::geom_sf(data=basin, color='brown', linetype='dotdash', fill=NA) +
    ggplot2::geom_sf_label(data=serviceAreas_i, size=4, fill=NA, show.legend=FALSE, ## size=8/.pt
                           mapping=ggplot2::aes(label=SYS, color=Type)) +
    ggplot2::scale_fill_manual(
      labels=polygon_labels, values=polygon_colors,
      guide=ggplot2::guide_legend(
        title=NULL, reverse=TRUE, override.aes=list(shape=NA))) +
    ggplot2::scale_color_manual(
      labels=polygon_labels, values=polygon_colors,
      guide=ggplot2::guide_legend(
        title=NULL, reverse=TRUE, override.aes=list(shape=NA))) +
    addIfExistMarkers(data=pipes_i, color='black', show.legend="point",
                      mapping=ggplot2::aes(shape=TypeCode2)) +
    ggrepel::geom_text_repel(
      data=pipes_i, size=4, mapping=ggplot2::aes( ##size=8/.pt
        x=lng, y=lat, label=`#`)) +
    ggplot2::scale_shape_manual(
      labels=c(W="Withdrawal Intake", D="Discharge Outlet"),
      values=c('W'=1, 'D'=2),
      guide=ggplot2::guide_legend(
        title=NULL, reverse=TRUE, override.aes=list(fill=NA))) +
    ggplot2::coord_sf(xlim=bbox$x_range, ylim=bbox$y_range, expand=F)
  # prettymapr::addscalebar()
  # prettymapr::addnortharrow()
  # ggplot2::coord_sf(xlim=c(bbox$xmin, bbox$xmax),
  #                   ylim=c(bbox$ymin, bbox$ymax), expand=F)

  mini_map <- ggplot2::ggplot() +
    ggplot2::geom_sf(
      data=basin, fill='gray', color='brown', linetype='dotted', size=0.2) +
    ggplot2::geom_sf(data=scsf::counties, fill=NA, size=0.1, alpha=0.5) +
    ggplot2::geom_sf(data=bbox_st, size=1.2, color='black', fill=NA) +
    ggplot2::theme_void() +
    ggplot2::theme(panel.background = ggplot2::element_rect(fill = "white"),
                   panel.border = ggplot2::element_rect(size = 0.5, colour = "black", fill=NA))

  out_map <- cowplot::ggdraw() +
    cowplot::draw_plot(main_map2, x=0, y=0, width=1, height=0.8, hjust=0, vjust=0) +
    cowplot::draw_plot(mini_map, x=1, y=0.97, width=0.2, height=0.2, hjust=1, vjust=1)

  return(out_map)}
