# ggspatial::annotation_scale()
## can be used as parameters or aesthetics.
## aesthetics when  different scale bar in different panels.
## Otherwise, just pass them as arguments to annotation_scale.

## width_hint: The (suggested) proportion of the plot area which the scalebar should occupy.
## unit_category: Use "metric" or "imperial" units.
## style: One of "bar" or "ticks"
## location: Where to put the scale bar ("tl" for top left, etc.)
## line_col and text_col: Line and text colour, respectively


scale_bar <- function(...){
  ggpspatial::annotation_scale(
    mapping = NULL,
    data = NULL,
    width_hint = 0.5,
    unit_category = "imperial",
    style = 'bar',
    location = 'bl',
    plot_unit = NULL,
    bar_cols = c("black", "white"),
    line_width = 1,
    height = unit(0.25, "cm"),
    pad_x = unit(0.25, "cm"),
    pad_y = unit(0.25, "cm"),
    text_pad = unit(0.15, "cm"),
    text_cex = 0.7,
    text_face = NULL,
    text_family = "",
    tick_height = 0.6)
  }
