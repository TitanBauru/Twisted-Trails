
var axis_h = keyboard_check(ord("D")) - keyboard_check(ord("A"))
var axis_v = keyboard_check(ord("S")) - keyboard_check(ord("W"))
var move_h = axis_h ; // Movimento horizontal unificado
var move_v = axis_v ; // Movimento vertical unificado

var _velh = move_h ; // Velocidade proporcional ao input
var _velv = move_v ;
mover_player(_velh, _velv); // Aplica movimento com as novas velocidade

if (estou_movendo)
{
	sprite_index = spr_player_azul_walk	
	executar_dustwalk()
}
else
{
	velh = abs(velh) <= 0.2 ? 0 : lerp(velh, 0, desaceleracao);
    velv = abs(velv) <= 0.2 ? 0 : lerp(velv, 0, desaceleracao);
	sprite_index = spr_player_azul_idle	
}
ajustar_estado_visual()