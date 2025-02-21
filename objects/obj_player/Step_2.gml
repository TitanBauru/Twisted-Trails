/// @description Insert description here
// You can write your code in this editor

var _velh = sign(velh);
var _velv = sign(velv);

//Colisão Horizontal
if(place_meeting(x + velh, y, obj_colisor))
{
	while(!place_meeting(x + _velh, y, obj_colisor))
	{
		x += _velh;	
	}
	velh = 0;
}

//Colisão Vertical
if(place_meeting(x, y + velv, obj_colisor))
{
	while(!place_meeting(x, y + _velv, obj_colisor))
	{
		y += _velv;	
	}
	velv = 0;
}

x+=velh;
y+=velv;

// Testando dano
if (keyboard_check_released(ord("L"))){
	deal_damage_to_player(5, 3, point_direction(mouse_x, mouse_y, x, y))
}