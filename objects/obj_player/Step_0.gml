
var axis_h = keyboard_check(ord("D")) - keyboard_check(ord("A"))
var axis_v = keyboard_check(ord("S")) - keyboard_check(ord("W"))
var move_h = axis_h ; // Movimento horizontal unificado
var move_v = axis_v ; // Movimento vertical unificado

var _velh = move_h ; // Velocidade proporcional ao input
var _velv = move_v ;
mover_player(_velh, _velv); // Aplica movimento com as novas velocidade

if (estou_movendo)
{
	sprite_index = spr_player_azul_walk;
	executar_dash();
	executar_dustwalk();
}
else
{
	velh = abs(velh) <= 0.2 ? 0 : lerp(velh, 0, desaceleracao);
    velv = abs(velv) <= 0.2 ? 0 : lerp(velv, 0, desaceleracao);
	sprite_index = spr_player_azul_idle	
}
ajustar_estado_visual()

if (on_dash)
{	
	velh = +dcos(dash_dir) * velocidade_dash * upgrade_velocidade_dash;
	velv = -dsin(dash_dir) * velocidade_dash * upgrade_velocidade_dash;
	
	if (point_distance(x, y, posicao_inicial_dash.x, posicao_inicial_dash.y) > distancia_dash * upgrade_distancia_dash)
	{
		on_dash = false;
		dash_cooldown = dash_timer;
	}
}
else
{
	dash_cooldown--;
}

if (on_knockback)
{
	on_dash = false; // caso eu tome dano eu saio do dash
	velh = +dcos(knockback_dir) * knockback_strenght;
	velv = -dsin(knockback_dir) * knockback_strenght;
	
	knockback_strenght = abs(knockback_strenght) <= 0.2 ? 0 : lerp(knockback_strenght, 0, desaceleracao);
	if (knoback_strenght <= 0)
	{
		on_knockback = false;
	}
}
depth = -bbox_bottom