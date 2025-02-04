

///@desc Instancia uma nova textbox usando uma dialog key.
function textbox_create(_dialog_key) {
	
	// Se já existir uma textbox, retorna false
	if (textbox_exists()) {
		__textbox_trace($"An instance of textbox already is active")
		return false;
	}
	
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
	
	// Cria o textbox
	var _textbox = instance_create_depth(0, 0, 0, __obj_textbox, {
		dialog_data : _dialog_data,
	})
	
	// Atualiza a primeira linha do diálogo
	_textbox.dialog_update(true);
	
	// Salva a referencia da textbox em cache
	__textbox_cache().textbox_id = _textbox;
	return _textbox;
}


///@desc Checa se uma textbox já existe.
function textbox_exists() {
	return instance_exists(__obj_textbox);
}


///@desc Avanca o diálogo da textbox existente.
function textbox_skip() {
	if (textbox_exists()) {
		__textbox_cache().textbox_id.skip_input = true
	}
}


///@desc Destroi a textbox atual.
function textbox_destroy(_animate = true, _perform_callbacks = false) {
	if (textbox_exists()) {
		var _textbox_id = textbox_get_id()
		
		if (_perform_callbacks) {
			_textbox_id.auto_advance	= true;
			_textbox_id.skip_auto		= true;
		} 
		
		if (!_animate) {
			_textbox_id.anim_timer		= 0;
		}	
		
		_textbox_id.dialog_end			= true;
	}
}
	
	
///@ignore
function __textbox_trace(_message = "") {
	if (__textbox_cache().trace) {
		show_debug_message($"TextBox error: {_message}.");
	}
}