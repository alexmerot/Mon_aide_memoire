library("rayshader")
library("raster")

boundary_box <- extent(
  843442,
  866595,
  6686564,
  6703526
)

cassini <- stack("examples/3d_map/dijon/Carte_générale_de_la_France_Dalier_(17_btv1b53095148b_1_georef.tif")

cassini_croped <- crop(cassini, boundary_box)

# Visualisation du raster RGB :
plotRGB(cassini_croped)

# Transformation en array
cassini_array <- as.array(cassini_croped)

dijon_topo <- raster("examples/3d_map/dijon/BDALTIV2_75M_FXX_0825_6750_MNT_LAMB93_IGN69.asc")
crs(dijon_topo) <- CRS("+init=EPSG:2154")
dijon_topo <- crop(dijon_topo, boundary_box) %>% raster_to_matrix()

# Création des couches pour les ombres
ray_layer <- ray_shade(dijon_topo, zscale = 20, multicore = TRUE)

ambient_layer <- ambient_shade(
  dijon_topo,
  zscale = 10,
  multicore = TRUE,
  maxsearch = 200
)

# On divise par 255 pour avoir des valeurs entre 0 et 1.
# (L'étendue des couleurs RGB est en effet entre 0 et 255.)

# Carte en 2D
(cassini_array/255) %>%
  add_shadow(ray_layer, 0.3) %>%
  add_shadow(ambient_layer, 0) %>%
  plot_map()

# Carte en 3D
(cassini_array/255) %>%
  add_shadow(ray_layer, 0.3) %>%
  add_shadow(ambient_layer, 0) %>%
  plot_3d(dijon_topo, zscale = 30)

# On crée une vue de dessus.
# Je mets ici -90 car la fonction `render_highquality` va inverser cette valeur,
# je ne sais pas si c'est un bug (-90 deviendra la bonne valeur : 90).
render_camera(
  zoom  = 0.5,
  phi   = -90,  # Angle d'azimut (max 90)
  theta = 0   # Angle de rotation
)

render_highquality(
  lightaltitude = 25,
  environment_light = "examples/3d_map/HDRI/kiara_1_dawn_4k.hdr"
)

# zscale plus élevé
(cassini_array/255) %>%
  add_shadow(ray_layer, 0.3) %>%
  add_shadow(ambient_layer, 0) %>%
  plot_3d(dijon_topo, zscale = 60)

# On positionne la caméra sur le côté.
render_camera(
  zoom  = 0.3,
  phi   = 15,  # Angle d'azimut (max 90)
  theta = 55   # Angle de rotation
)

# On rajoute de la profondeur de champs (bokeh)
render_depth(
  focus = 0.52,
  environment_light = "examples/3d_map/HDRI/kiara_1_dawn_4k.hdr"
)

# Meilleure qualité
render_highquality(
  light = TRUE,
  lightaltitude = 25,
  environment_light = "examples/3d_map/HDRI/kiara_1_dawn_4k.hdr"
)

# Caméra pour la vidéo
render_camera(
  zoom  = 0.3,
  phi   = 25,  # Angle d'azimut (max 90)
  theta = 0   # Angle de rotation
)

render_movie(
  "images/3d_map_export/dijon_3d_audio",
  type = "oscillate",
  frames = 720,
  audio = "examples/3d_map/musique/jacques-gallot-suite-in-f-sharp-minor-prelude-a-magical-music.mp3"
)
