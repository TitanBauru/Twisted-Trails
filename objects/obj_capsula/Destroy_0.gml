/// @description Insert description here
// You can write your code in this editor
if (surface_exists(global.surface_blood))
{
	surface_set_target(global.surface_blood)
	
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
	
	surface_reset_target()
}
else
{
	global.surface_blood = surface_create(room_width,room_height)	
}