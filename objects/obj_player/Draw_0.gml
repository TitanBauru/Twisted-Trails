
shader_set(shd_tile_shadow);



draw_sprite_ext(sprite_index, image_index, x, y, xscale, -0.6, 0, -1, .5);



shader_reset();



draw_sprite_ext(
	sprite_index,
	image_index,
	x,
	y,
	xscale * lado,
	yscale,
	image_angle,
	image_blend,
	image_alpha
);

