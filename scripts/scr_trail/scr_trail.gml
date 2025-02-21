function color_extract_abgr(color) {
    return {
        a: (color >> 24) & 0xff,
        b: (color >> 16) & 0xff,
        g: (color >> 8) & 0xff,
        r: (color) & 0xff,
    };
}


function trail_count() {
	return array_length(__trail_array)
}


function trail_render(_additive) {
	//if (_additive) {gpu_set_blendmode(bm_add)}
		shader_set(shd_trail)
			for (var i = 0; i < array_length(__trail_array); i++) {
				__trail_array[i].draw()
			}
		shader_reset()
	//if (_additive) {gpu_set_blendmode(bm_normal)}
}

function trail_update(_x1, _y1, _x2, _y2, _color, _alpha) {
	
	// init
	if (is_undefined(self[$ "__trail_initiated"])) {
		__trail_array = []
		__u_trail_color = shader_get_uniform(shd_trail, "u_color")
		__trail_initiated = true
	}	
	
	// add
	array_push(__trail_array, new trail(_x1, _y1, _x2, _y2, _color, _alpha))
	
	// update
	for (var i = 0; i < array_length(__trail_array); i++) {
		var _trail = __trail_array[i]
		_trail.step()
		if (_trail.cleared) {
			array_delete(__trail_array, i, 1)
		}
	}
}

function trail(_x1, _y1, _x2, _y2, _color, _alpha) constructor {
	x1 = _x1
	y1 = _y1
	x2 = _x2
	y2 = _y2
	color = _color
	alpha = _alpha
	thc_back = 3
	thc_front = 3
	cleared = false
	
	step = function() {
		var _fade_spd = 0.4
		thc_back = max(thc_back-_fade_spd, 0)
		thc_front =max(thc_front-_fade_spd, 0)
		//alpha =		 max(alpha-0.01, 0)
		
		if (thc_back <= 0 || alpha <= 0) {
			cleared = true
		}
	}
	
	draw = function() {
		var _dir = point_direction(x1, y1, x2, y2);
		var _len = point_distance(x1, y1, x2, y2);
		if (_len < 2) {return};
		var _lenx_1 = lengthdir_x(thc_back, _dir-90);
		var _leny_1 = lengthdir_y(thc_back, _dir-90);
		var _lenx_2 = lengthdir_x(thc_back, _dir+90);
		var _leny_2 = lengthdir_y(thc_back, _dir+90);
		var _lenx_3 = lengthdir_x(thc_front, _dir-90);
		var _leny_3 = lengthdir_y(thc_front, _dir-90);
		var _lenx_4 = lengthdir_x(thc_front, _dir+90);
		var _leny_4 = lengthdir_y(thc_front, _dir+90);
		
		var _x1 = x1+_lenx_1;
		var _y1 = y1+_leny_1;
		var _x2 = x2+_lenx_3;
		var _y2 = y2+_leny_3;
		var _x3 = x2+_lenx_4;
		var _y3 = y2+_leny_4;
		var _x4 = x1+_lenx_2;
		var _y4 = y1+_leny_2;

		//var _col = make_color_hsv((thc_back/5)*255, 255, 255)
		var _r = ((color)		& 0xff) / 255;
		var _g = ((color >> 8)	& 0xff) / 255;
		var _b = ((color >> 16)	& 0xff) / 255;
		
		
		
		//shader_set_uniform_f(other.u_color, 1, thc_back/5, 1)
		shader_set_uniform_f(other.__u_trail_color, _r, _g, _b, alpha)
		draw_sprite_pos(spr_trail_pixel, 0, 
		_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, 
		1)
		
		var _joint_scl = thc_front / 32
		
		draw_sprite_ext(spr_trail_joint, 0, x2, y2, _joint_scl, _joint_scl, 0, color, thc_front)
	}
}
















