draw_sprite_ext(sprite_index,image_index,x,y,xscale,yscale,image_angle,image_blend,image_alpha)
//scribble(estado).draw(x,y-16)
if(flash_white < 24) flash_white += .30;

gpu_set_fog(true, c_white, 1, 0);

var _alpha = 1 - (flash_white / 24);

draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, image_angle, c_white, _alpha);

gpu_set_fog(false, c_white, 0, 1);

scribble("[fa_center][scale,.5]DPS:[c_yellow]"+string(dummy_dps)).draw(x,y-44)
scribble("[fa_center][scale,.5]Total:[c_yellow]"+string(dummy_total_damage)).draw(x,y-32)