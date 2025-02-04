


// GUI
var _gui_w		= display_get_gui_width();
var _gui_h		= display_get_gui_height();


// Textbox
var _tbox_x		= _gui_w * textbox_x_fac;
var _tbox_y		= _gui_h * textbox_y_fac;
				
var _tbox_w		= _gui_w * textbox_wid_fac;
var _tbox_h		= _gui_h * textbox_hei_fac;
				
var _tbox_xs	= textbox_bg_scale * anim_factor;
var _tbox_ys	= textbox_bg_scale * anim_factor;


// Matriz de ancoragem
matrix_set(matrix_world, matrix_build(
	_tbox_x, _tbox_y, 0, 
	0, 0, 0, 
	_tbox_xs, _tbox_ys, 1));

	// Âncora pro ponto superior esquerdo
	var _tl_x = -(_tbox_w * 0.25);
	var _tl_y = -(_tbox_h * 0.25);


	/////////////////////////////////////////////////
	// Portrait
	if (!is_undefined(portrait_sprite)) {	
		var _port_x		= _tl_x + (portrait_wid * 0.5) + portrait_pad_x;
		var _port_y		= _tl_y - (portrait_hei * 0.5) + portrait_pad_y;
	
		var _port_sx	= (portrait_size / portrait_wid) - portrait_skew;
		var _port_sy	= (portrait_size / portrait_wid) + portrait_skew;
	
		draw_sprite_ext(portrait_sprite, portrait_frame, _port_x, _port_y, _port_sx, _port_sy, 0, portrait_color, portrait_alpha)
	}
	
	
	/////////////////////////////////////////////////
	// Nome
	var _name_x = _tl_x + portrait_name_pad_x + portrait_wid
	var _name_y = _tl_y + portrait_name_pad_y
	scribble(portrait_prefix + portrait_name)
		.align(0, 2)
		.scale(portrait_name_scale)
		.draw(_name_x, _name_y)
	
	
	/////////////////////////////////////////////////
	// Background
	if (is_undefined(textbox_sprite)) {
		draw_rectangle_color(
			-_tbox_w * 0.25,
			-_tbox_h * 0.25,
			 _tbox_w * 0.25,
			 _tbox_h * 0.25,
			textbox_color, textbox_color, textbox_color, textbox_color, false)
	} else {
		var _sx = 1 / sprite_get_width(textbox_sprite);
		var _sy = 1 / sprite_get_height(textbox_sprite);
		var _bg_xscl = (_sx * _tbox_w) * 0.5;
		var _bg_yscl = (_sy * _tbox_h) * 0.5;
		draw_sprite_ext(textbox_sprite, textbox_frame, 0, 0, _bg_xscl, _bg_yscl, 0, textbox_color, textbox_alpha);
	}
	

	
	/////////////////////////////////////////////////
	// Icone de skip
	if (skip_show_icon) {
		scribble(skip_text)
			.align(1, 2)
			.scale(textbox_text_scale)
			.draw(0, -_tl_y-1)
	}


	/////////////////////////////////////////////////
	// Texto
	var _hpad = textbox_hpad;
	var _vpad = textbox_vpad;
	var _text_x = _tbox_x + _hpad
	var _text_y = _tbox_y + _vpad
	var _text_wrap_w = (_tbox_w * 0.5) - (_hpad * 2)
	var _text_wrap_h = (_tbox_h * 0.5) - (_vpad * 2)
	
	if (dialog_start) {
		scribble(dialog_prefix + dialog_text)
			.scale(textbox_text_scale)
			.wrap(_text_wrap_w, _text_wrap_h) // TODO adicionar skip de pages
			.line_spacing(textbox_line_height)
			.draw(_tl_x + _hpad, _tl_y + _vpad, typist);
	}

matrix_set(matrix_world, __textbox_cache().matrix_identity)