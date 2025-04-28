///@desc Initiation

//=============================================================
#region Public Variables

game_width		= 480	// Reference Game Width
game_height		= 270	// Reference Game Height
game_scale		= 2		// Reference Windowed Scaling
gui_scale		= 1		// Reference GUI Scaling

#endregion
//=============================================================

//=============================================================
#region Private Variables

cam_id			= omnicam_get_id()
cam_width		= game_width
cam_height		= game_height
cam_scale		= game_scale
cam_x			= 0
cam_y			= 0
cam_xoff		= 0
cam_yoff		= 0
cam_spd			= 0.1
cam_func		= __track_lerp
cam_amount		= 0.1
cam_angle		= 0
cam_angle_targ	= 0

cam_zoom		= 1
cam_zoom_targ	= 1
cam_zoom_min	= -5.00
cam_zoom_max	= 50.00

cam_pixel		= false
cam_smooth		= false
cam_vsync		= true
cam_lock_x		= false
cam_lock_y		= false
								
view_width		= game_width * cam_scale
view_height		= game_height * cam_scale
							
window_width	= window_get_width()
window_height	= window_get_height()

game_ratio		= game_width / game_height
display_ratio	= display_get_width() / display_get_height();

aps_width		= game_width * cam_scale
aps_height		= game_height * cam_scale

limit = {
	left	: 0,
	top		: 0,
	right	: room_width,
	bottom	: room_height,
}

target = {
	x	: 0, 
	y	: 0, 
	id	: undefined
}

peek = {
	x	: 0, 
	y	: 0,
	a	: 0,
}

flash = {
	color	: c_white,
	time	: 0,
	total	: 0,
	expo	: 1,
}

shake = {
	time	: 0,
	start	: 0,
	spd		: 0,
	delta	: 0,
	xoff	: 0,
	yoff	: 0,
	roff	: 0,
	xmag	: 0,
	ymag	: 0,
	rmag	: 0,
	seedx	: irandom(512),
	seedy	: irandom(512),
	seedr	: irandom(512),
}

#endregion
//=============================================================

//=============================================================
#region Debug Window

dbg_view("Omnicam", false, 0, 20, 300, 600)

dbg_section("Variables")
dbg_watch(ref_create(self, "cam_x"), "Camera X")
dbg_watch(ref_create(self, "cam_y"), "Camera Y")
dbg_watch(ref_create(ref_create(self, "target"), "x"), "Target x")
dbg_watch(ref_create(ref_create(self, "target"), "y"), "Target y")
dbg_text_separator("")
dbg_watch(ref_create(self, "cam_width"), "Camera Width")
dbg_watch(ref_create(self, "cam_height"), "Camera Height")
dbg_text_separator("")
dbg_watch(ref_create(self, "view_width"), "View Width")
dbg_watch(ref_create(self, "view_height"), "View Height")
dbg_text_separator("")
dbg_watch(ref_create(self, "window_width"), "Window Width")
dbg_watch(ref_create(self, "window_height"), "Window Height")
dbg_text_separator("")
dbg_watch(ref_create(self, "aps_width"), "Surface Width")
dbg_watch(ref_create(self, "aps_height"), "Surface Height")
dbg_text_separator("")
dbg_text("")

dbg_section("Controlls")
dbg_slider(ref_create(self, "cam_zoom_targ"), cam_zoom_min, cam_zoom_max, "Zoom")
dbg_slider(ref_create(self, "cam_angle_targ"), 0, 360, "Angle")
dbg_slider(ref_create(self, "cam_xoff"), -64, 64, "Offset X")
dbg_slider(ref_create(self, "cam_yoff"), -64, 64, "Offset Y")
dbg_slider(ref_create(self, "cam_amount"), 0, 30, "Move Amount")
dbg_checkbox(ref_create(self, "cam_lock_x"), "Lock X")
dbg_checkbox(ref_create(self, "cam_lock_y"), "Lock Y")

dbgf_scale = function(){
	cam_scale++
	if (cam_scale > display_get_width() / game_width) {
		cam_scale = 1
	}
	omnicam_scale(cam_scale)
}
dbg_button("Game Scale", ref_create(self, "dbgf_scale"), 300)
dbg_text_separator("")
dbgf_lerp = function(){
	omnicam_move_lerp()
}
dbg_button("Move Lerp", ref_create(self, "dbgf_lerp"), 300)
dbgf_fixed = function(){
	omnicam_move_fixed()
}
dbg_button("Move Fixed", ref_create(self, "dbgf_fixed"), 300)
dbgf_damped = function(){
	omnicam_move_damped()
}
dbg_button("Move Damped", ref_create(self, "dbgf_damped"), 300)

dbgf_fullscreen = function(){
	omnicam_fullscreen()
}
dbg_button("Set Fullscreen", ref_create(self, "dbgf_fullscreen"), 300)
dbg_text_separator("")
dbg_text_separator("")
dbgf_pixel = function(){
	if (cam_pixel) {
		cam_pixel = false
	} else {
		cam_pixel = true
	}
	aps_width	= (cam_pixel ? cam_width : window_width) + cam_smooth
	aps_height	= (cam_pixel ? cam_height : window_height) + cam_smooth
	surface_resize(application_surface, aps_width, aps_height)
}
dbg_button("Pixel Perfect", ref_create(self, "dbgf_pixel"), 300)
dbg_watch(ref_create(self, "cam_pixel"), "Pixel Perfect")
dbg_text_separator("")
dbgf_smooth = function(){
	if (cam_smooth) {
		cam_smooth = false
	} else {
		cam_smooth = true
	}
	aps_width	= (cam_pixel ? cam_width : window_width) + cam_smooth
	aps_height	= (cam_pixel ? cam_height : window_height) + cam_smooth
	surface_resize(application_surface, aps_width, aps_height)
}
dbg_button("Pixel Smooth", ref_create(self, "dbgf_smooth"), 300)
dbg_watch(ref_create(self, "cam_smooth"), "Pixel Smooth")
dbg_text("")

dbg_section("Effects", false)
dbgf_shake = function(){omnicam_shake(30, 30, 30, 10)}
dbg_button("Shake", ref_create(self, "dbgf_shake"), 100)
dbg_same_line()
dbgf_flash = function(){omnicam_flash(c_white, 30)}
dbg_button("Flash", ref_create(self, "dbgf_flash"), 100)

#endregion
//=============================================================

//=============================================================
#region Methods

cam_move = function() {

	// Contantemente atualiza o X e Y do target se for uma instância existente
	if (instance_exists(target.id)) {
		target.x = target.id.x;
		target.y = target.id.y;
	}
	
	var _targ_x = (cam_lock_x ? cam_x : lerp(target.x, peek.x, peek.a))
	var _targ_y = (cam_lock_y ? cam_y : lerp(target.y, peek.y, peek.a))

	var _track = cam_func(cam_amount, cam_x, cam_y, _targ_x, _targ_y)
	cam_x = _track[0]
	cam_y = _track[1]
	
	// Atualiza as variáveis de animação
	cam_zoom	= lerp(cam_zoom, 1 - (1 - cam_zoom_targ) * 0.1, cam_spd);
	cam_angle	= lerp(cam_angle, cam_angle_targ, cam_spd)
	
	// Limita a câmera
	var _cam_wid	= cam_width / cam_zoom
	var _cam_hei	= cam_height / cam_zoom
	var _cx_min		= limit.left + _cam_wid/2
	var _cx_max		= limit.right  - _cam_wid/2
	var _cy_min		= limit.top  + _cam_hei/2
	var _cy_max		= limit.bottom - _cam_hei/2
	var _clamp_x	= clamp(cam_x, _cx_min, _cx_max) 
	var _clamp_y	= clamp(cam_y, _cy_min, _cy_max)
	
	cam_x = _clamp_x
	cam_y = _clamp_y
	
	// Se o limite for muito pequeno, a câmera fica no meio dele
	if (cam_x < _cx_min || cam_x > _cx_max) {
		cam_x = lerp(_cx_min, _cx_max, 0.5)
	}
	if (cam_y < _cy_min || cam_y > _cy_max) {
		cam_y = lerp(_cy_min, _cy_max, 0.5)
	}
}

view_update = function() {
	// GUI
	display_set_gui_size(cam_width * gui_scale, cam_height * gui_scale)
	// Application Surface
	aps_width	= (cam_pixel ? cam_width : window_width) + cam_smooth
	aps_height	= (cam_pixel ? cam_height : window_height) + cam_smooth
	surface_resize(application_surface, aps_width, aps_height)
	// Window
	window_set_size(view_width, view_height)
	window_center()
	// V-Sync
	omnicam_vsync(cam_vsync)

}

window_update = function(_force = false) {
	
	if !(window_has_focus()) return;
	var _resized = (window_width != window_get_width() || window_height != window_get_height())
	
	if (_resized || _force) {
		
		// Se a atualização for forçada pela scale
		if (_force) {
			view_width	= game_width * cam_scale
			view_height = game_height * cam_scale
			window_set_size(view_width, view_height)
			window_width	= view_width
			window_height	= view_height
			window_center()
		} else {
			// Atualiza a window interna pra garantir q a janela foi atualizada		
			window_width	= window_get_width()
			window_height	= window_get_height()
		}		
		
		// Get window aspect ratio
		var _ratio	= window_width / window_height		
		
		// Recalcula a view
		view_width = round(view_height * _ratio);
		if (view_width & 1) {
			view_width++;
		}		
		
		// Recalcula a câmera
		cam_width	= view_width div cam_scale
		cam_height	= view_height div cam_scale
		
		// Recalcula a GUI
		display_set_gui_size(cam_width * gui_scale, cam_height * gui_scale)
		
		// Recalcula a appsurf
		aps_width	= (cam_pixel ? cam_width : window_width) + cam_smooth
		aps_height	= (cam_pixel ? cam_height : window_height) + cam_smooth
		surface_resize(application_surface, aps_width, aps_height)		
	}
}

fx_flash = function() {	
	if (flash.time > 0) {
		flash.time--
		var _a = power(flash.time / flash.total, flash.expo)
		draw_sprite_stretched_ext(__omnicam_pixel, 0, 0, 0, display_get_gui_width(), display_get_gui_height(), flash.color, _a)
	}
}

fx_shake = function() {
	shake.time = max(shake.time - 1, 0);
	if (shake.time > 0) {
		shake.delta += shake.spd
		var _shk_fac = shake.time/shake.start;
		var _shk_pow = power(_shk_fac, 2);
		
		// Just random constants. It can be whatever you want
		var _x = __perlin_get(shake.seedx + shake.delta) * shake.xmag;
		var _y = __perlin_get(shake.seedy + shake.delta) * shake.ymag;
		var _r = __perlin_get(shake.seedr + shake.delta) * shake.rmag;

		shake.xoff	= _x * _shk_pow;
		shake.yoff	= _y * _shk_pow;
		shake.roff	= _r * _shk_pow;
	}
	
	cam_x		+= shake.xoff;
	cam_y		+= shake.yoff;
	cam_angle	+= shake.roff;
	
}

#endregion
//=============================================================

//=============================================================
#region Initialization

application_surface_draw_enable(false)
window_set_min_width(game_width)
window_set_min_height(game_height)
view_update()

#endregion
//=============================================================


















