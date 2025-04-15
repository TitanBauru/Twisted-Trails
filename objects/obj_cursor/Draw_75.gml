/// @draw cursor

draw_sprite_ext(spr_crosshair,0,x + obj_weapon.precisao_inicial,y,1,1,0,-1,1)
draw_sprite_ext(spr_crosshair,0,x,y - obj_weapon.precisao_inicial,1,1,90,-1,1)
draw_sprite_ext(spr_crosshair,0,x - obj_weapon.precisao_inicial,y,1,1,180,-1,1)
draw_sprite_ext(spr_crosshair,0,x,y + obj_weapon.precisao_inicial,1,1,270,-1,1)

