
// Feather ignore all

//draw_set_color(c_white);
//draw_sprite_tiled(spr_3d_sun_tex, 0, (camX+camW/2)*0.2, 0+current_time*0.1);

// create surfaces

rainSurfaceA = __ppf_surface_create_secure_size(rainSurfaceA, surfaceWidth, surfaceHeight, surface_rgba8unorm);
rainSurfaceB = __ppf_surface_create_secure_size(rainSurfaceB, surfaceWidth, surfaceHeight, surface_rgba8unorm);

surface_set_target(rainSurfaceB);
	//camera_apply(view_camera[0]);
	draw_set_color(c_black);
	draw_set_alpha(fadeClearAmount);
	draw_rectangle(0, 0, surfaceWidth, surfaceHeight, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	gpu_push_state();
	gpu_set_tex_filter(true);
	gpu_set_blendmode_ext_sepalpha(bm_dest_color, bm_src_color, bm_one, bm_zero); //bm_src_color
	//gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
	
	// draw rain drops
	// single drop
	draw_sprite(__ppf_sprRainNormal, 1, random_range(0, surfaceWidth), random_range(0, surfaceHeight));
	
	// many drops
	rainTimer = max(rainTimer-1, 0);
	if (rainTimer == 0) {
		array_push(raindropList, {
			sprite : __ppf_sprRainNormal,
			sprite_subimg : 0,
			xx : random_range(0, surfaceWidth),
			yy : 0,
			hmov_amplitude : random_range(0.2, 0.5),
			scale : random_range(0.25, 0.4),
			spd : random_range(1, 3),
			alpha : 1,
			fric : 1,
		});
		rainTimer = irandom_range(rainTimerRange1, rainTimerRange2);
	}
	var i = 0, isize = array_length(raindropList);
	repeat(isize) {
		var _reciprocal = i / isize;
		var _drop = raindropList[i];
		var t = current_time*0.001;
		_drop.xx += (sin(t + _drop.spd + sin(t*1.2) * _reciprocal) * _drop.hmov_amplitude) + random_range(-0.5, 0.5);
		_drop.yy += _drop.spd * _drop.fric;
		//_drop.fric = sin(t*0.5*_reciprocal) * 0.2+0.5;
		_drop.scale += random_range(-0.01, 0.01);
		_drop.scale = clamp(_drop.scale, 0.2, 0.8);
		_drop.alpha += choose(0, random_range(-0.02, 0.02))
		
		if (_drop.yy > surfaceHeight+32) {
			array_delete(raindropList, i, 1);
			i -= 1;
		}
		draw_sprite_ext(_drop.sprite, _drop.sprite_subimg, _drop.xx, _drop.yy, _drop.scale, _drop.scale, 0, c_white, _drop.alpha);
		++i;
	}
	
	gpu_pop_state();
	draw_set_color(c_white);
surface_reset_target();


// recursive apply
// use repeat(2) to more fps
rainSurfaceSwap = !rainSurfaceSwap;

var _surf1 = rainSurfaceSwap ? rainSurfaceA : rainSurfaceB;
var _surf2 = rainSurfaceSwap ? rainSurfaceB : rainSurfaceA;

surface_set_target(_surf1);
	draw_clear(make_color_rgb(128, 128, 255));
	//gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	shader_set(__ppf_shBlurBox4);
	shader_set_uniform_f(shader_get_uniform(__ppf_shBlurBox4, "u_texelSize"), 1/surfaceWidth, 1/surfaceHeight);
	draw_surface(_surf2, 0, 0);
	//gpu_set_blendmode(bm_normal);
	shader_reset();
surface_reset_target();



////var _ww = surface_get_width(_surf1);
////var _hh = surface_get_height(_surf1);

////if (!surface_exists(surf_final)) {
////    surf_final = surface_create(_ww, _hh);
////}
////surface_set_target(surf_final);
////	draw_clear(c_black);
////	draw_set_alpha(1);
////	draw_set_color(make_color_rgb(128, 128, 255));
////	draw_rectangle(0, 0, _ww, _hh, false);
////	gpu_set_colorwriteenable(true, true, true, false);
////	draw_surface(_surf2, 0, 0);
////	gpu_set_colorwriteenable(true, true, true, true);
////surface_reset_target();

draw_surface(_surf2, 0, 0);
draw_set_color(c_white);

