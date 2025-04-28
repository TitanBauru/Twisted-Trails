///@desc Renderer

if (instance_exists(obj_ppfx)) {
	exit;
}
show_message("e")
gpu_set_blendenable(false)
var _scl = window_get_width()/ (cam_pixel ? cam_width : window_width)
var _x = cam_smooth ? -(frac(cam_x) * _scl) : 0
var _y = cam_smooth ? -(frac(cam_y) * _scl) : 0
draw_surface_ext(application_surface, _x, _y, _scl, _scl, 0, c_white, 1)
gpu_set_blendenable(true)
