// No objeto: obj_item
// Draw Event


// Desenhar o item com efeitos
draw_sprite_ext(
    sprite_index, image_index,
    x, y,
    image_xscale, image_yscale,
    image_angle, c_white, image_alpha
);

// Desenhar brilho (se houver uma cor de brilho definida)
if (variable_instance_exists(id, "glow_color")) {
    gpu_set_blendmode(bm_add);
    draw_circle_color(
        x, y,
        10,
        c_white, c_black, false
    );
    gpu_set_blendmode(bm_normal);
}

// Desenhar raridade (opcional)
if (rarity != "" && rarity != "Comum") {
    var _rarity_color;
    switch (rarity) {
        case "Incomum": _rarity_color = c_lime; break;
        case "Raro": _rarity_color = c_blue; break;
        case "Lendário": _rarity_color = c_purple; break;
        default: _rarity_color = c_white; break;
    }
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_color(x, y + 20, rarity, _rarity_color, _rarity_color, _rarity_color, _rarity_color, 0.7);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}