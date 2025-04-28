///@desc Process

window_update()
cam_move()
fx_shake()

var _cx = (cam_smooth ? floor(cam_x) : cam_x) + cam_xoff
var _cy = (cam_smooth ? floor(cam_y) : cam_y) + cam_yoff
var _cw = cam_width / cam_zoom
var _ch = cam_height / cam_zoom

_cx = round(_cx)
_cy = round(_cy)

var _view_mat = matrix_build_lookat(_cx, _cy, -16000, _cx, _cy, 16000, dsin(cam_angle), dcos(cam_angle), 0)
var _proj_mat = matrix_build_projection_ortho(_cw + cam_smooth, _ch + cam_smooth, 1, 32000)

camera_set_view_mat(cam_id, _view_mat)
camera_set_proj_mat(cam_id, _proj_mat)

camera_apply(cam_id)