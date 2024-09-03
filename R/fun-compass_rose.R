
# ## ggspatial package has nice map annotation.
# ## two styles of north arrow that I like
## I'd like to eliminate the word "north" from the simple one
## and make it a more typical looking arrow. (not one-sided)

### a simple north arrow:
#' @export
north_arrow1 <- function(...) {
  ggspatial::annotation_north_arrow(
    ..., which_north = "true", location = 'br',
    mapping = NULL, data = NULL,
    height = grid::unit(1.5, "cm"),
    width = grid::unit(1.5, "cm"),
    pad_x = grid::unit(0.25, "cm"),
    pad_y = grid::unit(0.25, "cm"),
    rotation = NULL,
    style = ggspatial::north_arrow_orienteering(
      line_width = 1,
      line_col = "black",
      fill = c("white", "black"),
      text_col = "black",
      text_family = "",
      text_face = NULL,
      text_size = 10,
      text_angle=0))
}

#' @export
north_arrow2 <- function(...) {
  ggspatial::annotation_north_arrow(
    ..., which_north = "true", location = 'br',
    mapping = NULL, data = NULL,
    height = grid::unit(1.5, "cm"),
    width = grid::unit(1.5, "cm"),
    pad_x = grid::unit(0.25, "cm"),
    pad_y = grid::unit(0.25, "cm"),
    rotation = NULL,
    style = ggspatial::north_arrow_minimal(
      line_width = 1,
      line_col = "black",
      fill = "black",
      text_col = "black",
      text_family = "",
      text_face = NULL,
      text_size = 10))
}




## Do want at least one direction label on this one.
### a fancier compass rose

#' @export
compass_rose <- function(...) {
  ggspatial::annotation_north_arrow(
    ..., which_north = "true", location = 'br',
    mapping = NULL, data = NULL,
    height = grid::unit(1.5, "cm"),
    width = grid::unit(1.5, "cm"),
    pad_x = grid::unit(0.25, "cm"),
    pad_y = grid::unit(0.25, "cm"),
    rotation = NULL,
    style = ggspatial::north_arrow_nautical(
      line_width = 1,
      line_col = "black",
      fill = c("black", "white"),
      text_size = 10,
      text_face = NULL,
      text_family = "",
      text_col = "black",
      text_angle = 0
    ))
}
