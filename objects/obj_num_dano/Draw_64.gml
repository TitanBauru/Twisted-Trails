/// @description Insert description here
// You can write your code in this editor
var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

scribble(preset+string(round(numero))).transform(image_xscale,image_yscale).blend(cor,image_alpha).draw(x - cam_x,y - cam_y)



























