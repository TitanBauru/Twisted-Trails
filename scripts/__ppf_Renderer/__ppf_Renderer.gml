
// Feather ignore all
/// @desc The renderer is essentially responsible for drawing the visual effects. It works both for full screen and for layers. You can create as many renderers as you need, depending on what you're going to do.
/// @returns {struct} Post-processing renderer id.
function PPFX_Renderer() constructor {
	__ppf_trace($"Renderer created", 3);
	// Base
	__allowRendering = true;
	__renderSurfaceOutput = -1; // reference only
	__renderSurfaceWidth = 0;
	__renderSurfaceHeight = 0;
	__renderResolution = 1;
	__oldRenderResolution = __renderResolution;
	__oldInputSurfaceWidth = 0;
	__oldInputSurfaceHeight = 0;
	__currentProfile = noone;
	__destroyed = false;
	__enableBlending = false;
	__cpuFrameTime = 0;
	__miscLinearLUTSprite = -1;
	__miscBakedLUTSurf = -1;
	__timer = PPFX_CFG_TIMER;
	__time = 0;
	__timeSpeed = 1 / game_get_speed(gamespeed_fps);
	__deltaTime = 1;
	
	// Configs (do not edit it here)
	__isHDREnabled = false;
	__isDrawEnabled = true;
	__isRenderEnabled = true;
	__surfaceFormatBase = surface_rgba8unorm;
	__surfaceFormat = __surfaceFormatBase;
	
	// Rendering
	__stackSurfaces = []; // for each individual effect and shared effect
	__stackNames = []; // used in __stackSetSurface > Bloom, VHS, Color Grading, etc.
	__stackIndex = 0; // the stack array position
	
	// Effects
	__sharedEffectsArray = [new __ST_Base(), new __ST_ColorGrading(), new __ST_Final()]; // array with shared stacks structs (base, grading, final)
	__sharedEffectsArrayLength = array_length(__sharedEffectsArray);
	//__sharedEffects = {};
	__effects = {}; // struct with unordered effects references
	__effectsOrdered = []; // array with ordered effects references
	__effectsOrderedAmount = 0;
	
	// Layer-related
	__isLayerRendering = false;
	__layerSurface = -1;
	__layerCamera = -1;
	__layerWorldCamera = -1;
	__layerOldInputWidth = 0;
	__layerOldInputHeight = 0;
	__layerBeginFunc = undefined;
	__layerEndFunc = undefined;
	__layerTopLayer = undefined;
	__layerBottomLayer = undefined;
	
	#region Private Methods
	
	/// @desc Check if some effect exists in this renderer.
	/// @ignore
	static __effectExists = function(_effect) {
		return (__effects[$ _effect] != undefined);
	}
	
	/// @desc Get specific effect struct.
	/// @ignore
	static __getEffectStruct = function(_effect) {
		if (__effectExists(_effect)) return __effects[$ _effect];
		return undefined;
	}
	
	/// @desc Get and execute shared stack.
	/// @ignore
	static __runSharedEffect = function(_order, _isStart, _surfaceWidth, _surfaceHeight, _time) {
		var j = 0, _stack = undefined;
		repeat(__sharedEffectsArrayLength) {
			// run method if order matches
			_stack = __sharedEffectsArray[j];
			if (_order == _stack.stackOrder) {
				if (_isStart) {
					_stack.Start(self, _surfaceWidth, _surfaceHeight, _time);
				} else {
					_stack.End(self, _surfaceWidth, _surfaceHeight, _time);
				}
			}
			++j;
		}
	}
	
	/// @desc Stack sort function.
	/// @ignore
	static __effectsSortFunction = function(a, b) {
		return a.stackOrder - b.stackOrder;
	}
	
	/// @desc Used for reordering effects.
	/// @ignore
	static __effectsReorder = function() {
		// redefined ordered array
		array_resize(__effectsOrdered, 0);
		// copy from effects references to the ordered array
		var _effectsNames = struct_get_names(__effects);
		var _effectsAmount = array_length(_effectsNames);
		for (var i = 0; i < _effectsAmount; ++i) {
			__effectsOrdered[i] = __effects[$ _effectsNames[i]];
		}
		// do a bubble sort for the ordered array (based on stack/rendering order)
		array_sort(__effectsOrdered, __effectsSortFunction);
		__effectsOrderedAmount = _effectsAmount;
	}
	
	/// @ignore
	static __stacksInit = function() {
		__stackSurfaces = array_create(array_length(__sharedEffectsArray) + array_length(__effectsOrdered), -1);
		__stackNames = array_create(array_length(__stackSurfaces), "");
	}
	
	/// @desc Each effect has a surface (except shared stacks, which shares the same surface).
	/// @ignore
	static __stackSetSurface = function(_width, _height, _name) {
		__stackIndex++;
		if (!surface_exists(__stackSurfaces[__stackIndex])) {
			__stackNames[__stackIndex] = _name;
			__stackSurfaces[__stackIndex] = surface_create(_width, _height, __surfaceFormat);
		}
		surface_set_target(__stackSurfaces[__stackIndex]);
	}
	
	/// @ignore
	static __stackResetSurface = function() {
		surface_reset_target();
	}
	
	/// @ignore
	static __stacksClean = function() {
		// execute effects clean method
		var k = __effectsOrderedAmount-1, _effectStruct = undefined;
		repeat(__effectsOrderedAmount) {
			_effectStruct = __effectsOrdered[k];
			if (_effectStruct.Clean != undefined) _effectStruct.Clean();
			--k;
		}
		// clean stack surfaces, except the first one (which is the input surface)
		__ppf_surface_delete_array(__stackSurfaces, 1);
		__ppf_surface_delete(__miscBakedLUTSurf);
		__ppf_trace("Renderer cleaned, including effects", 3);
	}
	
	/// @ignore
	static __stackGetSurfaceCurrent = function() {
		return __stackSurfaces[__stackIndex];
	}
	
	/// @ignore
	static __stackGetSurfacePrevious = function() {
		return __stackSurfaces[__stackIndex-1];
	}
	
	// should only be called within effects
	/// @ignore
	static __stackGetSurfaceFromOffset = function(_offset=0) {
		return __stackSurfaces[clamp(__stackIndex-abs(_offset), 0, __stackIndex)];
	}
	
	#endregion
	
	#region Public Methods
	
	/// @desc This function applies post-processing to one or more layers. You only need to call this ONCE in an object's "Create" or "Room Start" Event. Do NOT draw the Post-processing renderer manually, if you use this. This function already draws the Post-Processing on the layer, using layer scripts.
	///
	/// Make sure the Top Layer is above the Bottom Layer in order. If not, it may not render correctly!
	///
	/// Please note: You CANNOT select a range to which the layer has already been in range by another renderer. This will give an unbalanced surface stack error. If you want to use more effects, just add more effects to the profile.
	/// When applying PPFX_Renderer to layers, the layers defined in range are drawn within the same surface, which means that if you have another layer between them, the depth in consideration will be the depth of the first layer.
	///
	/// Let's say you have these layers:
	/// - Grass1;
	/// - Grass2;
	/// - Brick;
	/// - Grass4;
	/// - Grass5;
	/// This will work well:
	/// - Apply the renderer from "Grass1" to "Grass2".
	/// This will cause depth issues:
	/// - Apply the renderer from "Grass1" to "Grass5", causing the Brick layer to be above the others.
	/// The solution is to create a new PPFX_Renderer() for each range of layers.
	/// @method LayerApply(topLayer, bottomLayer)
	/// @param {Id.Layer} topLayer The top layer, in the room editor.
	/// @param {Id.Layer} bottomLayer The bottom layer, in the room editor. By default, this is equal to topLayer, useful if you want to render everything in just one layer.
	static LayerApply = function(_topLayer, _bottomLayer=_topLayer) {
		if (__isLayerRendering) exit;
		__ppf_trace($"Layer rendering from: {layer_get_name(_topLayer)} to: {layer_get_name(_bottomLayer)}", 3);
		__ppf_exception(!layer_exists(_topLayer) || !layer_exists(_bottomLayer), $"One of the layers does not exist in the current room: {layer_get_name(_topLayer)}, {layer_get_name(_bottomLayer)}");
		__ppf_exception(layer_get_depth(_topLayer) > layer_get_depth(_bottomLayer), $"Inverted layer range order: {layer_get_name(_topLayer)}, {layer_get_name(_bottomLayer)}");
		if (event_type != ev_create && event_type != ev_other && event_type >= 0) __ppf_trace("WARNING: .LayerApply() should be called in the 'Create or Room Start events", 2);
		
		// enable blending, to support alpha
		__enableBlending = true;
		__layerTopLayer = _topLayer;
		__layerBottomLayer = _bottomLayer;
		
		/// @ignore
		__layerBeginFunc = function() {
			if (event_type == ev_draw && event_number == 0) {
				__layerWorldCamera = view_get_camera(view_current);
				// create surface once or when resized. this surface is used by all ranges for this renderer
				var _sourceSurf = surface_get_target(),
					_sourceWidth = surface_get_width(_sourceSurf),
					_sourceHeight = surface_get_height(_sourceSurf);
				if (_sourceWidth != __layerOldInputWidth || _sourceHeight != __layerOldInputHeight) {
					__layerOldInputWidth = _sourceWidth;
					__layerOldInputHeight = _sourceHeight;
					surface_free(__layerSurface);
				}
				if (!surface_exists(__layerSurface)) {
					__layerSurface = surface_create(surface_get_width(_sourceSurf), surface_get_height(_sourceSurf), __surfaceFormat);
				}
				// renderize layer contents inside the surface
					__isLayerRendering = true;
					surface_set_target(__layerSurface, _sourceSurf);
					draw_clear_ext(c_black, 0);
					camera_apply(__layerWorldCamera);
					gpu_push_state();
					gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
					gpu_set_zwriteenable(false);
			}
		}
		/// @ignore
		__layerEndFunc = function() {
			if (event_type == ev_draw && event_number == 0 && surface_exists(__layerSurface)) {
					gpu_pop_state();
					surface_reset_target();
				// draw it
				var _oldDepth = gpu_get_depth();
				gpu_set_depth(layer_get_depth(__layerTopLayer));
				var _cam = view_get_camera(view_current);
				Draw(__layerSurface, __ppf_camera_get_view_x(_cam), __ppf_camera_get_view_y(_cam), __ppf_camera_get_view_width(_cam), __ppf_camera_get_view_height(_cam));
				gpu_set_depth(_oldDepth);
			}
		}
		
		layer_script_begin(__layerBottomLayer, __layerBeginFunc);
		layer_script_end(__layerTopLayer, __layerEndFunc);
		return self;
	}
	
	/// @desc This function defines a new range of layers, if you are applying post-processing to a layer (using .LayerApply()).
	/// 
	/// Make sure the top layer is above the bottom layer in order. If not, it may not render correctly!
	/// 
	/// Please note: You CANNOT select a range to which the layer has already been in range by another renderer. This will give an unbalanced surface stack error. If you want to use more effects, just add more effects to the profile.
	/// @method LayerSetRange(topLayer, bottomLayer)
	/// @param {Id.Layer} topLayer The top layer, in the room editor.
	/// @param {Id.Layer} bottomLayer The bottom layer, in the room editor. By default, this is equal to topLayer, useful if you want to render everything in just one layer.
	static LayerSetRange = function(_topLayer, _bottomLayer=_topLayer) {
		if (__layerBottomLayer != undefined) layer_script_begin(__layerBottomLayer, -1);
		if (__layerTopLayer != undefined) layer_script_end(__layerTopLayer, -1);
		__layerTopLayer = _topLayer;
		__layerBottomLayer = _bottomLayer;
		layer_script_begin(__layerBottomLayer, __layerBeginFunc);
		layer_script_end(__layerTopLayer, __layerEndFunc);
		return self;
	}
	
	/// @desc This function loads a previously created profile. Effects REFERENCE is copied, which means that if you modify the effect struct, this will be reflected in the renderer as well.
	/// After loading the profile, the renderer will reorder the effects based on their stackOrder and draw them as defined.
	/// Your Profile must NOT have repeated effects, otherwise they will be replaced. If you want to repeat effects, use another PPFX_Renderer where it receives input from another.
	/// @method ProfileLoad(profile)
	/// @param {Struct} profile Profile struct created with new PPFX_Profile().
	/// @param {Bool} merge If you want to merge the profile with existing effects in the renderer (without replacing everything).
	/// @param {String,Array<String>} filter If defined, will add only the selected effect. Use the "FF_" effect macro directly, or an array of macros. Example: [FF_BLOOM, FF_DOF] will only add those two effects among several in the profile. The effect should exist in the profile to be filtered (otherwise nothing happens).
	/// @returns {undefined}
	static ProfileLoad = function(_profile, _merge=false, _filter=undefined) {
		__ppf_exception(!is_struct(_profile), "Profile Index is not a struct.");
		if (__currentProfile != _profile) {
			var _profileEffectsArray = _profile.__effectsArray,
				_profileEffectsAmount = array_length(_profileEffectsArray);
			if (_profileEffectsAmount == 0) {
				__ppf_trace($"Profile '{_profile.__profileName}' is empty. Can't load", 1);
				exit;
			}
			
			// clean current effects from memory, before loading, to prevent memory leaks
			__stacksClean();
			
			// copy + replace effects to this renderer (THEIR REFERENCE ONLY)
			if (!_merge) {
				__effects = {};
			}
			var _loadedCount = 0, _effect = undefined, _effectName = undefined;
			for (var i = 0; i < _profileEffectsAmount; ++i) {
				_effect = _profileEffectsArray[i];
				
				// if effect is valid, proceed
				if (is_struct(_effect)) {
					_effectName = _effect.effectName;
					var _canAdd = true;
					
					// if merge enabled, only add if the effect doesn't exist in the renderer
					if (_merge) {
						var _names = variable_struct_get_names(__effects);
						_canAdd = !array_contains(_names, _effectName);
					}
					
					// only add effect is allowed
					if (_canAdd) {
						if (_filter == undefined) {
							// add normally
							__effects[$ _effectName] = _effect;
							_loadedCount++;
						} else {
							// filter effects
							if (!is_array(_filter)) {
								// single
								if (_effectName == _filter) {
									__effects[$ _effectName] = _effect;
									_loadedCount++;
									break;
								}
							} else {
								// multiple
								var f = 0, fsize = array_length(_filter);
								repeat(fsize) {
									if (_effectName == _filter[f]) {
										__effects[$ _effectName] = _effect;
										_loadedCount++;
									}
									++f;
								}
							}
						}
					}
				} else {
					__ppf_trace($"Profile effect import error: '{_effect}' is invalid", 1);
				}
			}
			
			// reorder effects based on order
			__effectsReorder();
			
			// init stacks indexes (-1 for each)
			__stacksInit();
			
			// loaded successful
			__ppf_trace($"Profile loaded: '{_profile.__profileName}' ({_loadedCount} effects loaded{_merge ? " | merge" : ""})", 3);
			__currentProfile = _profile;
		}
		return self;
	}
	
	/// @desc This function removes any profile associated with this Post-processing renderer.
	/// @method ProfileUnload()
	static ProfileUnload = function() {
		if (__currentProfile != noone) {
			__stacksClean();
			__effects = {};
			array_resize(__effectsOrdered, 0);
			__effectsOrderedAmount = 0;
			__ppf_trace($"Profile unloaded: '{__currentProfile.__profileName}'", 3);
			__currentProfile = noone;
		}
		return self;
	}
	
	/// @desc Destroy Post-processing renderer.
	/// @method Destroy()
	/// @returns {undefined}
	static Destroy = function() {
		if (__destroyed) exit;
		// remove profile
		ProfileUnload();
		// remove color grading bake lut sprite (do not destroy it here, because the LUT is not created in this class...)
		__miscLinearLUTSprite = -1;
		if (surface_exists(__miscBakedLUTSurf)) {
			surface_free(__miscBakedLUTSurf);
			__miscBakedLUTSurf = -1;
		}
		__ppf_surface_delete(__layerSurface);
		if (__layerCamera != -1) camera_destroy(__layerCamera);
		__destroyed = true;
		__isLayerRendering = false;
		__ppf_trace("Renderer destroyed from memory", 3);
	}
	
	/// @desc Enable or disable HDR from this renderer. Default is false. Generally recommended to have (if needed), for best visuals.
	/// This allows for better color depth, contrast and brightness (especially useful for the Bloom and Sunshafts/Godrays/LongExposure effect).
	/// 
	/// This can affect VRAM usage and not every hardware supports this (although, most of the 2015 GPUs above should work).
	/// @method SetHDREnable(enabled)
	/// @param {Bool,Real} enabled Defines if HDR is enabled. Use -1 to toggle.
	static SetHDREnable = function(_enabled=-1) {
		if (_enabled == -1) {
			__isHDREnabled = !__isHDREnabled;
		} else {
			__isHDREnabled = _enabled;
		}
		// Check
		if (__isHDREnabled) {
			if (surface_format_is_supported(PPFX_CFG_HDR_TEX_FORMAT)) {
				__surfaceFormat = PPFX_CFG_HDR_TEX_FORMAT;
			} else {
				__ppf_trace($"WARNING: Texture format is not supported on current platform! Using RGBA8 (default).", 1);
				__surfaceFormat = __surfaceFormatBase;
			}
		} else {
			__surfaceFormat = __surfaceFormatBase;
		}
		// Recreate surfaces (if exists) with the new texture format
		__stacksClean();
		return self;
	}
	
	/// @desc Toggle whether the Post-processing renderer can draw.
	/// Please note that if disabled, it may still be rendered if rendering is enabled (will continue to demand GPU).
	/// @method SetDrawEnable(enable)
	/// @param {real} enable Will be either true (enabled, the default value) or false (disabled). The drawing will toggle if nothing or -1 is entered.
	/// @returns {undefined}
	static SetDrawEnable = function(_enable=-1) {
		if (_enable == -1) {
			__isDrawEnabled = !__isDrawEnabled;
		} else {
			__isDrawEnabled = _enable;
		}
		return self;
	}
	
	/// @desc Toggle whether the Post-processing renderer can render.
	/// Please note that if enabled, it can render to the surface even if not drawing!
	/// @method SetRenderEnable(enable)
	/// @param {Real} enable Will be either true (enabled, the default value) or false (disabled). The rendering will toggle if nothing or -1 is entered.
	/// @param {Bool} clearMemory If true and "enabled" is false, cleans all internal surfaces of VRAM.
	/// @returns {undefined}
	static SetRenderEnable = function(_enable=-1, _clearMemory=false) {
		if (_enable == -1) {
			__isRenderEnabled = !__isRenderEnabled;
		} else {
			__isRenderEnabled = _enable;
		}
		if (!__isRenderEnabled && _clearMemory) {
			__stacksClean();
		}
		return self;
	}
	
	/// @desc This function modifies the final rendering resolution of the Post-processing renderer, based on a percentage (0 to 1). WARNING: You can upscale by using a value larger than 1, but take care with performance!
	/// @method SetRenderResolution(resolution)
	/// @param {real} resolution The resolution value.
	/// @returns {real} Value between 0 and 1.
	static SetRenderResolution = function(_resolution=1) {
		__renderResolution = clamp(_resolution, 0.01, 4);
		return self;
	}
	
	/// @desc Modify a single parameter (setting) of an effect. Use this to modify an effect's attribute in real-time.
	/// @method SetEffectParameter(_effect, param, value)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @param {String} param Parameter name macro. Example: PP_BLOOM_COLOR.
	/// @param {Any} value Parameter value. Example: make_color_rgb_ppfx(255, 255, 255).
	/// @returns {undefined}
	static SetEffectParameter = function(_effect, _param, _value) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		_effectStruct[$ _param] = _value;
		return self;
	}
	
	/// @desc Modify various parameters of an effect. Use this if you want to modify an effect's attributes in real-time.
	/// @method SetEffectParameters(_effect, paramsArray, valuesArray)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @param {Array} paramsArray Array with the effect parameters. Use the pre-defined macros, for example: [PP_BLOOM_COLOR, PP_BLOOM_INTENSITY].
	/// @param {Array} valuesArray Array with parameter values, must be in the same order.
	/// @returns {undefined}
	static SetEffectParameters = function(_effect, _paramsArray, _valuesArray) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		var i = 0, isize = array_length(_paramsArray);
		repeat(isize) {
			_effectStruct[$ _paramsArray[i]] = _valuesArray[i];
			++i;
		}
		return self;
	}
	
	/// @desc This function toggles the effect rendering.
	/// @method SetEffectEnable(_effect, enabled)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @param {Real} enabled Will be either true (enabled) or false (disabled). The rendering will toggle if nothing or -1 is entered.
	/// @returns {undefined}
	static SetEffectEnable = function(_effect, _enabled=-1) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		if (_enabled == -1) {
			_effectStruct.enabled = !_effectStruct.enabled;
		} else {
			if (!_enabled) {
				if (_effectStruct.Clean != undefined) _effectStruct.Clean(); // clean effect if disabled
			}
			_effectStruct.enabled = _enabled;
		}
		return self;
	}
	
	/// @desc This function defines the order in which an effect will be rendered in the stack. You can use the PPFX_STACK enum to base the order on some other stacks.
	/// @method SetEffectOrder(_effect, _newOrder)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @param {Real} newOrder The new effect rendering order.
	static SetEffectOrder = function(_effect, _newOrder) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		_effectStruct.SetOrder(_newOrder);
		__effectsReorder();
		return self;
	}
	
	/// @desc Sets the delta time variable to be used in the renderer (optional).
	/// @method SetDeltaTime(deltaTime)
	/// @param {Real} deltaTime The delta time. 1 is the default delta time.
	static SetDeltaTime = function(_deltaTime) {
		__deltaTime = _deltaTime;
		return self;
	}
	
	/// @desc Sets the time that the renderer will reset its timer. Useful for mobile devices, for low precision reasons.
	/// @method SetTimer(value)
	/// @param {Real} value The timer, in seconds (default value is PPFX_CFG_TIMER). Use -1 for unlimited.
	static SetTimer = function(_value) {
		__timer = _value;
		return self;
	}
	
	/// @desc Returns true if effect rendering is enabled, and false if not. false is returned if the effect does not exist.
	/// @method IsEffectEnabled()
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @returns {Bool}
	static IsEffectEnabled = function(_effect) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			return false;
		}
		return _effectStruct.enabled;
	}
	
	/// @desc Returns true if Post-processing renderer drawing is enabled, and false if not.
	/// @method IsDrawEnabled()
	/// @returns {Bool}
	static IsDrawEnabled = function() {
		return __isDrawEnabled;
	}
	
	/// @desc Returns true if Post-processing renderer rendering is enabled, and false if not.
	/// @method IsRenderEnabled()
	/// @returns {Bool}
	static IsRenderEnabled = function() {
		return __isRenderEnabled;
	}
	
	/// @desc Returns true if the renderer is rendering on layers.
	/// @method IsLayered()
	/// @returns {Bool}
	static IsLayered = function() {
		return __isLayerRendering;
	}
	
	/// @desc Returns the Post-processing renderer final rendering surface.
	/// @method GetRenderSurface()
	/// @returns {Id.Surface} Surface index.
	static GetRenderSurface = function() {
		return __renderSurfaceOutput;
	}
	
	/// @desc Returns the specific stack rendering surface.
	/// @method GetStackSurface()
	/// @param {Real} index The stack index.
	/// @returns {Id.Surface} Surface index.
	static GetStackSurface = function(_index) {
		return __stackSurfaces[clamp(_index, 0, __stackIndex)];
	}
	
	/// @desc Returns the Post-processing renderer rendering percentage (0 to 1).
	/// @method GetRenderResolution()
	/// @returns {real} Normalized size.
	static GetRenderResolution = function() {
		return __renderResolution;
	}
	
	/// @desc Get a single parameter (setting) value of an effect.
	/// @method GetEffectParameter(effect, param)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @param {String} param Parameter macro. Example: PP_BLOOM_COLOR.
	/// @returns {Any}
	static GetEffectParameter = function(_effect, _param) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		return _effectStruct[$ _param];
	}
	
	/// @desc Gets the order the effect is rendered on the stack.
	/// @method GetEffectOrder(effect)
	/// @param {Real} effect Effect name. Use the macro starting with FF_, example: FF_BLOOM. Or, the effectName: "bloom".
	/// @returns {Any}
	static GetEffectOrder = function(_effect) {
		var _effectStruct = __effects[$ _effect];
		if (_effectStruct == undefined) {
			__ppf_trace($"'{_effect}' effect does not exists in the {instanceof(self)} instance (not loaded from a profile).", 1);
			exit;
		}
		return _effectStruct.stackOrder;
	}
	
	/// @desc This function disables all loaded effects immediately.
	/// @method DisableAllEffects()
	/// @returns {Undefined}
	static DisableAllEffects = function() {
		var i = 0;
		repeat(__effectsOrderedAmount) {
			__effectsOrdered[i].enabled = false;
			++i;
		}
	}
	
	/// @desc Set a sprite (neutral LUT image) to bake all color grading stack into it.
	/// @method SetBakingLUT(sprite)
	/// @param {Asset.GMSprite} sprite The neutral linear LUT to be used to bake. You can use a LUT returned by PPFX_LUTGenerator(). Use -1 to remove it.
	/// @ignore
	static SetBakingLUT = function(_sprite) {
		// remove existing baking lut
		if (surface_exists(__miscBakedLUTSurf)) {
			surface_free(__miscBakedLUTSurf);
			__miscBakedLUTSurf = -1;
			__miscLinearLUTSprite = -1;
		}
		// set a new lut, if exists
		if (_sprite != -1) {
			__miscLinearLUTSprite = _sprite;
		}
	}
	
	/// @desc Bake all color grading stack into a LUT image. Returns a new sprite, which means you should not call this every frame, to prevent a memory leaks.
	/// @method GetBakedLUT()
	/// @returns {Asset.GMSprite} The modified LUT to be used with FX_LUT().
	/// @ignore
	static GetBakedLUT = function() {
		if (surface_exists(__miscBakedLUTSurf)) {
			return sprite_create_from_surface(__miscBakedLUTSurf, 0, 0, surface_get_width(__miscBakedLUTSurf), surface_get_height(__miscBakedLUTSurf), false, false, 0, 0);
		}
		return undefined;
	}
	
	#endregion
	
	#region Render
	
	/// @desc Draw Post-processing's final surface on screen. This function works like draw_surface_stretched(), but with the effects applied. The resolution of the internal surfaces will be the same as the input surface.
	/// This is similar to draw_surface_stretched().
	/// @method Draw(surface, x, y, w, h)
	/// @param {Id.Surface} surface The input surface to copy from. You can use application_surface or your own.
	/// @param {real} x The x position of where to draw the surface.
	/// @param {real} y The y position of where to draw the surface.
	/// @param {real} w The width at which to draw the surface.
	/// @param {real} h The height at which to draw the surface.
	/// @returns {undefined}
	static Draw = function(_surface, _x, _y, _w, _h) {
		__renderSurfaceOutput = _surface;
		
		#region Checks
		if (__destroyed) exit;
		var _inputSurfaceWidth = surface_get_width(_surface),
			_inputSurfaceHeight = surface_get_height(_surface);
		if (!surface_exists(_surface) || _inputSurfaceWidth <= 0 || _inputSurfaceHeight <= 0) {
			if (__allowRendering) {
				__allowRendering = false;
				__ppf_trace("WARNING: trying to renderize/draw using non-existent surface (or zero size)", 2);
			}
			exit;
		}
		if (_surface == application_surface && event_number != ev_draw_post && event_number != ev_gui_begin) {
			if (__allowRendering) {
				__allowRendering = false;
				__ppf_trace("ERROR: While using application_surface, the renderer can only be drawn in the Post-Draw or Draw GUI Begin event. You cannot draw a surface within itself!", 1);
			}
			exit;
		}
		if (__isLayerRendering && (event_number == ev_draw_post || event_number == ev_gui_begin)) {
			if (__allowRendering) {
				__allowRendering = false;
				__ppf_trace("ERROR: Renderer is already rendering on the layer! Do NOT call .Draw() manually", 1);
			}
			exit;
		}
		__allowRendering = true;
		#endregion
		
		// Render Everything
		gpu_push_state();
		__cpuFrameTime = 0;
		if (__isRenderEnabled) {
			// time
			__time += __timeSpeed * __deltaTime;
			if (__timer > 0 && __time > __timer) __time = 0;
			
			// if different resolution, delete stuff to be updated
			if (_inputSurfaceWidth != __oldInputSurfaceWidth || _inputSurfaceHeight != __oldInputSurfaceHeight || __renderResolution != __oldRenderResolution) {
				__oldRenderResolution = __renderResolution;
				__oldInputSurfaceWidth = _inputSurfaceWidth;
				__oldInputSurfaceHeight = _inputSurfaceHeight;
				__stacksClean();
				__renderSurfaceWidth = _inputSurfaceWidth * __renderResolution;
				__renderSurfaceHeight = _inputSurfaceHeight * __renderResolution;
				__renderSurfaceWidth -= frac(__renderSurfaceWidth);
				__renderSurfaceHeight -= frac(__renderSurfaceHeight);
			}
			
			// ============== STACK PROCESS ==============
			__stackIndex = 0;
			__stackSurfaces[0] = _surface;
			var _currentFrameTime = get_timer();
			
			if (__effectsOrderedAmount > 0) {
				var _depthDisable = surface_get_depth_disable();
				surface_depth_disable(true);
				gpu_set_tex_repeat(false);
				//gpu_set_cullmode(cull_noculling);
				gpu_set_zwriteenable(false);
				gpu_set_ztestenable(false);
				gpu_set_alphatestenable(false);
				
				// loop
				var _current = __effectsOrdered[0], _next = -1, _stackOpened = false, _stackOpenedIndex = 0; // order of opened stack
				for (var i = 0; i < __effectsOrderedAmount; ++i) {
					// current effect struct
					_current = __effectsOrdered[i];
					// stack start (executed once, when opening stack)
					if (!_stackOpened) {
						if (_current.isStackShared && _current.enabled) {
							__runSharedEffect(_current.stackOrder, true, __renderSurfaceWidth, __renderSurfaceHeight, __time); // acessar o struct diretamente usando _current.stackOrder, e executar o Start
							_stackOpenedIndex = _current.stackOrder;
							_stackOpened = true;
						}
					}
					// run the draw method from effect struct.
					_current.Draw(self, __renderSurfaceWidth, __renderSurfaceHeight, __time);
					// stack end
					if (_stackOpened) {
						_next = __effectsOrdered[min(i+1, __effectsOrderedAmount-1)];
						if (_next.stackOrder != _stackOpenedIndex || i == __effectsOrderedAmount-1) {
							__runSharedEffect(_current.stackOrder, false, __renderSurfaceWidth, __renderSurfaceHeight, __time);
							_stackOpened = false;
						}
					}
				}
				// reset depth buffer state
				surface_depth_disable(_depthDisable);
			}
			
			__renderSurfaceOutput = __stackSurfaces[__stackIndex];
			__cpuFrameTime = get_timer() - _currentFrameTime;
			// ===========================================
		}
		
		// Draw
		if (__enableBlending) {gpu_set_blendenable(true); gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);} else {gpu_set_blendenable(false);}
		if (__isDrawEnabled) draw_surface_stretched(__renderSurfaceOutput, _x, _y, _w, _h);
		gpu_pop_state();
	}
	
	/// @desc Easily draw Post-processing renderer in full screen. It is an alternative to the normal .Draw() method.
	///
	/// This function automatically detects the draw event you are drawing (Post-Draw or Draw GUI Begin).
	///
	/// It uses the size of the referenced surface for internal rendering resolution (example: application_surface size).
	/// 
	/// For the width and height size (scaled rendering size): If drawing in Post-Draw, is the size of the window (frame buffer). If in Draw GUI Begin, the size of the GUI.
	/// @method DrawInFullscreen(surface)
	/// @param {Id.Surface} surface Render surface to copy from. (You can use application_surface).
	static DrawInFullscreen = function(_surface=application_surface) {
		var _xx = 0, _yy = 0, _width = 0, _height = 0;
		if (event_number == ev_draw_post) {
			if (os_type != os_operagx) {
				var _pos = application_get_position();
				_xx = _pos[0];
				_yy = _pos[1];
				_width = _pos[2]-_pos[0];
				_height = _pos[3]-_pos[1];
			} else {
				if (GM_build_type == "run") {
					var _pos = application_get_position();
					_xx = _pos[0];
					_yy = _pos[1];
					_width = _pos[2]-_pos[0];
					_height = _pos[3]-_pos[1];
				} else {
					_width = browser_width;
					_height = browser_height;
				}
			}
		} else
		if (event_number == ev_gui_begin) {
			_width = display_get_gui_width();
			_height = display_get_gui_height();
		}
		Draw(_surface, _xx, _yy, _width, _height);
	}
	
	#endregion
}
