/// @description Insert description here
// You can write your code in this editor
// 3) Fala que agora vamos desenhar nessa surface
if (desenhar = false)
{
surface_set_target(global.surf_sombras);
draw_clear_alpha(c_black, 0); // limpa com alpha 0

// 4) Desenha todas as sombras DE UMA VEZ
shader_set(shd_tile_shadow);
with (obj_vacuo) {
    if !place_meeting(x, y + 1, obj_vacuo) {
        draw_sprite_ext(sprite_index, image_index, x, y + 16,
            image_xscale, image_yscale, image_angle, c_white, 0.5);
    }
}

shader_reset();
// 5) Para de desenhar na surface
surface_reset_target();
}

