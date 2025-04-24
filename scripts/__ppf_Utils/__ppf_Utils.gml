
/// Feather ignore all

/// @desc Generates a color array to be usable in some places.
/// @param {Real} color The color. Example: c_white, make_color_rgb(), make_color_hsv(), #ffffff.
/// @returns {Array<Real>}
function make_color_ppfx(_color) {
	gml_pragma("forceinline");
	return [color_get_red(_color)/255, color_get_green(_color)/255, color_get_blue(_color)/255];
}

/// @desc Generate color array to be usable in Post-Processing FX. Only RGB colors supported.
/// @param {Real} red Red Color
/// @param {Real} green Green Color
/// @param {Real} blue Blur Color
/// @returns {Array<Real>}
function make_color_rgb_ppfx(_red, _green, _blue) {
	gml_pragma("forceinline");
	return [_red/255, _green/255, _blue/255];
}


// =============================================
#region INTERNAL
/// @ignore
/// @method __ppf_trace(text)
/// @param {String} text
function __ppf_trace(text, level=1) {
	gml_pragma("forceinline");
	if (level <= PPFX_CFG_TRACE_LEVEL) show_debug_message($"# PPFX >> {text}");
}

/// @ignore
function __ppf_exception(condition, text) {
	gml_pragma("forceinline");
	if (PPFX_CFG_ERROR_CHECKING_ENABLE && condition) {
		// the code below doesn't always run...
		var _stack = debug_get_callstack(4);
		var _context = _stack[array_length(_stack)-2];
		var _separator = string_repeat("-", 92);
		show_error($"{_separator}\nPost-Processing FX >> {instanceof(self)}  |  {_context}\n\n\n{text}\n\n\n{_separator}\n\n", true);
	}
}

/// @ignore
function __ppf_relerp(oldmin, oldmax, value, newmin, newmax) {
	return (value-oldmin) / (oldmax-oldmin) * (newmax-newmin) + newmin;
}

/// @ignore
function __ppf_linearstep(minv, maxv, value) {
	return (value - minv) / (maxv - minv);
}

/// @ignore
function __ppf_array_copy_all(from, to) {
	array_copy(to, 0, from, 0, array_length(from));
}

/// @ignore
function __ppf_surface_delete_array(_surfacesArray, _start=0) {
	gml_pragma("forceinline");
	var isize = array_length(_surfacesArray)-_start, i = isize-1+_start, _surf = -1;
	repeat(isize) {
		_surf = _surfacesArray[i];
		if (_surf != -1 && surface_exists(_surf)) surface_free(_surf);
		--i;
	}
}

/// @ignore
function __ppf_surface_delete(_surfaceIndex) {
	gml_pragma("forceinline");
	if (surface_exists(_surfaceIndex)) surface_free(_surfaceIndex);
}

/// @ignore
function __ppf_surface_create_secure(_targetSurface, _sourceSurface, _format, _disableDepthBuffer=false) {
	var _sourceWidth = surface_get_width(_sourceSurface),
		_sourceHeight = surface_get_height(_sourceSurface);
	if (surface_exists(_targetSurface) && _sourceWidth != surface_get_width(_targetSurface) || _sourceHeight != surface_get_height(_targetSurface)) {
		surface_free(_targetSurface);
	}
	if (!surface_exists(_targetSurface)) {
		var _disable = surface_get_depth_disable();
		surface_depth_disable(_disableDepthBuffer);
		_targetSurface = surface_create(_sourceWidth, _sourceHeight, _format);
		surface_depth_disable(_disable);
	}
	return _targetSurface;
}

/// @ignore
function __ppf_surface_create_secure_size(_targetSurface, _sourceWidth, _sourceHeight, _format, _disableDepthBuffer=false) {
	if (surface_exists(_targetSurface) && (_sourceWidth != surface_get_width(_targetSurface) || _sourceHeight != surface_get_height(_targetSurface))) {
		surface_free(_targetSurface);
	}
	if (!surface_exists(_targetSurface)) {
		var _disable = surface_get_depth_disable();
		surface_depth_disable(_disableDepthBuffer);
		_targetSurface = surface_create(_sourceWidth, _sourceHeight, _format);
		surface_depth_disable(_disable);
	}
	return _targetSurface;
}

/// @ignore
/// @desc Get camera view x position. Works the same way as camera_get_view_x(), but with matrix camera too.
function __ppf_camera_get_view_x(_camera) {
	return -camera_get_view_mat(_camera)[12] - round(abs(2/camera_get_proj_mat(_camera)[0]))/2;
}

/// @ignore
/// @desc Get camera view y position. Works the same way as camera_get_view_y(), but with matrix camera too.
function __ppf_camera_get_view_y(_camera) {
	return -camera_get_view_mat(_camera)[13] - round(abs(2/camera_get_proj_mat(_camera)[5]))/2;
}

/// @ignore
/// @desc Get camera view width. Works the same way as camera_get_view_width(), but with matrix camera too.
function __ppf_camera_get_view_width(_camera) {
	return round(abs(2/camera_get_proj_mat(_camera)[0]));
}

/// @ignore
/// @desc Get camera view height. Works the same way as camera_get_view_width(), but with matrix camera too.
function __ppf_camera_get_view_height(_camera) {
	return round(abs(2/camera_get_proj_mat(_camera)[5]));
}

/// @ignore
/// @desc Check if Post-processing renderer exists.
/// @param {Struct} _renderer The returned variable by ppfx_create().
/// @returns {Bool} description.
function __ppf_renderer_exists(_renderer) {
	return (is_struct(_renderer) && instanceof(_renderer) == "PPFX_Renderer" && !_renderer.__destroyed);
}

#endregion
