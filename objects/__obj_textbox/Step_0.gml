
	
// Controla a animacao da textbox
anim_progress = anim_timer / anim_delay;
var _channel = animcurve_get_channel(__ac_textbox_ease, textbox_ease_mode)
anim_factor = animcurve_channel_evaluate(_channel, anim_progress)
if (dialog_end) {
	anim_timer = max(--anim_timer, 0)
	
	typist.pause();
	
	if (auto_advance) {
		if (dialog_index >= dialog_size) {
			if (anim_progress == 0) {
				instance_destroy(id);
				exit;
			}
		}
	} else {
		if (anim_progress == 0) {
			instance_destroy(id);
			exit;
		}
	}
	
} else {
	anim_timer = min(++anim_timer, anim_delay)
	
	if (anim_progress == 1 - anim_overlap) {
		dialog_start = true
		typist.in(dialog_speed, dialog_smooth)
	}
}


