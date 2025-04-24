/*
// Feather ignore all

EXPERIMENTAL

/// @desc System responsible for managing the Post-Processing FX blend area system. This system sends profiles to the renderer when required (like when colliding with different areas).
function PPFX_BlendSystem(_mainRenderer, _secondaryRenderer) constructor {
	__mainRenderer = _mainRenderer;
	__secondaryRenderer = _secondaryRenderer;
	__secondaryRenderer.SetDrawEnable(false);
	__secondaryRenderer.SetRenderEnable(false);
	__areas = ds_list_create();
	vertex_format_begin();
	vertex_format_add_position();
	vertex_format_add_color();
	__areasVertexFormat = vertex_format_end();
	
	static __AddArea = function(_blendArea) {
		
	}
	
	
	static Update = function() {
		// a única vantagem de usar objetos é a checagem rápida de colisão...
		
		//var _col = instance_place(x, y, object);
		//if (_col != noone) {
			
		//}
	}
}

// =========================================================================


/// @desc 
function PPFX_BlendArea(_smoothness, _instance, _profile, _blendSystem) constructor {
	// Base
	// profile used to blend current image to
	//__name = object_get_name(_instance.object_index);
	__instance = _instance;
	__profile = _profile;
	__blendSystem = _blendSystem;
	__maskSpriteGenerated = -1;
	__maskVertexBuffer = undefined;
	__blendSmoothness = _smoothness; // internal blend area
	__swappedProfiles = false;
	
	// Misc
	_blendSystem.__AddArea(self);
	
	static Destroy = function() {
		// delete mask sprite if it was generated in runtime
		if (sprite_exists(__maskSpriteGenerated)) sprite_delete(__maskSpriteGenerated);
	}
	
	
	// Checks for meeting a collision point.
	static Meeting = function(_xx, _yy) {
		// assim que chamar, detectar imediatamente o ponto de colisão.. usar isso para medir a distância percorrida entre a posição atual e o ponto de colisão inicial
		var relX = _xx - (__instance.x - __instance.sprite_xoffset);
		var relY = _yy - (__instance.y - __instance.sprite_yoffset);
		var angle = degtorad(__instance.image_angle);
		var angleCos = cos(angle);
		var angleSin = sin(angle);
		var localX = (relX * angleCos) - (relY * angleSin);
		var localY = (relX * angleSin) + (relY * angleCos);
		
		// get distances from the shape
		var dx = max(-localX, 0, localX - __instance.sprite_width);
		var dy = max(-localY, 0, localY - __instance.sprite_height);
		
		var _distance = point_distance(0, 0, dx, dy);
		var _intensity = clamp(__ppf_linearstep(__blendSmoothness, 0, _distance), 0, 1);
		
		// carregar profile no sistema 2, para fazer o blend com o sistema 1
		
		
		if (_intensity > 0) {
			if (_intensity < 1) {
				// colliding only (between 0 and 1)
				show_debug_message($"colliding {random(99)}");
				if (!__swappedProfiles) {
					__blendSystem.__secondaryRenderer.ProfileLoad(__profile);
					__blendSystem.__secondaryRenderer.SetRenderEnable(true);
				}
				__blendSystem.__mainRenderer.__secondaryRenderer = __blendSystem.__secondaryRenderer;
				__blendSystem.__mainRenderer.__secondaryRendererIntensity = _intensity;
			} else {
				// fully merged (> 1)
				// [EXPERIMENTAL]
				// merge when full loaded
				__blendSystem.__secondaryRenderer.ProfileUnload(); // should not unload always?
				__blendSystem.__secondaryRenderer.SetRenderEnable(false);
				__blendSystem.__mainRenderer.__secondaryRenderer = undefined;
				__blendSystem.__mainRenderer.ProfileLoad(__profile);
				__swappedProfiles = true;
			}
		} else {
			__swappedProfiles = false;
		}
		
	}
	
	
	static SetMaskFromSprite = function(_sprite) {
		__instance.mask_index = _sprite;
	}
	
	
	static SetMaskFromPath = function(_path, _relative=false) {
		// create vertex buffer from path, and convert to a sprite. Delete vertex buffer after building, to prevent memory leaks
		// esse sprite será usado para checar colisões... ainda definir como funcionará essa questão da colisão...
		if (sprite_exists(__maskSpriteGenerated)) sprite_delete(__maskSpriteGenerated);
		
		// bounds
		var x1 = infinity;
	    var y1 = infinity;
	    var x2 = -infinity;
	    var y2 = -infinity;
		
		// create vertex buffer
		__maskVertexBuffer = vertex_create_buffer();
		vertex_begin(__maskVertexBuffer, __blendSystem.__areasVertexFormat);
		var _points = path_get_number(_path);
		var i = 0, _xx = 0, _yy = 0, px = 0, py = 0;
		if (_relative) {
			_xx = __instance.x - __instance.sprite_xoffset;
			_yy = __instance.y - __instance.sprite_yoffset;
		}
		repeat(_points) {
			px = _xx + path_get_point_x(_path, i);
			py = _yy + path_get_point_y(_path, i);
			vertex_position(__maskVertexBuffer, px, py); vertex_color(__maskVertexBuffer, c_black, 1);
			
			// get bounds
	        x1 = min(x1, px);
	        y1 = min(y1, py);
	        x2 = max(x2, px);
	        y2 = max(y2, py);
			++i;
		}
		vertex_end(__maskVertexBuffer);
		
		var _width = x2 - x1;
		var _height = y2 - y1;
		
		show_debug_message(_width);
		show_debug_message(_height);
		
		var _surf = surface_create(_width, _height, surface_rgba8unorm);
		surface_set_target(_surf);
			gpu_push_state();
			gpu_set_cullmode(cull_noculling);
			if (__maskVertexBuffer != undefined) vertex_submit(__maskVertexBuffer, pr_trianglefan, -1);
			gpu_pop_state();
		surface_reset_target();
		
		__maskSpriteGenerated = sprite_create_from_surface(_surf, 0, 0, surface_get_width(_surf), surface_get_height(_surf), false, false, 0, 0);
		sprite_collision_mask(__maskSpriteGenerated, false, 0, 0, 0, 0, 0, bboxkind_precise, 0);
		__instance.mask_index = __maskSpriteGenerated;
		surface_free(_surf);
		
		return self;
	}
	
	
	/// @desc Draw area collision shape
	static DebugDraw = function() {
		if (sprite_exists(__instance.mask_index)) {
			draw_sprite(__instance.mask_index, 0, __instance.x, __instance.y);
		}
		draw_rectangle(__instance.bbox_left-__blendSmoothness, __instance.bbox_top-__blendSmoothness, __instance.bbox_right+__blendSmoothness, __instance.bbox_bottom+__blendSmoothness, true);
	}
}


