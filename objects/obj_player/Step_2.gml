/// @description Insert description here
// You can write your code in this editor

var _velh = sign(velh);
var _velv = sign(velv);

var _reset_dash = function(){
	if (on_dash){
		on_dash = false;
		dash_cooldown = dash_timer;
	}
	
	show_debug_message("Preso na parede " + string(current_time));
}

//Colisão Horizontal
repeat(abs(velh)){
	if (!place_meeting(x + _velh, y, obj_colisor)){
		x += _velh;
	}else{
		velh = 0;
		_reset_dash();
	}
}

//Colisão Vertical
repeat(abs(velv)){
	if (!place_meeting(x, y + _velv, obj_colisor)){
		y += _velv;
	}else{
		velv = 0;
		_reset_dash();
	}
}


// Testando dano
if (keyboard_check_released(ord("L"))){
	deal_damage_to_player(5, 3, point_direction(mouse_x, mouse_y, x, y));
}