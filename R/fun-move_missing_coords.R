#' @export
moveMissingCoords <- function(x, default_lat=32, default_lng=-75) {
  is_misplaced <- function(i) {i==0 | is.na(i)}
  if('located' %in% names(x) ) {
    y <- x %>%
      dplyr::mutate(
        located =
          dplyr::if_else(is_misplaced(x$lat) | is_misplaced(x$lng), FALSE, x$located))
  } else {
    y <- x %>%
      dplyr::mutate(located = !(is_misplaced(x$lat) | is_misplaced(x$lng)))
  }

  z <- y %>% dplyr::mutate(
    located = dplyr::if_else(is.na(y$located), FALSE, y$located))

  out <- z %>% dplyr::mutate(
    lat = dplyr::if_else(!z$located, default_lat, z$lat),
    lng = dplyr::if_else(!z$located, default_lng, z$lng))
  return(out)}
