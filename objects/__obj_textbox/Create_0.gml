

/////////////////////////////////////////////////
#region Variables

	// Dialog data	
	dialog_size = array_length(dialog_data.events);
	var _st_data = textbox_config()


	// Dialog
	dialog_prefix		= _st_data.dialog_prefix;
	dialog_speed		= _st_data.dialog_speed;
	dialog_smooth		= _st_data.dialog_smooth;
	dialog_pitchvar		= _st_data.dialog_pitchvar;
	
	dialog_index		= 0;
	dialog_text			= "";
	dialog_start		= false
	dialog_end			= false;
	dialog_close		= false
	dialog_updated		= false
	dialog_voice		= undefined;
	dialog_pitch		= 1.0;
	dialog_gain			= 1.0;	


	// Skip
	skip_delay			= _st_data.skip_delay;
	skip_text			= _st_data.skip_text;
	
	skip_timer			= 0;
	skip_show_icon		= false;
	skip_input			= false;
	skip_auto			= false;
						
						
	// Portrait			
	portrait_pad_x		= _st_data.portrait_pad_x;
	portrait_pad_y		= _st_data.portrait_pad_y;
	portrait_xscal		= _st_data.portrait_xscal;
	portrait_yscal		= _st_data.portrait_yscal;
	portrait_name_pad_x	= _st_data.portrait_name_pad_x;
	portrait_name_pad_y	= _st_data.portrait_name_pad_y;
	portrait_name_scale	= _st_data.portrait_name_scale;
	portrait_size		= _st_data.portrait_size;
	portrait_color		= _st_data.portrait_color;
	portrait_alpha		= _st_data.portrait_alpha;
	portrait_prefix		= _st_data.portrait_prefix;
	portrait_skewer		= _st_data.portrait_skewer;
	
	portrait_anim		= false;
	portrait_name		= "";
	portrait_sprite		= undefined;
	portrait_frame		= 0;
	portrait_wid		= 0;
	portrait_hei		= 0;	
	portrait_skew		= portrait_skewer;
	portrait_wave		= 0;
	

	// Textbox
	textbox_color		= _st_data.textbox_color;
	textbox_alpha		= _st_data.textbox_alpha;
	textbox_x_fac		= _st_data.textbox_x_fac;
	textbox_y_fac		= _st_data.textbox_y_fac;
	textbox_wid_fac		= _st_data.textbox_wid_fac;
	textbox_hei_fac		= _st_data.textbox_hei_fac;
	textbox_bg_scale	= _st_data.textbox_bg_scale;
	textbox_text_scale	= _st_data.textbox_text_scale;
	textbox_line_height	= _st_data.textbox_line_height;
	textbox_hpad		= _st_data.textbox_hpad;
	textbox_vpad		= _st_data.textbox_vpad;
	textbox_ease_mode	= _st_data.textbox_ease_mode;
	textbox_sprite		= _st_data.textbox_sprite;
	textbox_frame		= _st_data.textbox_frame;
	
	
	// Animation
	anim_delay			= _st_data.anim_delay
	anim_overlap		= _st_data.anim_overlap
	
	anim_timer			= 0
	anim_progress		= 0
	anim_factor			= 0
	
	
	// Other
	auto_advance		= false

#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Typist setup
typist = scribble_typist()
typist
	.ease(SCRIBBLE_EASE.CIRC, 0, 8, 0, 0, 0, 1)
	.sound(dialog_voice, 0, dialog_pitch - dialog_pitchvar, dialog_pitch + dialog_pitchvar, dialog_gain)
	.character_delay_add(",", 150)
	.character_delay_add(".", 400)
	.character_delay_add("!", 400)
	.character_delay_add("?", 400)


#endregion
/////////////////////////////////////////////////



/////////////////////////////////////////////////
#region Methods 

///@desc Atualiza as propriedades do diálogo.
dialog_update = function(_init = false) {

	// Se chegou no ultimo index de diálogo, encerra o diálogo
	if (dialog_updated && dialog_index >= dialog_size-1) {
		dialog_end = true
		return;
	}

	// Itera pelos itens do diálogo, podendo comecar do 0 ou do ultimo index
	for (var i = (_init ? 0 : dialog_index+1); i < dialog_size; i++) {
		var _event_data = dialog_data.events[i]
		
		switch (_event_data[0]) {
			
			///////////////////////////////////////////////// ACTOR AND TEXT
			
			case Dialog.Text: {
				dialog_index	= i;
				dialog_text		= _event_data[1];
				if !(auto_advance) {
					i				= dialog_size;
				}
				
			} break;
			
			case Dialog.Actor: {
				var _actor_key = _event_data[1];
				var _actor = textbox_actors()[$ _actor_key];			
				
				// Atualiza o portrait
				portrait_name	= _actor.name;
				//portrait_wave	= _actor.wavy;
				portrait_sprite = _actor.portrait;
				
				if (!is_undefined(portrait_sprite)) {
					portrait_wid	= sprite_get_width(portrait_sprite);
					portrait_hei	= sprite_get_height(portrait_sprite);
				}
				
				// Atualiza a voz do typist
				dialog_voice	= _actor.voice;
				dialog_pitch	= _actor.voice_pitch;
				typist.sound(dialog_voice, 0, dialog_pitch - dialog_pitchvar, dialog_pitch + dialog_pitchvar, dialog_gain)
			} break;
			
			///////////////////////////////////////////////// PORTRAIT
			
			case Dialog.PortSprite: {
				portrait_sprite = _event_data[1];
				
				if (array_length(_event_data) > 2) {
					portrait_frame	= _event_data[2];
				} else {
					portrait_frame	= 0;
				}
				
				if (!is_undefined(portrait_sprite)) {
					portrait_wid	= sprite_get_width(portrait_sprite);
					portrait_hei	= sprite_get_height(portrait_sprite);
				}
			} break;
			
			case Dialog.PortName: {
				portrait_name	= _event_data[1];
			} break;
			
			case Dialog.PortFrame: {
				portrait_frame	= _event_data[1];
				portrait_anim	= false;
			} break;
				
			case Dialog.PortAnim: {
				portrait_frame	= 0
				if (array_length(_event_data) > 1) {
					portrait_sprite	= _event_data[1];
				}
				
				if (!is_undefined(portrait_sprite)) {
					portrait_wid	= sprite_get_width(portrait_sprite);
					portrait_hei	= sprite_get_height(portrait_sprite);
				}
				portrait_anim	= true;
			} break;
			
			case Dialog.PortClear: {
				portrait_sprite	= undefined;
				portrait_wid	= 0;
				portrait_hei	= 0;
				portrait_frame	= 0.0;
				portrait_anim	= false;
				portrait_name	= "";
			} break;
			
			///////////////////////////////////////////////// FUNCTIONS
			
			case Dialog.Callback: {
				dialog_index	= i;
				if (is_array(_event_data[2])) {
					script_execute_ext(_event_data[1], _event_data[2]);
				} else {
					script_execute_ext(_event_data[1], [_event_data[2]]);
				}
				
			} break;
			
			///////////////////////////////////////////////// VOICE
			
			case Dialog.Voice: {
				dialog_voice		= _event_data[1];
				typist.sound(dialog_voice, 0, dialog_pitch - dialog_pitchvar, dialog_pitch + dialog_pitchvar, dialog_gain)
			} break;
			
			case Dialog.VoicePitch: {
				dialog_pitch		= _event_data[1]
				typist.sound(dialog_voice, 0, dialog_pitch - dialog_pitchvar, dialog_pitch + dialog_pitchvar, dialog_gain)
			} break;
		}
	}
	
	
	if (auto_advance) {
		dialog_index = dialog_size;
	}
	
	// Se após executar as outras linhas, tiver chegado no ultimo index, encerra o diálogo
	if (dialog_index >= dialog_size) {
		dialog_end = true;
	}
	
	dialog_updated = true;
}

///@desc Avanca o diálogo.
dialog_advance = function() {
	
	// Timer pra mostrar o icone de skip
	skip_timer++;
	if (skip_timer > skip_delay) {
		skip_show_icon = true
	}
	
	// Controla o skip do diálogo
	if (skip_input) {
		skip_timer = 0
		skip_show_icon = false
		
		if !(skip_auto) {
			portrait_skew += portrait_skewer
		}
		
		dialog_update()		

		if (dialog_end) return;
		
		typist.reset()
	}
}

///@desc Anima a portrait do diálogo.
portrait_animate = function(_state) {
	
	// Controla animacoes do portrait do diálogo
	if (portrait_anim) {
		var _spd		= sprite_get_speed(portrait_sprite)
		var _frames		= sprite_get_number(portrait_sprite)
		var _spd_type	= sprite_get_speed_type(portrait_sprite)

		if (_spd_type) {
			portrait_frame += _spd
		} else {
			portrait_frame += _spd / game_get_speed(gamespeed_fps)
		}
	
		portrait_frame %= _frames
		//portrait_frame = (audio_is_playing(dialog_voice) ? portrait_frame : 0)
	}

	// Animacao do scale do portrait
	portrait_skew = lerp(portrait_skew, 0, 0.07)
}

#endregion 
/////////////////////////////////////////////////