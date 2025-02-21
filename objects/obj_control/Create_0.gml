// Scribble setup
var _font = font_get_name(fnt_test);
	
scribble_font_bake_shadow(_font, "fnt_temp1", 0, 1, c_black, 1, -1, false)
scribble_font_bake_outline_8dir("fnt_temp1", "fnt_main", c_black, false)
scribble_font_set_default("fnt_main")
scribble_font_delete("fnt_temp1")

scribble_anim_wave(.5,50,.2)
scribble_anim_shake(1,.1)

global.quantidade_de_inimigos = instance_number(obj_dummy);	