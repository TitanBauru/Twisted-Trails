
/*-------------------------------------------------------------------------------------------------
	These functions are independent, so if you delete them from the asset, nothing will happen.
-------------------------------------------------------------------------------------------------*/

/// Feather ignore all

// Shader uniforms
/// @desc This class is used to generate neutral LUTs, with linear curves.
function PPFX_LUTGenerator() constructor {
	__textureFormat = surface_rgba8unorm;
	__output = -1;
	__exportAsSprite = true;
	__lutType = "N/A";
	
	// shader uniforms
	__uniLUTGridSize = shader_get_uniform(__ppf_shLUTMaker, "u_size");
	__uniLUTGridSquares = shader_get_uniform(__ppf_shLUTMaker, "u_squares");
	
	#region Public Methods
	
	/// @desc This function returns the LUT texture, which can be used with the post-processing LUT effect.
	/// @method GetTexture()
	/// @returns {Pointer.Texture}
	static GetTexture = function() {
		if (__exportAsSprite) {
			return sprite_get_texture(__output, 0);
		} else {
			return surface_get_texture(__output);
		}
	}
	
	/// @desc This function deletes the previously created LUT sprite or surface, freeing up memory.
	/// @method Destroy()
	/// @returns {undefined}
	static Destroy = function() {
		__lutType = "N/A";
		if (__exportAsSprite) {
			if (sprite_exists(__output)) {
				sprite_delete(__output);
			}
		} else {
			if (surface_exists(__output)) {
				surface_free(__output);
			}
		}
	}
	
	/// @desc This function generates a linear RGBA channel 1D LUT sprite or surface.
	/// @method Generate1D(size, exportAsSprite)
	/// @param {Real} size The LUT size, for each channel.
	/// @param {Bool} exportAsSprite Defines whether to export as a sprite, which prevents the LUT from being destroyed if the surface is lost.
	/// @returns {Id.Surface,Asset.GMSprite}
	static Generate1D = function(_size=1024, _exportAsSprite=true) {
		if (_size <= 0) {
			__ppf_trace("LUTGenerator: Can't create LUT curve with 0 pixels.", 1);
			exit;
		}
		Destroy();
		__lutType = "Curve";
		var _surf = surface_create(_size, 1, __textureFormat);
		
		// write to surface
		surface_set_target(_surf);
		draw_clear(c_black);
			var i = 0, _rec = 0, _col = draw_get_color();
			repeat(_size) {
				_rec = i / _size;
				draw_point_color(_rec*_size, 0, make_color_hsv(0, 0, 255*_rec));
				++i;
			}
			draw_set_color(_col);
		surface_reset_target();
		
		__exportAsSprite = _exportAsSprite;
		if (!__exportAsSprite) {
			__output = _surf;
		} else {
			var _sprite = sprite_create_from_surface(_surf, 0, 0, _size, 1, false, false, 0, 0);
			surface_free(_surf);
			__output = _sprite;
		}
		return __output;
	}
	
	/// @desc This function generates a linear strip LUT sprite or surface.
	/// @method GenerateStrip(squares, exportAsSprite)
	/// @param {Real} squares The amount of squares in the lut.
	/// @param {Bool} exportAsSprite Defines whether to export as a sprite, which prevents the LUT from being destroyed if the surface is lost.
	/// @returns {Id.Surface,Asset.GMSprite}
	static GenerateStrip = function(_squares=16, _exportAsSprite=true) {
		if (_squares <= 0) {
			__ppf_trace("LUTGenerator: Can't create Strip LUT with 0 squares.", 1);
			exit;
		}
		Destroy();
		__lutType = "Strip";
		var _width = _squares * _squares;
		var _height = _squares;
		
		var _surf = surface_create(_width, _height, __textureFormat);
		surface_set_target(_surf);
			draw_clear(c_black);
			shader_set(__ppf_shLUTMaker);
			shader_set_uniform_f(__uniLUTGridSize, _width, _height); // 256 x 16
			shader_set_uniform_f(__uniLUTGridSquares, _squares, 1); // 16 x 1
			draw_sprite_stretched(__ppf_sprPixel, 0, 0, 0, _width, _height);
			shader_reset();
		surface_reset_target();
		
		__exportAsSprite = _exportAsSprite;
		if (!__exportAsSprite) {
			__output = _surf;
		} else {
			var _sprite = sprite_create_from_surface(_surf, 0, 0, _width, _height, false, false, 0, 0);
			surface_free(_surf);
			__output = _sprite;
		}
		return __output;
	}
	
	/// @desc This function generates a linear 3D grid LUT sprite or surface.
	/// @method GenerateGrid(squares, exportAsSprite)
	/// @param {Real} squares The amount of squares, which will form the complete LUT. 8 is the same as 8^3 = 512. 16^3 = 4096. Beware of high values.
	/// @param {Bool} exportAsSprite Defines whether to export as a sprite, which prevents the LUT from being destroyed if the surface is lost.
	/// @returns {Id.Surface,Asset.GMSprite}
	static GenerateGrid = function(_squares=8, _exportAsSprite=true) {
		if (_squares <= 0) {
			__ppf_trace("LUTGenerator: Can't create 3D LUT with 0 squares.", 1);
			exit;
		}
		Destroy();
		__lutType = "Grid";
		var _lut_size = power(_squares, 3); // cube
		
		var _surf = surface_create(_lut_size, _lut_size, __textureFormat);
		surface_set_target(_surf);
			draw_clear(c_black);
			shader_set(__ppf_shLUTMaker);
			shader_set_uniform_f(__uniLUTGridSize, _lut_size, _lut_size); // 512 x 512
			shader_set_uniform_f(__uniLUTGridSquares, _squares, _squares); // 8 x 8
			draw_sprite_stretched(__ppf_sprPixel, 0, 0, 0, _lut_size, _lut_size);
			shader_reset();
		surface_reset_target();
		
		__exportAsSprite = _exportAsSprite;
		if (!__exportAsSprite) {
			__output = _surf;
		} else {
			var _sprite = sprite_create_from_surface(_surf, 0, 0, _lut_size, _lut_size, false, false, 0, 0);
			surface_free(_surf);
			__output = _sprite;
		}
		return __output;
	}
	
	/// @desc This function generates a linear 3D Hald LUT sprite or surface.
	/// @method GenerateHaldGrid(squares, exportAsSprite)
	/// @param {Real} squares The amount of squares, which will form the complete LUT. 8 is the same as 8^3 = 512. 16^3 = 4096. Beware of high values.
	/// @param {Bool} exportAsSprite Defines whether to export as a sprite, which prevents the LUT from being destroyed if the surface is lost.
	/// @returns {Id.Surface,Asset.GMSprite}
	static GenerateHaldGrid = function(_squares=8, _exportAsSprite=true) {
		if (_squares <= 0) {
			__ppf_trace("LUTGenerator: Can't create Hald LUT with 0 squares.", 1);
			exit;
		}
		Destroy();
		__lutType = "Hald";
		var _lut_size = power(_squares, 3); // cube
		
		var _surf = surface_create(_lut_size, _lut_size, __textureFormat);
		surface_set_target(_surf);
			draw_clear(c_black);
			shader_set(__ppf_shLUTMaker);
			shader_set_uniform_f(__uniLUTGridSize, _lut_size, _lut_size); // 512 x 512
			shader_set_uniform_f(__uniLUTGridSquares, _squares, _squares*_squares); // 8 x 64
			draw_sprite_stretched(__ppf_sprPixel, 0, 0, 0, _lut_size, _lut_size);
			shader_reset();
		surface_reset_target();
		
		__exportAsSprite = _exportAsSprite;
		if (!__exportAsSprite) {
			__output = _surf;
		} else {
			var _sprite = sprite_create_from_surface(_surf, 0, 0, _lut_size, _lut_size, false, false, 0, 0);
			surface_free(_surf);
			__output = _sprite;
		}
		return __output;
	}
	
	/// @desc This function is used to load an external 3D .cube LUT file and returns a sprite or surface. [EXPERIMENTAL]
	/// @method LoadCube(file_path, exportAsSprite)
	/// @param {Real} file_path The .cube file path.
	/// @param {Bool} exportAsSprite Defines whether to export as a sprite, which prevents the LUT from being destroyed if the surface is lost.
	/// @returns {Id.Surface,Asset.GMSprite}
	static LoadCube = function(file_path, _exportAsSprite=true) {
		__ppf_trace("LUTGenerator: .cube Loading | Please Note: This feature is experimental.", 2);
		if (!surface_format_is_supported(surface_rgba32float)) {
			__ppf_trace(".cube loading is not supported on the current platform.", 2);
			return -1;
		}
		
		// Load and Parse file
		if (file_exists(file_path)) {
			Destroy();
			__lutType = "Cube";
			
			// load file
			var _file_buff = buffer_load(file_path);
			if (_file_buff < 0) {
				__ppf_trace("LUT cube load error.", 2);
				return -1;
			}
			
			try {
				// meta
				var _lutdata = {
					comments : -1,
					title : -1,
					size : 0,
					domain_min : 0,
					domain_max : 0,
					type : "N/A",
					data_buff : undefined,
				};
				
				// read all text
				var _file_text = buffer_read(_file_buff, buffer_text);
				buffer_delete(_file_buff);
				
				// header positions
				// all before TITLE are comments
				var _hp_title = string_pos("TITLE", _file_text);
				if (_hp_title > 0) {
					_lutdata.comments = string_split( string_copy(_file_text, 1, _hp_title-1) , "#", true);
				}
				var _content_array = string_split(_file_text, "\n", true);
				
				// create buffer for pixel data
				_lutdata.data_buff = buffer_create(0, buffer_grow, 4);
				
				// parse each line
				var h = 0, hsize = array_length(_content_array);
				repeat(hsize) {
					var _line = _content_array[h]; // string
					var _line_split = string_split(_line, " ", true);
					//var _end_line_pos = string_length(_line);
					
					if (string_starts_with(_line, "#")) {
						// commends [unused here]
					} else
					if (string_starts_with(_line, "TITLE")) {
						_lutdata.title = _line_split[1];
					} else
					if (string_starts_with(_line, "LUT_1D_SIZE")) {
						_lutdata.size = real(_line_split[1]);
						_lutdata.type = "1D";
					} else
					if (string_starts_with(_line, "LUT_3D_SIZE")) {
						_lutdata.size = real(_line_split[1]);
						_lutdata.type = "3D";
					} else
					if (string_starts_with(_line, "DOMAIN_MIN")) {
						_lutdata.domain_min = [real(_line_split[1]), real(_line_split[2]), real(_line_split[3])];
					} else
					if (string_starts_with(_line, "DOMAIN_MAX")) {
						_lutdata.domain_max = [real(_line_split[1]), real(_line_split[2]), real(_line_split[3])];
					} else {
						// LUT data points
						if (array_length(_line_split) == 3) {
							buffer_write(_lutdata.data_buff, buffer_f32, real(_line_split[0])); // B
							buffer_write(_lutdata.data_buff, buffer_f32, real(_line_split[1])); // G
							buffer_write(_lutdata.data_buff, buffer_f32, real(_line_split[2])); // R
							buffer_write(_lutdata.data_buff, buffer_f32, 1); // A
						}
					}
					
					++h;
				}
				// reset write position and delete unused buff
				buffer_seek(_lutdata.data_buff, buffer_seek_start, 0);
				array_delete(_content_array, 0, hsize);
				
				// check if lut is 3D
				if (_lutdata.type != "3D") {
					__ppf_trace("LUT cube is not in 3D format.");
					return -1;
				}
				
				// ---------------
			
				// Read LUT
				// read
				var _buff = _lutdata.data_buff;
				var _size = _lutdata.size;
				
				if (_size != 64 && _size != 16) {
					__ppf_trace($"LUT size is currently not well supported: {_size}");
				}
				
				var _cube_size = sqrt(_size * _size * _size);
				var _lut_surf = surface_create(_cube_size, _cube_size, surface_rgba32float);
				buffer_set_surface(_buff, _lut_surf, 0);
				
				
				// interpolate surface (TO-DO)
				var _width = _cube_size;
				var _height = _width;
				var _final_lut_surf = surface_create(_width, _height);
				
				surface_set_target(_final_lut_surf);
				draw_clear(c_black);
				var _using_linear_filter = gpu_get_tex_filter();
				gpu_set_tex_filter(true);
				
				//shader_set(__ppf_sh_ds_box13);
				//shader_set_uniform_f(shader_get_uniform(__ppf_sh_ds_box13, "u_texelSize"), 1/_cube_size, 1/_cube_size);
				draw_surface_stretched(_lut_surf, 0, 0, _width, _height);
				//shader_reset();
				
				gpu_set_tex_filter(_using_linear_filter);
				surface_reset_target();
				
				
				// export to sprite or surface
				__exportAsSprite = _exportAsSprite;
				if (__exportAsSprite) {
					var _sprite = sprite_create_from_surface(_final_lut_surf, 0, 0, _width, _height, false, false, 0, 0);
					__output = _sprite;
				} else {
					__output = _final_lut_surf;
				}
			
				// finish
				buffer_delete(_lutdata.data_buff);
				surface_free(_lut_surf);
				surface_free(_final_lut_surf);
				__ppf_trace("LUT cube loaded.", 3);
				
				var _data = {
					image : __output,
					horizontal_squares : _cube_size / _size,
					vertical_squares : _size,
					size : _cube_size,
					title : _lutdata.title,
					//comments : _lutdata.comments,
				};
				delete _lutdata;
				
				// return data
				return _data;
			} catch(ex) {
				__ppf_trace($"LUT cube parse error. {ex.message}", 2);
				return -1;
			}
		}
		
		__ppf_trace("LUT failed to load. < unknown error >", 1);
		return -1;
	}
	
	#endregion
}

