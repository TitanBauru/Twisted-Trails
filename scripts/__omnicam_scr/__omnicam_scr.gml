
#macro OMNICAM	__omnicam_obj

//=============================================================
#region General

///@desc Seta a escala da janela em que o jogo será renderizado
function omnicam_scale(_scale) {
	with (OMNICAM) {
		cam_scale = _scale
		window_update(true)
	}
}

///@desc Ativa ou desativa o modo pixel perfect, dando a opção de mover a câmera suavemente
function omnicam_pixelperfect(_enable, _smooth) {
	with (OMNICAM) {
		cam_pixel	= _enable
		cam_smooth	= _smooth
	}
}

///@desc Alterna entre modo tela cheia e modo janela, com opção de tela cheia sem bordas
function omnicam_fullscreen(_full = -1, _borderless = true) {	
	window_enable_borderless_fullscreen(_borderless)
	
	if (_full == -1) {
		// Auto mode
		if (window_get_fullscreen()) {
			window_set_fullscreen(false)
		} else {
			window_set_fullscreen(true)
		}
	} else {
		// Manual mode		
		if (_full) {
			window_set_fullscreen(true)
		} else {
			window_set_fullscreen(false)
		}
	}
}

///@desc Habilita o V-Sync no jogo
function omnicam_vsync(_enable = -1) {
	if (_enable == -1) {
		// Auto mode
		OMNICAM.cam_vsync = !OMNICAM.cam_vsync
		display_reset(0, OMNICAM.cam_vsync)
	} else {
		// Manual mode
		display_reset(0, _enable)
	}
}

///desc Retorna o ID da câmera
function omnicam_get_id() {
	static cam_id = camera_create();
	return cam_id
}

///@desc Retorna a posição y da câmera
function omnicam_get_x() {
	return OMNICAM.cam_x
}

///@desc Retorna a posição x da câmera
function omnicam_get_y() {
	return OMNICAM.cam_y
}

///@desc Retorna a largura
function omnicam_get_width() {
	return OMNICAM.cam_width
}

///@desc Retorna a altura
function omnicam_get_height() {
	return OMNICAM.cam_height
}

///@desc Converte coordenadas da room para coordenadas da gui
function omnicam_room_to_gui(_x, _y) {
	var _w = omnicam_get_width()
	var _h = omnicam_get_height()
    var _gui_x = (_x - omnicam_get_x() + _w/2) * display_get_gui_width() / _w;
    var _gui_y = (_y - omnicam_get_y() + _h/2) * display_get_gui_height() / _h;
    return {x : _gui_x, y : _gui_y};
}

#endregion
//==============================================================

//==============================================================
#region Movement 

///@desc Adiciona um objeto ou instância para ser o alvo da câmera
function omnicam_follow(_instance, _teleport = false) {
	with (OMNICAM) {
		if (instance_exists(_instance)) {
			target = {
				x	: _instance.x,
				y	: _instance.y,
				id	: _instance,
			}
		}	
		
		if (_teleport) {
			cam_x = target.x
			cam_y = target.y
		}
	}
}

///@desc Adiciona uma posição para ser o alvo da câmera
function omnicam_focus(_x, _y, _teleport = false) {
	with (OMNICAM) {
		target = {
			x	: _x,
			y	: _y,
			id	: undefined,
		}
		
		if (_teleport) {
			cam_x = target.x
			cam_y = target.y
		}
	}
}

///@desc Adiciona uma posição em que a câmera vai espiar, junto com o valor de 0 a 1 em que a câmera irá se deslocar da posição alvo
function omnicam_peek(_x, _y, _amount) {
	with (OMNICAM) {
		peek = {
			x : _x,
			y : _y,
			a : _amount,
		}
	}
}

///@desc Altera diretamente o fator de movimento da câmera, sem alterar o modo
function omnicam_set_move_amount(_amount) {
	OMNICAM.cam_amount = _amount
}

///@desc Retorna o fator de movimento da câmera
function omnicam_get_move_amount(_amount) {
	return OMNICAM.cam_amount
}

///@desc Faz a câmera se mover com efeito de interpolação linear, junto com o valor de 0 a 1 dessa interpolação
function omnicam_move_lerp(_amount = 0.1) {
	with (OMNICAM) {
		cam_func	= __track_lerp
		cam_amount	= _amount
	}
}

///@desc Faz a câmera se mover em unidades fixas até o alvo
function omnicam_move_fixed(_amount = 2) {
	with (OMNICAM) {
		cam_func	= __track_fixed
		cam_amount	= _amount
	}
}

///@desc Faz a câmera se mover com efeito de dampening, indo até o alvo lentamente e acompanhando sua aceleração
function omnicam_move_damped(_amount = 30) {
	with (OMNICAM) {
		cam_func	= __track_damped
		cam_amount	= _amount
	}
}

///@desc Determina os limites em que a câmera pode se mover
function omnicam_limit(_left, _top, _right, _bottom) {
	with (OMNICAM) {
		limit = {
			left	: _left,
			top		: _top,
			right	: _right,
			bottom	: _bottom,
		}
	}
}

///@desc Trava o movimento da câmera no eixo x ou y
function omnicam_lock_axis(_x = -1, _y = -1) {
	with (OMNICAM) {
		cam_lock_x = (_x == -1 ? cam_lock_x : _x)
		cam_lock_y = (_y == -1 ? cam_lock_y : _y)
	}
}

#endregion
//==============================================================

//==============================================================
#region Effects 

///@desc Aplica um fator de zoom na câmera
function omnicam_zoom(_factor, _reset = true) {
	with (OMNICAM) {
		//cam_zoom_targ = _factor;
		if (_reset) {
			cam_zoom = _factor
		} else {
			cam_zoom_targ = _factor
		}
	}
}

///@desc Aplica um efeito de screenshake, com duração em frames
function omnicam_shake(_duration, _force_x, _force_y = _force_x, _force_r = 0, _spd = 30) {
	with (OMNICAM) {
		shake.spd	= _spd
		shake.time	= _duration
		shake.start	= _duration
		shake.xmag	= _force_x
		shake.ymag	= _force_y
		shake.rmag	= _force_r
	}
}

///@desc Aplica um efeito de flash, com cor, duração e curva exponencial (2 por padrão)
function omnicam_flash(_color, _duration, _expo = 2) {
	with (OMNICAM) {
		flash.color = _color;
		flash.time	= _duration;
		flash.total	= _duration
		flash.expo	= _expo
	}
}

#endregion
//==============================================================

//==============================================================
#region Helpers

///@ignore
function __perlin_get(_x, _y = 0) {
	
	static data = undefined
	if (data == undefined) {
		data = {}
		data.w = sprite_get_width(__omnicam_perlin);
		data.h = sprite_get_height(__omnicam_perlin);
		data.b = buffer_create(data.w * data.h, buffer_fast, 1)
		
		var _s = surface_create(data.w, data.h, surface_r8unorm);
		surface_set_target(_s)
		draw_sprite(__omnicam_perlin, 0, 0, 0)
		surface_reset_target()
		buffer_get_surface(data.b, _s, 0)
		surface_free(_s)
	}

    var _xx = floor(_x) mod data.w;
    var _yy = floor(_y) mod data.h;

    var _pos = _xx + (_yy * (data.w))
	var _val = 0.5 - buffer_peek(data.b, _pos, buffer_u8)/255;
    return _val
}
__perlin_get(0)

///@ignore
function __track_lerp(_value, _cx, _cy, _tx, _ty) {
	var _cam_x = lerp(_cx, _tx, _value)
	var _cam_y = lerp(_cy, _ty, _value)
	return [_cam_x, _cam_y]
}

///@ignore
function __track_fixed(_value, _cx, _cy, _tx, _ty) {
	var _cam_x = _cx
	var _cam_y = _cy
	if (point_distance(_cx, _cy, _tx, _ty) > _value) {
		var _dir = point_direction(_cx, _cy, _tx, _ty)
		_cam_x += lengthdir_x(_value, _dir)
		_cam_y += lengthdir_y(_value, _dir)
	} else {
		_cam_x = _tx
		_cam_y = _ty
	}		
	return [_cam_x, _cam_y]
}

///@ignore
function __track_damped(_value, _cx, _cy, _tx, _ty) {
	static out_x = 0
	static out_y = 0
	static omega = 2 / _value
	static fast_exp = 1 / (1 + omega + 0.48 * omega * omega + 0.235 * omega * omega * omega);
			
	var _delta_x = _cx - _tx
	var _delta_y = _cy - _ty
			
	var _out_x = out_x
	var _out_y = out_y
			
	var _temp_x = (_out_x + omega * fast_exp)
	var _temp_y = (_out_y + omega * fast_exp)
			
	out_x = (_out_x - omega * _temp_x) * fast_exp
	out_y = (_out_y - omega * _temp_y) * fast_exp
			
	var _cam_x = _tx + (_delta_x + _temp_x) * fast_exp
	var _cam_y = _ty + (_delta_y + _temp_y) * fast_exp			
	
	return [_cam_x, _cam_y]
}

#endregion
//==============================================================
























