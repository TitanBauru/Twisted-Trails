// No objeto: obj_shop_base
// Draw Event

// Calcular valores de animação
var _pulse = (sin(current_time * glow_pulse_speed) * 0.2) + 0.8;
var _shake_x = 0;
var _shake_y = 0;

//// Sombra sob o totem
//draw_sprite_ext(
//    spr_totem_shadow, 0,
//    x, y + 5,
//    1.2 + (_pulse * 0.1), 0.6, 
//    0, c_black, 0.5
//);

// Desenhar o totem com efeitos
draw_sprite_ext(
    sprite_index, image_index,
    x + _shake_x, y + _shake_y + float_offset,
    image_xscale, image_yscale, 
    image_angle + (_shake_x * 0.5), // Leve rotação quando treme
    image_blend, 
    image_alpha
);
