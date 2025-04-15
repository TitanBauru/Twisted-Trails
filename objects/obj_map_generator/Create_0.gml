randomize();
inicio = true;
global.cmw = camera_get_view_width(view_camera[0]);
global.cmh = camera_get_view_height(view_camera[0]);

// Configurações
cell_size = 16; // Tamanho do tile, alinhado ao Drunken Walk
buffer = 256;   // Área de geração ao redor da câmera

// Posição inicial do player em células
real_px = obj_player.x / cell_size;
real_py = obj_player.y / cell_size;
px = real_px;
py = real_py;

// IDs da camada de tiles
layer_id = layer_get_id("Tiles_1");
tile_id = layer_tilemap_get_id(layer_id);






