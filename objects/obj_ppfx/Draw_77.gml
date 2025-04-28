
var _sourceSurface = application_surface;

// if there is a lighting system object in the room, use its final surface as input for post processing
if (instance_exists(obj_crystal)) {
	_sourceSurface = obj_crystal.renderer.GetRenderSurface();
}


var _x = OMNICAM.cam_smooth ? -frac(OMNICAM.cam_x) : 0
var _y = OMNICAM.cam_smooth ? -frac(OMNICAM.cam_y) : 0

renderer.Draw(_sourceSurface, _x, _y, OMNICAM.window_width, OMNICAM.window_height)
//debug.Draw();
