
#' creates the legend for the custom ggplot
#'
#' @param data df that contains relevant info: the path and filename of the PNG image and size of image to be drawn to legend
#' @param size size of key realtive to overall plot used to scale the size of the image within the legend
#'
draw_key_wick <- function(data, size) {

  im <- png::readPNG(data$image_filename)

  aspect <- dim(im)[1]/dim(im)[2]

  grid::rasterGrob(
    image  = im,
    width  = ggplot2::unit(data$size / size         , 'snpc'),
    height = ggplot2::unit(data$size / size * aspect, 'snpc')
  )
}




#' geom_wick constructs a new layer for ggplot2 layer via the GeomWick for geom argument
#'
#' @param mapping aesthetic mapping what variables are mapped to x, y
#' @param data what data set to use
#' @param stat statistical transformation default is identity aka no transformation
#' @param position position for overlapping elements set to default
#' @param ...
#' @param na.rm whether to remove NA values set to the default false
#' @param show.legend include or not the legend
#' @param inherit.aes set to true to inherit aesthetics from the global settings
#'
#' @export
geom_wick <- function(mapping     = NULL,
                      data        = NULL,
                      stat        = "identity",
                      position    = "identity",
                      ...,
                      na.rm       = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {
  layer(
    data        = data,
    mapping     = mapping,
    stat        = stat,
    geom        = GeomWick,
    position    = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params      = list(
      na.rm    = na.rm,
      ...
    )
  )
}


#' GeomWick define the new geom
#' @export
GeomWick <- ggplot2::ggproto(
  "GeomWick", ggplot2::Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size"),
  default_aes = ggplot2::aes(
    shape  = 19,
    colour = "black",
    size   = 1.5,
    fill   = NA,
    alpha  = NA,
    stroke = 0.5,
    image_filename  = system.file("wick.png", package = "geomwick", mustWork = TRUE),
    scale = 5
  ),

  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {

    coords <- coord$transform(data, panel_params)

    im <- png::readPNG(coords$image_filename)
    aspect <- dim(im)[1]/dim(im)[2]

    grid::rasterGrob(
      image  = im,
      x      = coords$x,
      y      = coords$y,
      width  = ggplot2::unit(coords$size * coords$scale         , 'pt'),
      height = ggplot2::unit(coords$size * coords$scale * aspect, 'pt')
    )

  },

  draw_key = draw_key_wick
)
