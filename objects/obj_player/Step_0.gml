
var axis_h = keyboard_check(ord("D")) - keyboard_check(ord("A"))
var axis_v = keyboard_check(ord("S")) - keyboard_check(ord("W"))
var move_h = axis_h ; // Movimento horizontal unificado
var move_v = axis_v ; // Movimento vertical unificado



    var _velh = move_h ; // Velocidade proporcional ao input
    var _velv = move_v ;
    mover_player(_velh, _velv); // Aplica movimento com as novas velocidades
if (estou_movendo)
{
	sprite_index = spr_player_azul_walk	
}
else
{
	sprite_index = spr_player_azul_idle	
}