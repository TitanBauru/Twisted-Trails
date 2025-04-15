/// @desc Tile Connection

// Verifica se há um tile (obj_vacuo) em cada direção adjacente (1 pixel de deslocamento)
// "l" significa "left" (esquerda)
var l = place_meeting(x - 1, y, obj_vacuo), // Checa se existe tile à esquerda
    // "r" significa "right" (direita)
    r = place_meeting(x + 1, y, obj_vacuo), // Checa se existe tile à direita
    // "t" significa "top" (cima)
    t = place_meeting(x, y - 1, obj_vacuo), // Checa se existe tile acima
    // "b" significa "bottom" (baixo)
    b = place_meeting(x, y + 1, obj_vacuo); // Checa se existe tile abaixo
    // As verificações diagonais estão comentadas, mas seriam:
    // lt -> left-top (canto superior esquerdo)
    // rt -> right-top (canto superior direito)
    // lb -> left-bottom (canto inferior esquerdo)
    // rb -> right-bottom (canto inferior direito)

// Se não houver nenhum tile nos quatro lados (tile isolado), destrói a instância atual
if (!l && !r && !t && !b) {
    instance_destroy();
}


// Verifica várias combinações de tiles vizinhos para determinar onde criar colisor (parede)
// O comando CRIA_PAREDE (definido em outro lugar) adiciona colisão nas bordas conforme a necessidade
if (!l && r && t && b)         CRIA_PAREDE; // Sem tile à esquerda
if (l && !r && t && b)         CRIA_PAREDE; // Sem tile à direita
if (l && r && !t && b)         CRIA_PAREDE; // Sem tile acima
if (l && r && t && !b)         CRIA_PAREDE; // Sem tile abaixo
if (!l && !r && t && !b)       CRIA_PAREDE; // Somente tile acima presente
if (!l && !r && !t && b)       CRIA_PAREDE; // Somente tile abaixo presente
if (!l && r && !t && !b)       CRIA_PAREDE; // Somente tile à direita presente
if (l && !r && !t && !b)       CRIA_PAREDE; // Somente tile à esquerda presente
if (l && r && !t && !b)        CRIA_PAREDE; // Tiles à esquerda e direita, mas sem acima e abaixo
if (!l && !r && t && b)        CRIA_PAREDE; // Tiles acima e abaixo, sem laterais
if (!l && r && !t && b)        CRIA_PAREDE;
if (!l && r && t && !b)        CRIA_PAREDE;
if (l && !r && t && !b)        CRIA_PAREDE;
if (l && !r && !t && b)        CRIA_PAREDE;

// Inicializa a variável "a" que definirá qual frame (sprite) o tile vai usar
var a = 0;

// Determina o frame da sprite com base nos vizinhos e define se o tile é "borda" (parte externa)
// Cada condição abaixo confere uma configuração de tiles ao redor e atribui um índice específico (a)
if (!l && r && !t && !b) { 
    a = 0;  // Sem tile à esquerda, mas com à direita (lado direito isolado)
    borda = true; 
}
else if (l && r && !t && !b) { 
    a = 1;  // Tiles em ambos os lados, mas sem acima e abaixo (meio lateral)
    borda = true; 
}
else if (l && !r && !t && !b) { 
    a = 2;  // Sem tile à direita, mas com à esquerda (lado esquerdo isolado)
    borda = true; 
}
else if (!l && !r && !t && b) { 
    a = 3;  // Sem tiles laterais e acima, mas com tile abaixo (parte inferior)
    borda = true; 
}
else if (!l && r && !t && b) { 
    a = 5;  // Sem tile à esquerda, com tiles à direita e abaixo
    borda = true; 
}
else if (l && r && !t && b) { 
    a = 6;  // Tiles à esquerda e direita, sem acima mas com abaixo
    borda = true; 
}
else if (l && !r && !t && b) { 
    a = 7;  // Sem tile à direita, com tiles à esquerda e abaixo
    borda = true; 
}
else if (!l && !r && t && b) { 
    a = 8;  // Sem tiles laterais, mas com tiles acima e abaixo (coluna central)
    borda = true; 
}
else if (!l && r && t && b) { 
    a = 10; // Sem tile à esquerda, mas com os demais (quase cercado)
    borda = true; 
}
else if (l && !r && t && b) { 
    a = 11; // Sem tile à direita, mas com os demais (quase cercado)
    borda = true; 
}
else if (!l && !r && t && !b) { 
    a = 12; // Sem tiles laterais e abaixo, mas com tile acima (parte superior)
    borda = true; 
}
else if (!l && r && t && !b) { 
    a = 15; // Sem tile à esquerda, com tiles à direita e acima, mas sem abaixo
    borda = true; 
}
else if (l && r && t && !b) { 
    a = 16; // Tiles à esquerda, direita e acima, mas sem tile abaixo
    borda = true; 
}
else if (l && !r && t && !b) { 
    a = 17; // Sem tile à direita, com tiles à esquerda e acima, mas sem abaixo
    borda = true; 
}
else if (l && r && t && b)  { 
    a = 20; // Tile completamente cercado por outros tiles (não é borda)
    borda = false; 
	
}

// Realiza uma segunda verificação, mas agora com um offset maior (8 pixels)
// Isso serve para conferir se a conexão com tiles distantes está completa
var l2 = place_meeting(x - 16, y, obj_vacuo), // Verifica tile à esquerda com 8px de deslocamento
    r2 = place_meeting(x + 16, y, obj_vacuo), // Verifica tile à direita com 8px de deslocamento
    t2 = place_meeting(x, y - 16, obj_vacuo), // Verifica tile acima com 8px de deslocamento
    b2 = place_meeting(x, y + 16, obj_vacuo); // Verifica tile abaixo com 8px de deslocamento

// Se o tile não for uma borda (ou seja, está completamente cercado),
// mas faltar conexão em alguma direção considerando o offset de 8px, 
// ajusta o frame para 21 (provavelmente para indicar uma conexão incompleta ou transição)
if (!borda && (!l2 || !r2 || !t2 || !b2)) {
    a = 21;
}

// Aplica o índice do frame definido à sprite do tile, atualizando sua aparência
image_index = a;

// Krug: tile prop creation
var _wall_frames = [0, 1, 2, 12, 15, 16, 17]
var _prop_ids = [1, 2, 4, 5]
if (array_contains(_wall_frames, image_index)) {
	var _chance = 0.5
	if (random(1) < _chance) {
		show_debug_message("tile created")
		var _tilemap_id = layer_tilemap_get_id(layer_get_id("tile_props_wall"))
		var _tile_w = tilemap_get_tile_width(_tilemap_id)
		var _tile_h = tilemap_get_tile_height(_tilemap_id)
		var _tile_id = _prop_ids[irandom(array_length(_prop_ids)-1)]
		var _x = x div _tile_w
		var _y = y div _tile_h
		tilemap_set(_tilemap_id, _tile_id, _x, _y)
		
	}
}










