/// @description Insert description here
// You can write your code in this editor
x += velh;
y += velv;

// Testando dano
if (keyboard_check_released(ord("L"))){
	deal_damage_to_player(5, 3, point_direction(mouse_x, mouse_y, x, y))
}