

/////////////////////////////////////////////////
#region Dialog

function textbox_set_dialog_speed(_dialog_speed) {
	textbox_config().dialog_speed = _dialog_speed;
}

function textbox_set_dialog_smooth(_dialog_smooth) {
	textbox_config().dialog_smooth = _dialog_smooth;
}

function textbox_set_dialog_pitchvar(_dialog_pitchvar) {
	textbox_config().dialog_pitchvar = _dialog_pitchvar;
}

function textbox_set_dialog_prefix(_string) {
	textbox_config().dialog_prefix = _string;
}

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Node

function textbox_set_node_value(_dialog_key, _event_index, _element_index, _value) {
	
	// Testa a key pra ser uma string válida
	if !(is_string(_dialog_key)) {
		__textbox_trace($"The key \"{_dialog_key}\" is not a valid string. Trying to convert")
		_dialog_key = string(_dialog_key)
	}
	
	// Procura o diálogo pela key
	var _dialog_data = textbox_dialogues()[$ _dialog_key];
	
	// Se a key de diálogo nao existir, retorna false
	if (is_undefined(_dialog_data)) {
		__textbox_trace($"Couldn't find dialog for key \"{_dialog_key}\"")
		return false;
	}
	
	_dialog_data.events[_event_index][_element_index] = _value
	
	textbox_dialogues()[$ _dialog_key] = _dialog_data
}

function textbox_set_node_argument(_dialog_key, _event_index, _element_index, _argument_index, _value) {
	
	// Testa a key pra ser uma string válida
	if !(is_string(_dialog_key)) {
		__textbox_trace($"The key \"{_dialog_key}\" is not a valid string. Trying to convert")
		_dialog_key = string(_dialog_key)
	}
	
	// Procura o diálogo pela key
	var _dialog_data = textbox_dialogues()[$ _dialog_key];
	
	// Se a key de diálogo nao existir, retorna false
	if (is_undefined(_dialog_data)) {
		__textbox_trace($"Couldn't find dialog for key \"{_dialog_key}\"")
		return false;
	}
	
	_dialog_data.events[_event_index][_element_index][_argument_index] = _value
	
	textbox_dialogues()[$ _dialog_key] = _dialog_data
}

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Textbox

function textbox_set_sprite(_sprite, _frame = 0) {
	textbox_config().textbox_sprite = _sprite;
	textbox_config().textbox_frame = _frame;
}

function textbox_set_position(_x, _y) {
	textbox_config().textbox_x_fac = _x;
	textbox_config().textbox_y_fac = _y;
}

function textbox_set_size(_wid, _hei) {
	textbox_config().textbox_wid_fac = _wid;
	textbox_config().textbox_hei_fac = _hei;
}

function textbox_set_color(_color) {
	textbox_config().textbox_color = _color;
}

function textbox_set_alpha(_alpha) {
	textbox_config().textbox_alpha = _alpha;
}

function textbox_set_background_scl(_scl) {
	textbox_config().textbox_bg_scale = _scl;
}

function textbox_set_text_scl(_scl) {
	textbox_config().textbox_text_scale = _scl;
}

function textbox_set_line_height(_height) {
	textbox_config().textbox_line_height = _height;
}

function textbox_set_ease_mode(_ease_mode) {
	textbox_config().textbox_ease_mode = _ease_mode;
}

function textbox_set_text_padding(_hor, _ver) {
	textbox_config().textbox_hpad = _hor;
	textbox_config().textbox_vpad = _ver;
}

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Portrait

function textbox_set_portrait_offset(_x, _y) {
	textbox_config().portrait_pad_x = _x
	textbox_config().portrait_pad_y = _y
}

function textbox_set_portrait_scl(_x, _y) {
	textbox_config().portrait_xscal = _x
	textbox_config().portrait_yscal = _y
}

function textbox_set_portrait_size(_size) {
	textbox_config().portrait_size = _size
}

function textbox_set_portrait_color(_color) {
	textbox_config().portrait_color = _color
}

function textbox_set_portrait_alpha(_alpha) {
	textbox_config().portrait_alpha = _alpha
}

function textbox_set_portrait_name_scl(_scl) {
	textbox_config().portrait_name_scale = _scl
}

function textbox_set_portrait_name_offset(_x, _y) {
	textbox_config().portrait_name_pad_x = _x
	textbox_config().portrait_name_pad_y = _y
}

function textbox_set_portrait_name_prefix(_string) {
	textbox_config().portrait_prefix = _string
}

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Skip

function textbox_set_skip_delay(_frames) {
	textbox_config().skip_delay = _frames;
}

function textbox_set_skip_text(_string) {
	textbox_config().skip_text = _string;
}

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Anim

function textbox_set_anim_delay(_frames) {
	textbox_config().anim_delay = _frames;
}

function textbox_set_anim_overlap(_factor) {
	textbox_config().anim_overlap = _factor;
}

#endregion
/////////////////////////////////////////////////

