
/// Feather ignore all

/// @desc This constructor aims to invert the normals of sprites in batch. Useful for converting from DirectX to OpenGL or vice versa.
/// This just converts and exports, the original sprites remain intact.
/// 
/// Sandbox must be disabled for this to work properly.
function Crystal_NormalsInverter() constructor {
	// base
	__inputPath = "";
	__outputPath = "";
	__filterNormalsOnly = false;
	
	/// @desc Define the folder to search for image files.
	/// @method SetInputFolder(folderPath)
	/// @param {String} folderPath The folder path to search for files.
	static SetInputFolder = function(_folderPath) {
		if (!directory_exists(_folderPath)) {
			__crystal_trace("NormalsInverter: input folder not found", 2);
			exit;
		}
		__inputPath = _folderPath;
	}
	
	/// @desc Define the folder to save all modified sprites.
	/// @method SetOutputFolder(folderPath)
	/// @param {String} folderPath The folder path to save generated image files.
	static SetOutputFolder = function(_folderPath) {
		if (!directory_exists(_folderPath)) {
			__crystal_trace("NormalsInverter: output folder not found", 2);
			exit;
		}
		__outputPath = _folderPath;
	}
	
	/// @desc Define exportation settings.
	/// @method SetExportSettings(filterNormals)
	/// @param {Bool} filterNormals If true, during the search, only files that contain "normal" (in any case) in the name will be processed.
	static SetExportSettings = function(_filterNormals) {
		__filterNormalsOnly = _filterNormals;
	}
	
	/// @desc Search for files (in the input folder), flip normals, and export them to the output folder.
	/// @method Convert()
	static Convert = function() {
		if (__inputPath == "") {
			__crystal_trace("NormalsInverter: no input folder defined, failed to convert", 2);
			exit;
		}
		if (__outputPath == "") {
			__crystal_trace("NormalsInverter: no output folder defined, failed to convert", 2);
			exit;
		}
		
		// Search for files or folders in the folder
		var _contents = []; // array with structs
		
		// Find files
		__crystal_directory_get_contents(__inputPath, _contents, "*.*", true, false, true);
		
		// Process contents found
		var _size = array_length(_contents), _processed = 0, _file = undefined, _fileExt = "", _fileName = "";
		__crystal_trace($"NormalsInverter: Files found (total): {_size}", 2);
		for (var i = 0; i < _size; ++i) {
			_file = _contents[i];
			
			if (!file_exists(_file)) continue;
			
			_fileExt = filename_ext(_file);
			_fileName = filename_name(_file);
			
			// filters
			if (_fileExt != ".png" && _fileExt != ".jpg" && _fileExt != ".jpeg") continue;
			if (__filterNormalsOnly) {
				if (string_pos("normal", string_lower(_fileName)) == 0) continue;
			}
			
			// add sprite
			var _sprite = sprite_add(_file, 0, false, false, 0, 0);
			
			// process it
			var _surface = surface_create(sprite_get_width(_sprite), sprite_get_height(_sprite));
			surface_set_target(_surface);
				draw_clear_alpha(c_black, 0);
				gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
				shader_set(__cle_shInvertNormal);
				draw_sprite(_sprite, 0, 0, 0);
				shader_reset();
			surface_reset_target();
			
			// export
			var _path = __outputPath + "/" + _fileName;
			surface_save(_surface, _path);
			__crystal_trace($"NormalsInverter: [{(i/_size)*100}%] {_path}", 2);
			
			// free memory
			sprite_delete(_sprite);
			surface_free(_surface);
			_processed += 1;
		}
		
		// finished
		__crystal_trace($"NormalsInverter: Files processed: {_processed} ", 2);
	}
}
