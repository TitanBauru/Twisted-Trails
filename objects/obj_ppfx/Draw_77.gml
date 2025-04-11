
var _sourceSurface = application_surface;

// if there is a lighting system object in the room, use its final surface as input for post processing
if (instance_exists(obj_crystal)) {
	_sourceSurface = obj_crystal.renderer.GetRenderSurface();
}

ppfx_id.DrawInFullscreen(_sourceSurface);
//debug.Draw();
