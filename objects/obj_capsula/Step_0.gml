if (z > 0) {
    z += zspeed;
    zspeed += zgravity;
	if (rodando)image_angle+=random(40);
}
if (z < 0) {
    z = -z;
    zspeed = abs(zspeed) * 0.6 - 0.7
	
    if (zspeed < 1) {
        z = 0;
        zspeed = 0
		instance_destroy()
		
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
    }
}


