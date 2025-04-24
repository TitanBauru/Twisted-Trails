
/*-------------------------------------------------------------------------------------------------
	These functions are independent, so if you delete them from the asset, nothing will happen.
-------------------------------------------------------------------------------------------------*/

/// Feather ignore all

// Shader uniforms
/// @desc This class is used to generate neutral LUTs, with linear curves.
function PPFX_PaletteGenerator() constructor {
	__textureFormat = surface_rgba8unorm;
	__rgbColors = [];
	__rgbColorsSize = 0;
	__output = -1;
	__colorsLimit = 1024; // max allowed: 4096 (not recommended...)
	
	#region Private Methods
	
	/// @ignore
	static __generate = function() {
		var _size = __rgbColorsSize;
		if (_size <= 0) exit;
		var _surf = surface_create(_size, 1, __textureFormat);
		
		// write to surface
		surface_set_target(_surf);
			gpu_push_state();
			gpu_set_blendenable(false);
			draw_clear(c_black);
				var i = 0, _rec = 0, _col = draw_get_color();
				repeat(_size) {
					_rec = i / _size;
					draw_point_color(_rec*_size, 0, __rgbColors[i]);
					++i;
				}
				draw_set_color(_col);
			gpu_pop_state();
		surface_reset_target();
		
		if (sprite_exists(__output)) sprite_delete(__output);
		__output = sprite_create_from_surface(_surf, 0, 0, _size, 1, false, false, 0, 0);
		surface_free(_surf);
		return __output;
	}
	
	#endregion
	
	#region Public Methods
	
	/// @desc Remove palette from memory.
	static Clean = function() {
		array_resize(__rgbColors, 0);
		if (sprite_exists(__output)) sprite_delete(__output);
		__output = -1;
		__rgbColorsSize = 0;
	}
	
	/// @desc Get palette's texture, ready for use.
	static GetTexture = function() {
		if (__output == -1) {
			__ppf_trace("No palette generated, cannot get texture", 1);
			return undefined;
		}
		return sprite_get_texture(__output, 0);
	}
	
	/// @desc Get palette's sprite, ready for use.
	static GetSprite = function() {
		return __output;
	}
	
	/// @desc Get the palette's color amount.
	static GetColorAmount = function() {
		return __rgbColorsSize = 0;
	}
	
	/// @desc Load a .pal pallete from a buffer file. You can use buffer_load(), or the buffer from buffer_load_async() function.
	/// @method LoadPalette(buffer)
	/// @param {Id.Buffer} buffer The buffer file to read.
	static LoadPalette = function(_buffer) {
		// read file buffer
		if (_buffer <= 0 || _buffer == undefined) {
			__ppf_trace($"Palette buffer loading error. {_buffer}", 1);
			return undefined;
		}
		// read file text
		try {
			var _text = buffer_read(_buffer, buffer_text);
			var _magic = string_count("JASC-PAL", _text);
			if (_magic > 0) {
				Clean();
				var _lines = string_split(_text, "\n");
				array_delete(_lines, 0, 2);
				var _size = real(_lines[0]);
				if (_size > __colorsLimit) {
					__ppf_trace($"Palette loading error. Color limit exceeded: {__colorsLimit}", 1);
					return undefined;
				}
				__rgbColorsSize = _size;
				array_delete(_lines, 0, 1);
				var _rgb = undefined;
				for (var i = 0; i < __rgbColorsSize; ++i) {
					_rgb = string_split(_lines[i], " ");
					__rgbColors[i] = make_color_rgb(_rgb[0], _rgb[1], _rgb[2]);
				}
				buffer_delete(_buffer);
				__generate();
				return true;
			} else {
				__ppf_trace("Palette format not supported. Must be JASC-PAL", 1);
				return undefined;
			}
		} catch(error) {
			__ppf_trace($"Palette loading error: {error.message}");
		}
		__ppf_trace("Palette failed to load. < Unknown Error >", 1);
		return undefined;
	}
	
	#endregion
}
