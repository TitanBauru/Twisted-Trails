
// Feather ignore all

#region Shared Effects

// Shared stacks are NOT reordered by PPFX_Renderer(). The order is defined by the PPFX_STACK enum

/// @ignore
function __PPF_STSuperClass() {
	stackName = "N/A";
	stackOrder = -1; // PPFX_STACK.
	shaderIndex = -1; // sh_test
}

#region Base

/// @ignore
function __ST_Base() : __PPF_STSuperClass() constructor {
	stackName = "base";
	stackOrder = PPFX_STACK.BASE;
	shaderIndex = __ppf_shRenderBase;
	
	u_resolution = shader_get_uniform(shaderIndex, "u_resolution");
	u_time = shader_get_uniform(shaderIndex, "u_time");
	u_rotationEnable = shader_get_uniform(shaderIndex, "u_rotationEnable");
	u_zoomEnable = shader_get_uniform(shaderIndex, "u_zoomEnable");
	u_shakeEnable = shader_get_uniform(shaderIndex, "u_shakeEnable");
	u_lensDistortionEnable = shader_get_uniform(shaderIndex, "u_lensDistortionEnable");
	u_pixelizeEnable = shader_get_uniform(shaderIndex, "u_pixelizeEnable");
	u_swirlEnable = shader_get_uniform(shaderIndex, "u_swirlEnable");
	u_panoramaEnable = shader_get_uniform(shaderIndex, "u_panoramaEnable");
	u_sinewaveEnable = shader_get_uniform(shaderIndex, "u_sinewaveEnable");
	u_interferenceEnable = shader_get_uniform(shaderIndex, "u_interferenceEnable");
	u_shockwavesEnable = shader_get_uniform(shaderIndex, "u_shockwavesEnable");
	u_displacemapEnable = shader_get_uniform(shaderIndex, "u_displacemapEnable");
	
	static Start = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		// start stack
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, stackName);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(shaderIndex);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			// resetting effects to disabled (later they will override this)
			shader_set_uniform_f(u_rotationEnable, false);
			shader_set_uniform_f(u_zoomEnable, false);
			shader_set_uniform_f(u_shakeEnable, false);
			shader_set_uniform_f(u_lensDistortionEnable, false);
			shader_set_uniform_f(u_pixelizeEnable, false);
			shader_set_uniform_f(u_swirlEnable, false);
			shader_set_uniform_f(u_panoramaEnable, false);
			shader_set_uniform_f(u_sinewaveEnable, false);
			shader_set_uniform_f(u_interferenceEnable, false);
			shader_set_uniform_f(u_shockwavesEnable, false);
			shader_set_uniform_f(u_displacemapEnable, false);
	}
	
	static End = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
			// end stack
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
}

#endregion

#region Color Grading

/// @ignore
function __ST_ColorGrading() : __PPF_STSuperClass() constructor {
	stackName = "color_grading";
	stackOrder = PPFX_STACK.COLOR_GRADING;
	shaderIndex = __ppf_shRenderColorGrading;
	uniResolution = shader_get_uniform(shaderIndex, "u_resolution");
	u_time = shader_get_uniform(shaderIndex, "u_time");
	
	u_toneMappingEnable = shader_get_uniform(shaderIndex, "u_toneMappingEnable");
	u_LUTenable = shader_get_uniform(shaderIndex, "u_LUTenable");
	u_curvesEnable = shader_get_uniform(shaderIndex, "u_curvesEnable");
	u_whiteBalanceEnable = shader_get_uniform(shaderIndex, "u_whiteBalanceEnable");
	u_exposureEnable = shader_get_uniform(shaderIndex, "u_exposureEnable");
	u_brightnessEnable = shader_get_uniform(shaderIndex, "u_brightnessEnable");
	u_contrastEnable = shader_get_uniform(shaderIndex, "u_contrastEnable");
	u_colorBalanceEnable = shader_get_uniform(shaderIndex, "u_colorBalanceEnable");
	u_saturationEnable = shader_get_uniform(shaderIndex, "u_saturationEnable");
	u_hueshiftEnable = shader_get_uniform(shaderIndex, "u_hueshiftEnable");
	u_hueshiftHSV = shader_get_uniform(shaderIndex, "u_hueshiftHSV");
	u_colortintEnable = shader_get_uniform(shaderIndex, "u_colortintEnable");
	u_colorizeEnable = shader_get_uniform(shaderIndex, "u_colorizeEnable");
	u_channelMixerEnable = shader_get_uniform(shaderIndex, "u_channelMixerEnable");
	u_posterizationEnable = shader_get_uniform(shaderIndex, "u_posterizationEnable");
	u_invertColorsEnable = shader_get_uniform(shaderIndex, "u_invertColorsEnable");
	u_liftGammaGainEnable = shader_get_uniform(shaderIndex, "u_liftGammaGainEnable");
	
	static Start = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		// start stack
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, stackName);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(shaderIndex);
			shader_set_uniform_f(uniResolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			// reseting effects parameters (later they will overwrite this)
			shader_set_uniform_f(u_toneMappingEnable, false);
			shader_set_uniform_f(u_LUTenable, false);
			shader_set_uniform_f(u_curvesEnable, false);
			shader_set_uniform_f(u_whiteBalanceEnable, false);
			shader_set_uniform_f(u_exposureEnable, false);
			shader_set_uniform_f(u_brightnessEnable, false);
			shader_set_uniform_f(u_contrastEnable, false);
			shader_set_uniform_f(u_colorBalanceEnable, false);
			shader_set_uniform_f(u_saturationEnable, false);
			shader_set_uniform_f(u_hueshiftEnable, false);
			shader_set_uniform_f(u_hueshiftHSV, 0, 1, 1);
			shader_set_uniform_f(u_colortintEnable, false);
			shader_set_uniform_f(u_colorizeEnable, false);
			shader_set_uniform_f(u_channelMixerEnable, false);
			shader_set_uniform_f(u_posterizationEnable, false);
			shader_set_uniform_f(u_invertColorsEnable, false);
			shader_set_uniform_f(u_liftGammaGainEnable, false);
	}
	
	static End = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
			// Bake color grading stack into a lut (if needed)
			// Create lut surface if the lut sprite (from LUTGenerator) exists
			if (sprite_exists(_renderer.__miscLinearLUTSprite)) {
				var _linearLUTSprite = _renderer.__miscLinearLUTSprite;
				if (!surface_exists(_renderer.__miscBakedLUTSurf)) {
					_renderer.__miscBakedLUTSurf = surface_create(sprite_get_width(_linearLUTSprite), sprite_get_height(_linearLUTSprite));
				}
				var _isUsingToneMapping = (_renderer.__effectExists(FF_TONE_MAPPING) && _renderer.IsEffectEnabled(FF_TONE_MAPPING));
				surface_set_target(_renderer.__miscBakedLUTSurf); // this surface should be deleted later
				if (_isUsingToneMapping) shader_set_uniform_f(u_toneMappingEnable, false); // disable tone mapping (important)
				draw_sprite(_linearLUTSprite, 0, 0, 0);
				if (_isUsingToneMapping) shader_set_uniform_f(u_toneMappingEnable, true);
				surface_reset_target();
			}
			// end stack
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
}

#endregion

#region Final

/// @ignore
function __ST_Final() : __PPF_STSuperClass() constructor {
	stackName = "final";
	stackOrder = PPFX_STACK.FINAL;
	shaderIndex = __ppf_shRenderFinal;
	u_resolution = shader_get_uniform(shaderIndex, "u_resolution");
	u_time = shader_get_uniform(shaderIndex, "u_time");
	u_mistEnable = shader_get_uniform(shaderIndex, "u_mistEnable");
	u_speedlinesEnable = shader_get_uniform(shaderIndex, "u_speedlinesEnable");
	u_ditheringEnable = shader_get_uniform(shaderIndex, "u_ditheringEnable");
	u_noiseGrainEnable = shader_get_uniform(shaderIndex, "u_noiseGrainEnable");
	u_vignetteEnable = shader_get_uniform(shaderIndex, "u_vignetteEnable");
	u_NESFadeEnable = shader_get_uniform(shaderIndex, "u_NESFadeEnable");
	u_fadeEnable = shader_get_uniform(shaderIndex, "u_fadeEnable");
	u_scanlinesEnable = shader_get_uniform(shaderIndex, "u_scanlinesEnable");
	u_cinamaBarsEnable = shader_get_uniform(shaderIndex, "u_cinamaBarsEnable");
	u_colorBlindnessEnable = shader_get_uniform(shaderIndex, "u_colorBlindnessEnable");
	u_channelsEnable = shader_get_uniform(shaderIndex, "u_channelsEnable");
	u_borderEnable = shader_get_uniform(shaderIndex, "u_borderEnable");
	// dependencies
	uni_d_lens_distortion_enable = shader_get_uniform(shaderIndex, "u_lensDistortionEnable");
	uni_d_lens_distortion_amount = shader_get_uniform(shaderIndex, "u_lensDistortionAmount");
	
	static Start = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		// start stack
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, stackName);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(shaderIndex);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			// reseting effects to disabled (later they will overwrite this)
			shader_set_uniform_f(u_mistEnable, false);
			shader_set_uniform_f(u_speedlinesEnable, false);
			shader_set_uniform_f(u_ditheringEnable, false);
			shader_set_uniform_f(u_noiseGrainEnable, false);
			shader_set_uniform_f(u_vignetteEnable, false);
			shader_set_uniform_f(u_NESFadeEnable, false);
			shader_set_uniform_f(u_fadeEnable, false);
			shader_set_uniform_f(u_scanlinesEnable, false);
			shader_set_uniform_f(u_cinamaBarsEnable, false);
			shader_set_uniform_f(u_colorBlindnessEnable, false);
			shader_set_uniform_f(u_channelsEnable, false);
			shader_set_uniform_f(u_borderEnable, false);
			shader_set_uniform_f(uni_d_lens_distortion_enable, false);
			var _lensEffect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
			if (_lensEffect != undefined) {
				shader_set_uniform_f(uni_d_lens_distortion_enable, _lensEffect.enabled);
				shader_set_uniform_f(uni_d_lens_distortion_amount, _lensEffect.amount);
			}
	}
	
	static End = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
			// end stack
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
}

#endregion

#endregion


#region Effects

// These effects are reordered by PPFX_Renderer(). Note that effects with shared stacks have the same order!

/// @ignore
function __PPF_FXSuperClass() constructor {
	effectName = "N/A";
	stackOrder = -1; // which order the effect will be rendered. effects within shared stacks have the same order
	isStackShared = false; // if the effect shares the same stack (surface) with another
	canChangeOrder = true;
	orderWasChanged = false;
	isExternalEffect = false;
	
	// override this, when needed
	static Draw = undefined; // for rendering
	static Clean = undefined; // for data clean
	static ExportData = undefined; // for profile stringify
	static GetEditorData = undefined; // for external effects with editor data
	
	/// @desc This function defines a new rendering order for this effect. The order defines which effect should renderize above or below another effect.
	/// @method SetOrder(new_order)
	/// @param {Real} new_order The new rendering order.
	static SetOrder = function(_newOrder) {
		if (!canChangeOrder) {
			__ppf_trace($"Unable to set order of '{effectName}' effect to {_newOrder}. Using {stackOrder}. Not allowed.", 1);
		} else
		if (_newOrder == PPFX_STACK.BASE || _newOrder == PPFX_STACK.COLOR_GRADING || _newOrder == PPFX_STACK.FINAL) {
			__ppf_trace($"The new order {_newOrder} of '{effectName}' cannot be within the order of shared stacks. Using {stackOrder}.", 1);
		} else {
			stackOrder = _newOrder;
			orderWasChanged = true;
		}
		return self;
	}
	
	/// @desc Returns the current stack order
	/// @method GetOrder()
	static GetOrder = function() {
		return stackOrder;
	}
}

// Independent Effects

#region Bloom

/// @desc The Bloom effect makes bright areas in your image glow, making a realistic simulation of light. The effect also has dirt-lens to simulate a dirty camera.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} iterations Sets Bloom’s scattering, which is how far the effect reaches. Max: 16. recommended: 4 - 8.
/// @param {Real} threshold Bloom is only applied to pixels in the scene that have a brightness GREATER than this value. The minimum value is 0, where nothing is filtered. There is no maximum value.
/// To apply bloom to specific locations, it is recommended to use HDR (high dynamic range). Enable this in the renderer with .SetHDREnable(). Then, you will use a threshold value above 1. Recommended: 1.5. Any value above this will emit glow.
/// Note that the application_surface does not support HDR out of the box, so you will need to use the "Crystal Lighting Engine" or the "HDR Mode" asset.
/// @param {Real} knee Controls the softness of the transition between the bloomed and non-bloomed areas of the image.
/// @param {Real} intensity Set the strength of the Bloom filter. 0 to 5 recommended. There is not maximum amount.
/// @param {Real} color The color that is multiplied by the bloom's final color. Default is c_white.
/// @param {Real} whiteAmount How close to white Bloom will look, in very saturated colors. 1 is full white.
/// @param {Bool} dirtEnable Defines whether to use dirt textures.
/// @param {Pointer.Texture} dirtTexture The texture id used for the Dirt Lens. Use sprite_get_texture() or surface_get_texture().
/// @param {Real} dirtIntensity The intensity of Dirt Lens. 0 to 3 recommended.
/// @param {Real} dirtScale The scale of Dirt Lens. 0.25 to 3 recommended.
/// @param {Real} dirtTiled Defines whether the dirt lens will repeat seamlessly.
/// @param {Bool} dirtCanDistort If active, the dirt texture will distort according to the lens distortion effect.
/// @param {Real} resolution Sets the resolution of the Bloom, this affects the performance. 1 is full resolution = more resources needed, but look better. 1 = full, 0.5 = falf.
/// @param {Bool} debug1 Allows you to see the final bloom result alone.
/// @param {Bool} debug2 Allows you to see exactly where the bloom is hitting the light parts.
function FX_Bloom(_enabled, _iterations=8, _threshold=0.4, _knee=0, _intensity=3, _color=c_white, _whiteAmount=0, _dirtEnable=false, _dirtTexture=undefined, _dirtIntensity=2.5, _dirtScale=1, _dirtTiled=true, _dirtCanDistort=false, _resolution=1, _debug1=false, _debug2=false) : __PPF_FXSuperClass() constructor {
	effectName = "bloom";
	stackOrder = PPFX_STACK.BLOOM;
	
	enabled = _enabled;
	iterations = _iterations;
	threshold = _threshold;
	knee = _knee;
	intensity = _intensity;
	color = make_color_ppfx(_color);
	whiteAmount = _whiteAmount;
	dirtEnable = _dirtEnable;
	dirtTexture = _dirtTexture ?? __ppfxGlobal.textureDirtLens;
	dirtIntensity = _dirtIntensity;
	dirtScale = _dirtScale;
	dirtTiled = _dirtTiled;
	dirtCanDistort = _dirtCanDistort;
	resolution = _resolution;
	debug1 = _debug1;
	debug2 = _debug2;
	
	static u_preFilterTexelSize = shader_get_uniform(__ppf_shRenderBloomPreFilter, "u_texelSize");
	static u_preFilterBloomThreshold = shader_get_uniform(__ppf_shRenderBloomPreFilter, "u_bloomThreshold");
	static u_preFilterBloomIntensity = shader_get_uniform(__ppf_shRenderBloomPreFilter, "u_bloomIntensity");
	static u_preFilterBloomKnee = shader_get_uniform(__ppf_shRenderBloomPreFilter, "u_bloomKnee");
	static u_resolution = shader_get_uniform(__ppf_shRenderBloom, "u_resolution");
	static u_texelSize = shader_get_uniform(__ppf_shRenderBloom, "u_texelSize");
	static u_bloomColor = shader_get_uniform(__ppf_shRenderBloom, "u_bloomColor");
	static u_bloomIntensity = shader_get_uniform(__ppf_shRenderBloom, "u_bloomIntensity");
	static u_bloomWhiteAmount = shader_get_uniform(__ppf_shRenderBloom, "u_bloomWhiteAmount");
	static u_bloomDirtEnable = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtEnable");
	static u_bloomDirtIntensity = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtIntensity");
	static u_bloomDirtScale = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtScale");
	static u_bloomDirtCanDistort = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtCanDistort");
	static u_bloomDirtIsTiled = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtIsTiled");
	static u_bloomDirtTexture = shader_get_sampler_index(__ppf_shRenderBloom, "u_bloomDirtTexture");
	static u_bloomTexture = shader_get_sampler_index(__ppf_shRenderBloom, "u_bloomTexture");
	static u_bloomDirtTexUVs = shader_get_uniform(__ppf_shRenderBloom, "u_bloomDirtTexUVs");
	static u_dsBox4TexelSize = shader_get_uniform(__ppf_shBlurBox4, "u_texelSize");
	static u_dsBox13TexelSize = shader_get_uniform(__ppf_shBlurBox13, "u_texelSize");
	static u_usTentTexelSize = shader_get_uniform(__ppf_shBlurTent9, "u_texelSize");
	// dependencies
	static u_d_lensDistortionEnable = shader_get_uniform(__ppf_shRenderBloom, "u_lensDistortionEnable");
	static u_d_lensDistortionAmount = shader_get_uniform(__ppf_shRenderBloom, "u_lensDistortionAmount");
	
	bloomSurfaces = array_create(10, -1);
	oldBloomResolution = 0;
	currentSource = undefined;
	currentDestination = undefined;
	canRender = true;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) {
			if (canRender) {
				canRender = false;
				Clean();
			}
			exit;
		}
		canRender = true;
		
		// settings
		var _iterations = clamp(iterations, 2, 8),
			_res = clamp(resolution, 0.1, 1),
			_ww = _surfaceWidth * _res,
			_hh = _surfaceHeight * _res,
			_texFormat = _renderer.__surfaceFormat;
		
		if (oldBloomResolution != _res) {
			oldBloomResolution = _res;
			Clean();
		}
		
		// source pre filter (surface_blit)
		if (!surface_exists(bloomSurfaces[0])) {
			bloomSurfaces[0] = surface_create(_surfaceWidth, _surfaceHeight, _texFormat);
		}
		currentDestination = bloomSurfaces[0];
		gpu_push_state();
		gpu_set_tex_filter(true);
		surface_set_target(currentDestination);
			shader_set(__ppf_shRenderBloomPreFilter);
			shader_set_uniform_f(u_preFilterTexelSize, 1/_surfaceWidth, 1/_surfaceHeight);
			shader_set_uniform_f(u_preFilterBloomThreshold, threshold);
			shader_set_uniform_f(u_preFilterBloomIntensity, intensity);
			shader_set_uniform_f(u_preFilterBloomKnee, knee);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex], 0, 0, _surfaceWidth, _surfaceHeight); // source (current stack)
			shader_reset();
		surface_reset_target();
		currentSource = currentDestination;
		
		// downsampling (surface_blit)
		shader_set(__ppf_shBlurBox13);
		var i = 1; // there is already a texture in slot 0
		repeat(_iterations) {
			_ww /= 2;
			_hh /= 2;
			_ww -= frac(_ww);
			_hh -= frac(_hh);
			//if (min(_ww, _hh) < 2) break;
			if (_ww < 2 || _hh < 2) break;
			if (!surface_exists(bloomSurfaces[i])) {
				bloomSurfaces[i] = surface_create(_ww, _hh, _texFormat);
			}
			currentDestination = bloomSurfaces[i];
				surface_set_target(currentDestination);
					shader_set_uniform_f(u_dsBox13TexelSize, 1/_ww, 1/_hh);
					draw_surface_stretched(currentSource, 0, 0, _ww, _hh);
				surface_reset_target();
			currentSource = currentDestination;
			++i;
		}
		shader_reset();
		
		// upsampling (surface_blit)
		gpu_set_blendmode(bm_max);
		shader_set(__ppf_shBlurTent9);
		var _start = !debug1;
		for(i -= 2; i >= _start; i--) { // 7, 6, 5, 4, 3, 2, 1, 0
			currentDestination = bloomSurfaces[i];
				_ww = surface_get_width(currentDestination);
				_hh = surface_get_height(currentDestination);
				surface_set_target(currentDestination);
					shader_set_uniform_f(u_usTentTexelSize, 1/_ww, 1/_hh);
					draw_surface_stretched(currentSource, 0, 0, _ww, _hh);
				surface_reset_target();
			currentSource = currentDestination;
		}
		shader_reset();
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(__ppf_shRenderBloom);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_texelSize, 1/_surfaceWidth, 1/_surfaceHeight);
			shader_set_uniform_f_array(u_bloomColor, color);
			shader_set_uniform_f(u_bloomIntensity, intensity);
			shader_set_uniform_f(u_bloomWhiteAmount, whiteAmount);
			shader_set_uniform_f(u_bloomDirtEnable, dirtEnable);
			shader_set_uniform_f(u_bloomDirtIntensity, dirtIntensity*5);
			shader_set_uniform_f(u_bloomDirtScale, dirtScale);
			shader_set_uniform_f(u_bloomDirtIsTiled, dirtTiled);
			shader_set_uniform_f(u_bloomDirtCanDistort, dirtCanDistort);
			texture_set_stage(u_bloomTexture, surface_get_texture(currentDestination));
			if (dirtTexture != undefined) {
				texture_set_stage(u_bloomDirtTexture, dirtTexture);
				gpu_set_tex_repeat_ext(u_bloomDirtTexture, false);
				var _texUVs = texture_get_uvs(dirtTexture);
				shader_set_uniform_f(u_bloomDirtTexUVs, _texUVs[0], _texUVs[1], _texUVs[2], _texUVs[3]);
			}
			if (dirtCanDistort) {
				var _lensEffect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
				if (_lensEffect != undefined) {
					shader_set_uniform_f(u_d_lensDistortionEnable, _lensEffect.enabled);
					shader_set_uniform_f(u_d_lensDistortionAmount, _lensEffect.amount);
				}
			}
			var _surface = _renderer.__stackSurfaces[_renderer.__stackIndex-1];
			if (debug1) _surface = currentDestination;
			if (debug2) {_surface = currentDestination; shader_reset();}
			draw_surface_stretched(_surface, 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
		surface_reset_target();
		
		gpu_pop_state();
	}
	
	static Clean = function() {
		__ppf_surface_delete_array(bloomSurfaces);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, iterations, threshold, knee, intensity, ["color", color], whiteAmount, dirtEnable, dirtTexture, dirtIntensity, dirtScale, dirtTiled, dirtCanDistort, resolution, debug1, debug2],
		};
	}
}

#endregion

#region Sunshafts

/// @desc Simulates the radial light scattering that arises when a very bright light source is partly obscured.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Array<Real>} position Sun position. An array with the normalized values (0 to 1), in this format: [x, y]. Please Note: The value is in screen-space. So it depends on where you are going to draw post-processing. Example: normalized GUI coordinates.
/// @param {Real} threshold Set the level of brightness to filter out pixels under this level. 0 means full brightness. Values above 1 are HDR (which allows Sunshafts to glow without affecting the rest of the game's artwork, useful for sun effect).
/// @param {Real} intensity Set the strength of the Sunshafts effect. 0 to 5 recommended.
/// @param {Real} dimmer Maximum brightness level to be reduced. 0 to 5 recommended.
/// @param {Real} scattering How far the sun's rays are projected. 0 to 1.
/// @param {Bool} raysNoiseEnable Defines whether to use noise variations in the sun.
/// @param {Real} raysIntensity The intensity of noise rays. 0 to 1.
/// @param {Real} raysTiling Repetition of noise rays. 1 to 10 recommended.
/// @param {Real} raysSpeed The rays speed. 0 to 1 recommended.
/// @param {Real} raysOcclusionRadius Radius of the ray occlusion circle.
/// @param {Real} raysOcclusionSmoothness Smoothness of the ray occlusion circle.
/// @param {Pointer.Texture} raysNoiseTex The noise texture, used for rays.
/// @param {Real} resolution Sets the resolution of the sun shafts, this changes the performance. 1 = full, 0.5 = falf.
/// @param {Bool} debug Allows you to see exactly where the sunshaft is hitting the light parts.
/// @param {Real} sourceOffset Source stack offset. Indicates which stack the sunshafts effect will use as a source to emit lightning. The default is 0, which is the Sunshafts stack. Note: the shift happens to the previous stack always, no matter if the value is negative or positive.
function FX_SunShafts(_enabled, _position=[0.5, 0.5], _threshold=0.5, _intensity=3, _dimmer=0.5, _scattering=1, _raysNoiseEnable=false, _raysIntensity=1, _raysTiling=1, _raysSpeed=0.1, _raysOcclusionRadius=0.06, _raysOcclusionSmoothness=0.1, _raysNoiseTex=undefined, _resolution=1, _debug=false, _sourceOffset=0) : __PPF_FXSuperClass() constructor {
	effectName = "sunshafts";
	stackOrder = PPFX_STACK.SUNSHAFTS;
	
	enabled = _enabled;
	position = _position;
	threshold = _threshold;
	intensity = _intensity;
	dimmer = _dimmer;
	scattering = _scattering;
	raysNoiseEnable = _raysNoiseEnable;
	raysIntensity = _raysIntensity;
	raysTiling = _raysTiling;
	raysSpeed = _raysSpeed;
	raysOcclusionRadius = _raysOcclusionRadius;
	raysOcclusionSmoothness = _raysOcclusionSmoothness;
	raysNoiseTex = _raysNoiseTex ?? __ppfxGlobal.textureNoisePerlin;
	resolution = _resolution;
	debug = _debug;
	sourceOffset = _sourceOffset;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderSunshafts, "u_resolution");
	static u_time = shader_get_uniform(__ppf_shRenderSunshafts, "u_time");
	static u_sunshaftsNoiseUVs = shader_get_uniform(__ppf_shRenderSunshafts, "u_sunshaftsNoiseUVs");
	static u_sunshaftsNoiseTexture = shader_get_sampler_index(__ppf_shRenderSunshafts, "u_sunshaftsNoiseTexture");
	static u_sunshaftsNoiseSize = shader_get_uniform(__ppf_shRenderSunshafts, "u_sunshaftsNoiseSize");
	static u_position = shader_get_uniform(__ppf_shRenderSunshafts, "u_position");
	static u_threshold = shader_get_uniform(__ppf_shRenderSunshafts, "u_threshold");
	static u_intensity = shader_get_uniform(__ppf_shRenderSunshafts, "u_intensity");
	static u_dimmer = shader_get_uniform(__ppf_shRenderSunshafts, "u_dimmer");
	static u_scattering = shader_get_uniform(__ppf_shRenderSunshafts, "u_scattering");
	
	static u_raysNoiseTexture = shader_get_sampler_index(__ppf_shRenderSunshafts, "u_raysNoiseTexture");
	static u_raysNoiseUVs = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysNoiseUVs");
	static u_raysNoiseEnable = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysNoiseEnable");
	static u_raysOcclusionRadius = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysOcclusionRadius");
	static u_raysOcclusionSmoothness = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysOcclusionSmoothness");
	static u_raysIntensity = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysIntensity");
	static u_raysTiling = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysTiling");
	static u_raysSpeed = shader_get_uniform(__ppf_shRenderSunshafts, "u_raysSpeed");
	
	sunshaftsSurface = -1;
	oldSunshaftsResolution = 0;
	noiseSprite = __ppf_sprNoiseBlue;
	noiseTexture = sprite_get_texture(noiseSprite, 0);
	noiseUVs = texture_get_uvs(noiseTexture);
	noiseWidth = sprite_get_width(noiseSprite);
	noiseHeight = sprite_get_height(noiseSprite);
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0 || scattering <= 0) exit;
		
		// NOTE: this effect should not be affected by Bloom or Slow Motion, for better visual aspect
		var _source = _renderer.__stackGetSurfaceFromOffset(sourceOffset),
			_res = clamp(resolution, 0.1, 1),
			_ww = _surfaceWidth * _res,
			_hh = _surfaceHeight * _res;
			_ww -= frac(_ww);
			_hh -= frac(_hh);
		
		if (oldSunshaftsResolution != _res) {
			oldSunshaftsResolution = _res;
			Clean();
		}
		
		if (!surface_exists(sunshaftsSurface)) {
			sunshaftsSurface = surface_create(_ww, _hh, _renderer.__surfaceFormat);
		}
		surface_set_target(sunshaftsSurface);
			draw_clear(c_black);
			gpu_push_state();
			gpu_set_tex_filter(true);
			shader_set(__ppf_shRenderSunshafts);
			shader_set_uniform_f(u_resolution, _ww, _hh);
			shader_set_uniform_f(u_time, _time);
			shader_set_uniform_f(u_sunshaftsNoiseUVs, noiseUVs[0], noiseUVs[1], noiseUVs[2], noiseUVs[3]);
			texture_set_stage(u_sunshaftsNoiseTexture, noiseTexture);
			gpu_set_tex_repeat_ext(u_sunshaftsNoiseTexture, true);
			gpu_set_tex_filter_ext(u_sunshaftsNoiseTexture, true);
			shader_set_uniform_f(u_sunshaftsNoiseSize, noiseWidth, noiseHeight);
			shader_set_uniform_f_array(u_position, position);
			shader_set_uniform_f(u_threshold, threshold);
			shader_set_uniform_f(u_intensity, intensity);
			shader_set_uniform_f(u_dimmer, dimmer);
			shader_set_uniform_f(u_scattering, scattering);
			if (raysNoiseTex != undefined) {
				var _raysNoiseUVs = texture_get_uvs(raysNoiseTex);
				shader_set_uniform_f(u_raysNoiseUVs, _raysNoiseUVs[0], _raysNoiseUVs[1], _raysNoiseUVs[2], _raysNoiseUVs[3]);
				texture_set_stage(u_raysNoiseTexture, raysNoiseTex);
				gpu_set_tex_filter_ext(u_raysNoiseTexture, true);
			}
			shader_set_uniform_f(u_raysNoiseEnable, raysNoiseEnable);
			shader_set_uniform_f(u_raysOcclusionRadius, raysOcclusionRadius);
			shader_set_uniform_f(u_raysOcclusionSmoothness, raysOcclusionSmoothness);
			shader_set_uniform_f(u_raysIntensity, raysIntensity);
			shader_set_uniform_f(u_raysTiling, floor(raysTiling));
			shader_set_uniform_f(u_raysSpeed, raysSpeed);
			draw_surface_stretched(_source, 0, 0, _ww, _hh);
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			if (!debug) draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			gpu_set_blendmode(bm_add);
			gpu_set_colorwriteenable(true, true, true, false);
			gpu_set_tex_filter(true);
			draw_surface_stretched(sunshaftsSurface, 0, 0, _surfaceWidth, _surfaceHeight);
			gpu_pop_state();
		surface_reset_target();
	}
	
	static Clean = function() {
		__ppf_surface_delete(sunshaftsSurface);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, ["vec2", position], threshold, intensity, dimmer, scattering, raysNoiseEnable, raysIntensity, raysTiling, raysSpeed, raysOcclusionRadius, raysOcclusionSmoothness, raysNoiseTex, resolution, debug, sourceOffset],
		};
	}
}

#endregion

#region Depth of Field

/// @desc Is an effect that describes the extent to which objects that are more or less close to the plane of focus appear to be sharp.
/// This effect is given by an optical phenomenon called circles of confusion, which progressively increase as objects move away from the plane of focus;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} radius Focus radius.
/// @param {Real} intensity Bokeh bright intensity
/// @param {Real} bladesAperture Sets shape's edge number.
/// @param {Real} bladesAngle Sets the shape angle, in degrees.
/// @param {Bool} useZdepth Defines if the DOF will use a depth map.
/// @param {Pointer.Texture} zDepthTexture Depth map (Z-Buffer) texture. If undefined, it will use the depth buffer of the post-processing input surface (example: application_surface).
/// @param {Real} zDepthContrast zDepth texture contrast. Helps to better distinguish layers. 1 = Neutral. 100 = high contrast.
/// @param {Real} focusDistance Set the distance from the Camera to the focus point. (0 to 1).
/// @param {Real} focusRange Set the range, between the Camera sensor and the Camera lens. The larger the value is, the shallower the depth of field. (0 to 1).
/// @param {Real} focusNear Defines how much the focus should reach the near plane (0 to 1).
/// @param {Real} focusFar Defines how much the focus should reach the far plane (0 to 1).
/// @param {Real} resolution Sets the resolution of the Depth of Field, this changes the performance. 1 = full, 0.5 = falf.
/// @param {Bool} debug Allows you to see exactly where the Bokeh is blurring. Colors in cyan color are where the blur hits.
function FX_DepthOfField(_enabled, _radius=10, _intensity=1, _bladesAperture=6, _bladesAngle=0, _useZdepth=false, _zDepthTexture=undefined, _zDepthContrast=100, _focusDistance=0.2, _focusRange=0.02, _focusNear=1, _focusFar=1, _resolution=0.5, _debug=false) : __PPF_FXSuperClass() constructor {
	effectName = "depth_of_field";
	stackOrder = PPFX_STACK.DEPTH_OF_FIELD;
	
	enabled = _enabled;
	radius = _radius;
	intensity = _intensity;
	bladesAperture = _bladesAperture;
	bladesAngle = _bladesAngle;
	useZdepth = _useZdepth;
	zDepthTexture = _zDepthTexture;
	zDepthContrast = _zDepthContrast;
	focusDistance = _focusDistance;
	focusRange = _focusRange;
	focusNear = _focusNear;
	focusFar = _focusFar;
	resolution = _resolution;
	debug = _debug;
	
	static u_cocFocusDistance = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_focusDistance");
	static u_cocFocusRange = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_focusRange");
	static u_cocFocusNear = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_focusNear");
	static u_cocFocusFar = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_focusFar");
	static u_cocZDepthContrast = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_zDepthContrast");
	static u_d_lensDistortionEnable = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_lensDistortionEnable");
	static u_d_lensDistortionAmount = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_lensDistortionAmount");
	
	static u_texelSize = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_texelSize");
	static u_bokehRadius = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_bokehRadius");
	static u_bokehIntensity = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_bokehIntensity");
	static u_zDepthTexture = shader_get_sampler_index(__ppf_shRenderDOFBokeh, "u_zDepthTexture");
	static u_bokehBladesAperture = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_bokehBladesAperture");
	static u_bokehBladesAngle = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_bokehBladesAngle");
	static u_debug = shader_get_uniform(__ppf_shRenderDOFBokeh, "u_debug");
	
	static u_dsBox13TexelSize = shader_get_uniform(__ppf_shBlurBox13, "u_texelSize");
	static u_usTentTexelSize = shader_get_uniform(__ppf_shBlurTent9, "u_texelSize");
	
	// data
	dofPreFilterSurface = -1;
	dofBokehSurf = -1;
	dofPostFilterSurf = -1;
	oldDofResolution = 0;
	whitePixelTexture = __ppfxGlobal.textureWhitePixel;
	canRender = true;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || radius <= 0) {
			if (canRender) {
				canRender = false;
				Clean();
			}
			exit;
		}
		canRender = true;
		
		// settings
		var _source = _renderer.__stackSurfaces[_renderer.__stackIndex],
			_passSource = _source,
			_surfFormat = _renderer.__surfaceFormat,
			_moreSamples = false,
			_res = clamp(resolution, 0.1, 1),
			_ww = _surfaceWidth,
			_hh = _surfaceHeight;
		
		if (oldDofResolution != _res) {
			oldDofResolution = _res;
			Clean();
		}
		_moreSamples = !useZdepth;
		gpu_push_state();
		gpu_set_tex_filter(true);
		gpu_set_texrepeat(false);
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha); // used by all below
		
		// resolution
		_ww = _surfaceWidth * _res;
		_hh = _surfaceHeight * _res;
		_ww -= frac(_ww);
		_hh -= frac(_hh);
		
		// pre filter
		if (_moreSamples) {
			if (!surface_exists(dofPreFilterSurface)) dofPreFilterSurface = surface_create(_ww, _hh, _surfFormat);
			surface_set_target(dofPreFilterSurface);
				shader_set(__ppf_shBlurBox13);
				draw_clear_alpha(c_black, 0);
				shader_set_uniform_f(u_dsBox13TexelSize, 1/_ww, 1/_hh);
				draw_surface_stretched(_source, 0, 0, _ww, _hh);
				shader_reset();
			surface_reset_target();
			_passSource = dofPreFilterSurface; // set source to pre filter pass
			
		}
		
		// bokeh (surface_blit)
		if (!surface_exists(dofBokehSurf)) {
			dofBokehSurf = surface_create(_ww, _hh, _surfFormat);
		}
		surface_set_target(dofBokehSurf); // destination
			draw_clear_alpha(c_black, 0);
			shader_set(__ppf_shRenderDOFBokeh);
			shader_set_uniform_f(u_texelSize, 1/_ww, 1/_hh);
			shader_set_uniform_f(u_cocFocusDistance, focusDistance);
			shader_set_uniform_f(u_cocFocusRange, 1-focusRange);
			shader_set_uniform_f(u_cocFocusNear, focusNear);
			shader_set_uniform_f(u_cocFocusFar, focusFar);
			shader_set_uniform_f(u_cocZDepthContrast,  max(zDepthContrast, 1));
			var _lensEffect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
			if (_lensEffect != undefined) {
				shader_set_uniform_f(u_d_lensDistortionEnable, _lensEffect.enabled);
				shader_set_uniform_f(u_d_lensDistortionAmount, _lensEffect.amount);
			}
			shader_set_uniform_f(u_bokehRadius, radius);
			shader_set_uniform_f(u_bokehIntensity,  intensity*64);
			shader_set_uniform_f(u_bokehBladesAperture, max(3, bladesAperture));
			shader_set_uniform_f(u_bokehBladesAngle, degtorad(bladesAngle));
			shader_set_uniform_f(u_debug, debug);
			// send depth buffer, or a white pixel, if not defined
			if (useZdepth) {
				gpu_set_tex_filter_ext(u_zDepthTexture, false);
				if (zDepthTexture != undefined) {
					texture_set_stage(u_zDepthTexture, zDepthTexture);
				} else {
					texture_set_stage(u_zDepthTexture, surface_get_texture_depth(_renderer.__stackSurfaces[0]));
				}
			} else {
				texture_set_stage(u_zDepthTexture, whitePixelTexture);
			}
			draw_surface_stretched(_passSource, 0, 0, _ww, _hh); // source 
			shader_reset();
		surface_reset_target();
		_passSource = dofBokehSurf; // set source to bokeh pass
		
		// post filter (surface_blit)
		if (_moreSamples) {
			_ww /= 2;
			_hh /= 2;
			_ww -= frac(_ww);
			_hh -= frac(_hh);
			if (!surface_exists(dofPostFilterSurf)) dofPostFilterSurf = surface_create(_ww, _hh, _surfFormat);
			surface_set_target(dofPostFilterSurf); // destination
				draw_clear_alpha(c_black, 0);
				shader_set(__ppf_shBlurTent9);
				shader_set_uniform_f(u_usTentTexelSize, 1/_ww, 1/_hh);
				draw_surface_stretched(_passSource, 0, 0, _ww, _hh); // source
				shader_reset();
			surface_reset_target();
			_passSource = dofPostFilterSurf; // set source to post filter pass
		}
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			// TODO: < draw original image  here >
			// bokeh TODO: with alpha on non-blurred areas
			draw_surface_stretched(_passSource, 0, 0, _surfaceWidth, _surfaceHeight);
		surface_reset_target();
		
		gpu_pop_state();
	}
	
	static Clean = function() {
		__ppf_surface_delete(dofPreFilterSurface);
		__ppf_surface_delete(dofBokehSurf);
		__ppf_surface_delete(dofPostFilterSurf);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, radius, intensity, bladesAperture, bladesAngle, useZdepth, zDepthTexture, zDepthContrast, focusDistance, focusRange, focusNear, focusFar, resolution, debug],
		};
	}
}

#endregion

#region Lens Flares [WIP]
/*
/// @desc [Experimental] Lens Flares + Dirt Lens effect
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Aaaa
function FX_LensFlares(enabled, intensity=1) : __PPF_FXSuperClass() constructor {
	effectName = "lens_flares";
	stackOrder = PPFX_STACK.LENS_FLARES;
	
	enabled = enabled;
	intensity = intensity;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled) exit;
		
		// render
		_renderer.__defineStackSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			// the color is temporary
			draw_surface_stretched_ext(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight, c_red, 1);
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity],
		};
	}
}
*/
#endregion

#region Chromatic Aberration

/// @desc It mimics the color distortion that a real-world camera produces when its lens fails to join all colors to the same point;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity How much the channels are distorted. 0 to 50 recommended.
/// @param {Real} angle The chromatic angle. Default it 35.
/// @param {bool} inner Defines how much the chromatic will be applied only to the edges, or entirely. 0 to 1. Where 0 = no certer distortion.
/// @param {Real} centerRadius How much the effect is blended with the center. 0 to 3 recommended.
/// @param {Bool} blurEnable Defines whether to blur the chromatic effect.
/// @param {Pointer.Texture} prismaLUTtexture The spectral LUT texture, used to define the spectral colors.
/// Texture should be 8x3, with RGB channels horizontally. Use sprite_get_texture() or surface_get_texture().
function FX_ChromaticAberration(_enabled, _intensity=1, _angle=35, _inner=1, _centerRadius=0, _blurEnable=false, _prismaLUTtexture=undefined) : __PPF_FXSuperClass() constructor {
	effectName = "chromatic_aberration";
	stackOrder = PPFX_STACK.CHROMATIC_ABERRATION;
	
	enabled = _enabled;
	intensity = _intensity;
	angle = _angle;
	inner = _inner;
	centerRadius = _centerRadius;
	blurEnable = _blurEnable;
	prismaLutTexture = _prismaLUTtexture ?? __ppfxGlobal.textureChromaberPrismaLut;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderChromAber, "u_resolution");
	static u_time = shader_get_uniform(__ppf_shRenderChromAber, "u_time");
	static u_intensity = shader_get_uniform(__ppf_shRenderChromAber, "u_intensity");
	static u_dirVector = shader_get_uniform(__ppf_shRenderChromAber, "u_dirVector");
	static u_inner = shader_get_uniform(__ppf_shRenderChromAber, "u_inner");
	static u_centerRadius = shader_get_uniform(__ppf_shRenderChromAber, "u_centerRadius");
	static u_blurEnable = shader_get_uniform(__ppf_shRenderChromAber, "u_blurEnable");
	static u_prismaLUTtexture = shader_get_sampler_index(__ppf_shRenderChromAber, "u_prismaLUTtexture");
	static u_prismaLutUVs = shader_get_uniform(__ppf_shRenderChromAber, "u_prismaLutUVs");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(__ppf_shRenderChromAber);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			shader_set_uniform_f(u_intensity, intensity*0.01);
			shader_set_uniform_f(u_dirVector, dcos(angle), dsin(angle));
			shader_set_uniform_f(u_inner, inner);
			shader_set_uniform_f(u_centerRadius, max(centerRadius, PPFX_CFG_EPSILON));
			shader_set_uniform_f(u_blurEnable, blurEnable);
			texture_set_stage(u_prismaLUTtexture, prismaLutTexture);
			gpu_set_tex_filter_ext(u_prismaLUTtexture, false);
			gpu_set_tex_repeat_ext(u_prismaLUTtexture, false);
			gpu_set_tex_repeat(false);
			var _prismaUVs = texture_get_uvs(prismaLutTexture);
			shader_set_uniform_f(u_prismaLutUVs, _prismaUVs[0], _prismaUVs[1], _prismaUVs[2], _prismaUVs[3]);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, angle, inner, centerRadius, blurEnable, ["texture", prismaLutTexture]],
		};
	}
}

#endregion

#region VHS

/// @desc VHS (80s decade) effect simulation.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} chromaticAberration Sets the amount of chromatic aberration to use. 0 to 10 recommended.
/// @param {Real} scanAberration Sets the amount of chromatic aberration to use on scan lines. 0 to 10 recommended.
/// @param {Real} grainIntensity Sets the amount of granular. 0 to 1.
/// @param {Real} grainHeight Sets the height of a granular bar. 1 to 100 recommended. Low values make the bar thinner.
/// @param {Real} grainFade Creates a gradient effect to smoothly fade the grain to the bottom. 0 to 1.
/// @param {Real} grainAmount Defines the number of repetitions of the grain bars. 1 to 100 recommended.
/// @param {Real} grainSpeed Defines the grain movement speed. 0 to 1 recommended.
/// @param {Real} grainInterval Allows smoothing between grain bar variation and more spread. 0 to 1.
/// @param {Real} scanSpeed Sets the speed at which scan glitch move. 0 to 10 recommended.
/// @param {Real} scanSize Set scan glitch size. 0 to 1.
/// @param {Real} scanOffset Set scan glitch offset, which is how much it will move horizontally. 0 to 1.
/// @param {Real} hScanOffset Sets how much the horizontal fixed scan will change sporadically. 0 to 1.
/// @param {Real} flickeringIntensity Sets the intensity of the flickering/blinking effect. 0 to 1.
/// @param {Real} flickeringSpeed Sets the flickering animation speed. 0 to 10.0 recommended.
/// @param {Real} wiggleAmplitude Defines how much the image should shake vertically. 0 to 1.
function FX_VHS(_enabled, _chromaticAberration=0.15, _scanAberration=0.25, _grainIntensity=0.08, _grainHeight=2, _grainFade=0.7, _grainAmount=4, _grainSpeed=0.2, _grainInterval=0.2, _scanSpeed=1, _scanSize=0.08, _scanOffset=0.05, _hScanOffset=0.001, _flickeringIntensity=0.06, _flickeringSpeed=1, _wiggleAmplitude=0.001) : __PPF_FXSuperClass() constructor {
	effectName = "vhs";
	stackOrder = PPFX_STACK.VHS;
	
	enabled = _enabled;
	chromaticAberration = _chromaticAberration;
	scanAberration = _scanAberration;
	grainIntensity = _grainIntensity;
	grainHeight = _grainHeight;
	grainFade = _grainFade;
	grainAmount = _grainAmount;
	grainSpeed = _grainSpeed;
	grainInterval = _grainInterval;
	scanSpeed = _scanSpeed;
	scanSize = _scanSize;
	scanOffset = _scanOffset;
	hScanOffset = _hScanOffset;
	flickeringIntensity = _flickeringIntensity;
	flickeringSpeed = _flickeringSpeed;
	wiggleAmplitude = _wiggleAmplitude;
	
	static uniResolution = shader_get_uniform(__ppf_shRenderVHS, "u_resolution");
	static u_time = shader_get_uniform(__ppf_shRenderVHS, "u_time");
	static u_chromaticAberration = shader_get_uniform(__ppf_shRenderVHS, "u_chromaticAberration");
	static u_scanAberration = shader_get_uniform(__ppf_shRenderVHS, "u_scanAberration");
	static u_grainIntensity = shader_get_uniform(__ppf_shRenderVHS, "u_grainIntensity");
	static u_grainHeight = shader_get_uniform(__ppf_shRenderVHS, "u_grainHeight");
	static u_grainFade = shader_get_uniform(__ppf_shRenderVHS, "u_grainFade");
	static u_grainAmount = shader_get_uniform(__ppf_shRenderVHS, "u_grainAmount");
	static u_grainSpeed = shader_get_uniform(__ppf_shRenderVHS, "u_grainSpeed");
	static u_grainInterval = shader_get_uniform(__ppf_shRenderVHS, "u_grainInterval");
	static u_scanSpeed = shader_get_uniform(__ppf_shRenderVHS, "u_scanSpeed");
	static u_scanSize = shader_get_uniform(__ppf_shRenderVHS, "u_scanSize");
	static u_scanOffset = shader_get_uniform(__ppf_shRenderVHS, "u_scanOffset");
	static u_hScanOffset = shader_get_uniform(__ppf_shRenderVHS, "u_hScanOffset");
	static u_flickeringIntensity = shader_get_uniform(__ppf_shRenderVHS, "u_flickeringIntensity");
	static u_flickeringSpeed = shader_get_uniform(__ppf_shRenderVHS, "u_flickeringSpeed");
	static u_wiggleAmplitude = shader_get_uniform(__ppf_shRenderVHS, "u_wiggleAmplitude");
	// dependencies
	static u_d_lensDistortionEnable = shader_get_uniform(__ppf_shRenderVHS, "u_lensDistortionEnable");
	static u_d_lensDistortionAmount = shader_get_uniform(__ppf_shRenderVHS, "u_lensDistortionAmount");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_tex_repeat(true);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			shader_set(__ppf_shRenderVHS);
			shader_set_uniform_f(uniResolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			shader_set_uniform_f(u_chromaticAberration, chromaticAberration);
			shader_set_uniform_f(u_scanAberration, scanAberration);
			shader_set_uniform_f(u_grainIntensity, grainIntensity);
			shader_set_uniform_f(u_grainHeight, grainHeight);
			shader_set_uniform_f(u_grainFade, grainFade);
			shader_set_uniform_f(u_grainAmount, grainAmount);
			shader_set_uniform_f(u_grainSpeed, grainSpeed);
			shader_set_uniform_f(u_grainInterval, grainInterval);
			shader_set_uniform_f(u_scanSpeed, scanSpeed);
			shader_set_uniform_f(u_scanSize, scanSize);
			shader_set_uniform_f(u_scanOffset, scanOffset);
			shader_set_uniform_f(u_hScanOffset, hScanOffset);
			shader_set_uniform_f(u_flickeringIntensity, flickeringIntensity);
			shader_set_uniform_f(u_flickeringSpeed, flickeringSpeed);
			shader_set_uniform_f(u_wiggleAmplitude, wiggleAmplitude);
			var _lensEffect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
			if (_lensEffect != undefined) {
				shader_set_uniform_f(u_d_lensDistortionEnable, _lensEffect.enabled);
				shader_set_uniform_f(u_d_lensDistortionAmount, _lensEffect.amount);
			}
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, chromaticAberration, scanAberration, grainIntensity, grainHeight, grainFade, grainAmount, grainSpeed, grainInterval, scanSpeed, scanSize, scanOffset, hScanOffset, flickeringIntensity, flickeringSpeed, wiggleAmplitude],
		};
	}
}

#endregion

#region ASCII

/// @desc Transform pixel grid into texture frames.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity
/// @param {Real} saturation
/// @param {Real} mix
/// @param {Real} pixelMix
/// @param {Real} scale
/// @param {Id.Color,Real} color
/// @param {Id.Texture} texture The characters texture. It must be horizontal sequential. WARNING: Pay attention if the texture page has "automatically crop" option enabled, as this changes the size of the sprite. Painting the transparent area black prevents this.
function FX_ASCII(_enabled, _intensity=1, _saturation=1, _mix=0, _pixelMix=1, _scale=1, _color=c_white, _texture=undefined, _framesAmount=8, _gridCellWidth=16, _gridCellHeight=16) : __PPF_FXSuperClass() constructor {
	effectName = "ascii";
	stackOrder = PPFX_STACK.ASCII;
	
	enabled = _enabled;
	intensity = _intensity;
	saturation = _saturation;
	mix = _mix;
	pixelMix = _pixelMix;
	scale = _scale;
	color = make_color_ppfx(_color);
	texture = _texture ?? __ppfxGlobal.textureASCII;
	framesAmount = _framesAmount;
	gridCellWidth = _gridCellWidth;
	gridCellHeight = _gridCellHeight;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderASCII, "u_resolution");
	static u_charsTextureUVs = shader_get_uniform(__ppf_shRenderASCII, "u_charsTextureUVs");
	static u_charsTexture = shader_get_sampler_index(__ppf_shRenderASCII, "u_charsTexture");
	static u_framesAmount = shader_get_uniform(__ppf_shRenderASCII, "u_framesAmount");
	static u_intensity = shader_get_uniform(__ppf_shRenderASCII, "u_intensity");
	static u_saturation = shader_get_uniform(__ppf_shRenderASCII, "u_saturation");
	static u_mix = shader_get_uniform(__ppf_shRenderASCII, "u_mix");
	static u_pixelMix = shader_get_uniform(__ppf_shRenderASCII, "u_pixelMix");
	static u_scale = shader_get_uniform(__ppf_shRenderASCII, "u_scale");
	static u_color = shader_get_uniform(__ppf_shRenderASCII, "u_color");
	static u_gridSize = shader_get_uniform(__ppf_shRenderASCII, "u_gridSize");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderASCII);
			shader_set_uniform_f(u_intensity, intensity);
			shader_set_uniform_f(u_saturation, saturation);
			shader_set_uniform_f(u_mix, mix);
			shader_set_uniform_f(u_pixelMix, pixelMix);
			shader_set_uniform_f(u_scale, max(scale, PPFX_CFG_EPSILON));
			shader_set_uniform_f_array(u_color, color);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_gridSize, gridCellWidth, gridCellHeight);
			if (texture != undefined) {
				texture_set_stage(u_charsTexture, texture);
				var _UVs = texture_get_uvs(texture);
				shader_set_uniform_f(u_charsTextureUVs, _UVs[0], _UVs[1], _UVs[2], _UVs[3]);
			}
			shader_set_uniform_f(u_framesAmount, framesAmount);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, saturation, mix, pixelMix, scale, ["color", color], texture, framesAmount, gridCellWidth, gridCellHeight],
		};
	}
}

#endregion

#region Glitch [WIP]

/// @desc Super cool Glitch effect. THIS IS EXPERIMENTAL!!! It may change in any update. This is just a preview.
function FX_Glitch(_enabled, _intensity=1) : __PPF_FXSuperClass() constructor {
	effectName = "glitch";
	stackOrder = PPFX_STACK.GLITCH;
	
	enabled = _enabled;
	intensity = 1;
	shakeOffset = 0;
	shakeSpeed = 1;
	shuffleOffset = 0.01;
	shuffleSpeed = 10;
	shuffleAmount = [0.8, 0.8];
	shuffleScale1 = [0.995, 0.995];
	shuffleScale2 = [0.99, 0.99];
	shufflePower = 1;
	sineOffset = 0.0;
	sineSpeed = 5;
	sineWiggleIntensity = 0.05;
	sineWiggleInterval = 0.9;
	interlacingOffset = 5.8;
	stripOffset = [0, 0]; // [0.05; 0.08];
	stripSpeed = 0.5;
	stripAmount = 0.1;
	stripScale = 0.9;
	chromaShiftOffset = 0.0;
	chromaShiftNoisy = 0.0;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderGlitch, "u_resolution");
	static u_texelSize = shader_get_uniform(__ppf_shRenderGlitch, "u_texelSize");
	static u_time = shader_get_uniform(__ppf_shRenderGlitch, "u_time");
	
	static u_glitchIntensity = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchIntensity");
	static u_glitchShakeOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShakeOffset");
	static u_glitchShakeSpeed = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShakeSpeed");
	static u_glitchShuffleOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShuffleOffset");
	static u_glitchShuffleSpeed = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShuffleSpeed");
	static u_glitchShuffleAmount = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShuffleAmount");
	static u_glitchShuffle1Scale = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShuffle1Scale");
	static u_glitchShuffle2Scale = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShuffle2Scale");
	static u_glitchShufflePower = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchShufflePower");
	static u_glitchSineOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchSineOffset");
	static u_glitchSineSpeed = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchSineSpeed");
	static u_glitchSineWiggleIntensity = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchSineWiggleIntensity");
	static u_glitchSineWiggleInterval = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchSineWiggleInterval");
	static u_glitchInterlacingOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchInterlacingOffset");
	static u_glitchStripOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchStripOffset");
	static u_glitchStripSpeed = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchStripSpeed");
	static u_glitchStripAmount = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchStripAmount");
	static u_glitchStripScale = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchStripScale");
	static u_glitchChromaShiftOffset = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchChromaShiftOffset");
	static u_glitchChromaShiftNoise = shader_get_uniform(__ppf_shRenderGlitch, "u_glitchChromaShiftNoise");
	
	// dependencies
	static uni_d_lens_distortion_enable = shader_get_uniform(__ppf_shRenderGlitch, "u_lensDistortionEnable");
	static uni_d_lens_distortion_amount = shader_get_uniform(__ppf_shRenderGlitch, "u_lensDistortionAmount");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_tex_repeat(true);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderGlitch);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_texelSize, 1/_surfaceWidth, 1/_surfaceHeight);
			shader_set_uniform_f(u_time, _time);
			
			shader_set_uniform_f(u_glitchIntensity, intensity);
			shader_set_uniform_f(u_glitchShakeOffset, shakeOffset);
			shader_set_uniform_f(u_glitchShakeSpeed, shakeSpeed);
			shader_set_uniform_f(u_glitchShuffleOffset, shuffleOffset);
			shader_set_uniform_f(u_glitchShuffleSpeed, shuffleSpeed);
			shader_set_uniform_f_array(u_glitchShuffleAmount, shuffleAmount);
			shader_set_uniform_f_array(u_glitchShuffle1Scale, shuffleScale1);
			shader_set_uniform_f_array(u_glitchShuffle2Scale, shuffleScale2);
			shader_set_uniform_f(u_glitchShufflePower, shufflePower);
			shader_set_uniform_f(u_glitchSineOffset, sineOffset);
			shader_set_uniform_f(u_glitchSineSpeed, sineSpeed);
			shader_set_uniform_f(u_glitchSineWiggleIntensity, sineWiggleIntensity);
			shader_set_uniform_f(u_glitchSineWiggleInterval, sineWiggleInterval);
			shader_set_uniform_f(u_glitchInterlacingOffset, interlacingOffset);
			shader_set_uniform_f_array(u_glitchStripOffset, stripOffset);
			shader_set_uniform_f(u_glitchStripSpeed, stripSpeed);
			shader_set_uniform_f(u_glitchStripAmount, stripAmount);
			shader_set_uniform_f(u_glitchStripScale, stripScale);
			shader_set_uniform_f(u_glitchChromaShiftOffset, chromaShiftOffset);
			shader_set_uniform_f(u_glitchChromaShiftNoise, chromaShiftNoisy);
			
			//var _lens_effect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
			//if (_lens_effect != undefined) {
			//	shader_set_uniform_f(uni_d_lens_distortion_enable, _lens_effect.enabled);
			//	shader_set_uniform_f(uni_d_lens_distortion_amount, _lens_effect.amount);
			//}
			
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled],
		};
	}
}

#endregion

#region Gaussian Blur

/// @desc Gaussian Blur effect.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount The amout to blur. 0 to 1.
/// @param {Real} maskPower Defines the radial center area of the mask, based on position. 0 to 15 recommended.
/// @param {Real} maskScale Defines the radial mask scale. 0 to 3 recommended.
/// @param {Real} maskSmoothness Defines the mask border smoothness. 0 to 1.
/// @param {Real} resolution How much to resolution image. Higher numbers mean higher performance at the cost of sharpness. 1 = full, 0.5 = falf.
function FX_GaussianBlur(_enabled, _amount=0.3, _maskPower=0, _maskScale=1, _maskSmoothness=1, _resolution=0.5) : __PPF_FXSuperClass() constructor {
	effectName = "gaussian_blur";
	stackOrder = PPFX_STACK.BLUR_GAUSSIAN;
	
	enabled = _enabled;
	amount = _amount;
	maskPower = _maskPower;
	maskScale = _maskScale;
	maskSmoothness = _maskSmoothness;
	resolution = _resolution;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderGaussianBlur, "u_resolution");
	static u_gaussianAmount = shader_get_uniform(__ppf_shRenderGaussianBlur, "u_gaussianAmount");
	static u_gaussianDirection = shader_get_uniform(__ppf_shRenderGaussianBlur, "u_gaussianDirection");
	static u_maskPower = shader_get_uniform(__ppf_shGenericMask, "u_maskPower");
	static u_maskScale = shader_get_uniform(__ppf_shGenericMask, "u_maskScale");
	static u_maskSmoothness = shader_get_uniform(__ppf_shGenericMask, "u_maskSmoothness");
	static u_maskTexture = shader_get_sampler_index(__ppf_shGenericMask, "u_maskTexture");
	static u_dsBox4TexelSize = shader_get_uniform(__ppf_shBlurBox4, "u_texelSize");
	
	blurFinalSurface = -1;
	blurPingSurface = -1;
	blurPongSurface = -1;
	oldResolution = 0;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || amount <= 0) exit;
		
		// settings
		var _source = _renderer.__stackSurfaces[_renderer.__stackIndex],
		_res = clamp(resolution, 0.1, 1),
		_ww = _surfaceWidth * _res,
		_hh = _surfaceHeight * _res;
		_ww -= frac(_ww);
		_hh -= frac(_hh);
		
		gpu_push_state();
		gpu_set_tex_filter(true);
		gpu_set_tex_repeat(false);
		
		if (oldResolution != _res) {
			oldResolution = _res;
			Clean();
		}
		if (!surface_exists(blurPingSurface)) {
			blurPingSurface = surface_create(_ww, _hh);
			blurPongSurface = surface_create(_ww, _hh);
			blurFinalSurface = surface_create(_ww/2, _hh/2);
		}
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		
		// gaussian pass
		shader_set(__ppf_shRenderGaussianBlur);
			shader_set_uniform_f(u_resolution, _ww, _hh);
			shader_set_uniform_f(u_gaussianAmount, amount * 0.01);
			
			// pass 1 (h)
			shader_set_uniform_f(u_gaussianDirection, 1, 0);
			surface_set_target(blurPingSurface);
				draw_clear_alpha(c_black, 0);
				draw_surface_stretched(_source, 0, 0, _ww, _hh);
			surface_reset_target();
			
			// pass 2 (v)
			shader_set_uniform_f(u_gaussianDirection, 0, 1);
			surface_set_target(blurPongSurface);
				draw_clear_alpha(c_black, 0);
				draw_surface_stretched(blurPingSurface, 0, 0, _ww, _hh);
			surface_reset_target();
		shader_reset();
		
		// pass 3 (post filter)
		surface_set_target(blurFinalSurface);
			draw_clear_alpha(c_black, 0);
			shader_set(__ppf_shBlurBox4);
			shader_set_uniform_f(u_dsBox4TexelSize, (1/_ww)/2, (1/_hh)/2);
			draw_surface_stretched(blurPongSurface, 0, 0, surface_get_width(blurFinalSurface), surface_get_height(blurFinalSurface));
			shader_reset();
		surface_reset_target();
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			shader_set(__ppf_shGenericMask);
			shader_set_uniform_f(u_maskPower, maskPower);
			shader_set_uniform_f(u_maskScale, maskScale);
			shader_set_uniform_f(u_maskSmoothness, maskSmoothness);
			texture_set_stage(u_maskTexture, surface_get_texture(blurFinalSurface));
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
		surface_reset_target();
		
		gpu_pop_state();
	}
	
	static Clean = function() {
		if (surface_exists(blurFinalSurface)) surface_free(blurFinalSurface);
		if (surface_exists(blurPingSurface)) surface_free(blurPingSurface);
		if (surface_exists(blurPongSurface)) surface_free(blurPongSurface);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, maskPower, maskScale, maskSmoothness, resolution]
		};
	}
}

#endregion

#region Kawase Blur

/// @desc Blur effect similar to Gaussian Blur, but with better performance on low-end devices.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount The amount to blur. This parameter is currently a multiplication with "iterations". 0 to 1.
/// @param {Real} maskpower Defines the radial center area of the mask, based on position. 0 to 15 recommended.
/// @param {Real} maskScale Defines the radial mask scale. 0 to 3 recommended.
/// @param {Real} maskSmoothness Defines the mask border smoothness. 0 to 1.
/// @param {Real} resolution How much to downscale image. Higher numbers mean higher quality. 1 = full, 0.5 = falf.
/// @param {Real} iterations The amount of blur passes. Larger numbers require more processing. 8 recommended.
function FX_KawaseBlur(_enabled, _amount=0.3, _maskPower=0, _maskScale=1, _maskSmoothness=1, _resolution=1, _iterations=8) : __PPF_FXSuperClass() constructor {
	effectName = "kawase_blur";
	stackOrder = PPFX_STACK.BLUR_KAWASE;
	
	enabled = _enabled;
	amount = _amount;
	maskPower = _maskPower;
	maskScale = _maskScale;
	maskSmoothness = _maskSmoothness;
	resolution = _resolution;
	iterations = _iterations;
	
	static u_maskPower = shader_get_uniform(__ppf_shGenericMask, "u_maskPower");
	static u_maskScale = shader_get_uniform(__ppf_shGenericMask, "u_maskScale");
	static u_maskSmoothness = shader_get_uniform(__ppf_shGenericMask, "u_maskSmoothness");
	static u_maskTexture = shader_get_sampler_index(__ppf_shGenericMask, "u_maskTexture");
	static u_dsBox4TexelSize = shader_get_uniform(__ppf_shBlurBox4, "u_texelSize");
	static u_dsBox13TexelSize = shader_get_uniform(__ppf_shBlurBox13, "u_texelSize");
	static u_usTentTexelSize = shader_get_uniform(__ppf_shBlurTent9, "u_texelSize");
	
	blurSurfaces = array_create(16, -1);
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || amount <= 0) exit;
		
		// settings
		var _ds = clamp(resolution, 0.1, 1),
		_iterations = clamp(iterations * amount, 1, 8),
		_ww = _surfaceWidth * _ds,
		_hh = _surfaceHeight * _ds,
		
		_source = _renderer.__stackSurfaces[_renderer.__stackIndex],
		_currentDestination = _source,
		_currentSource = _source;
		
		gpu_push_state();
		gpu_set_tex_filter(true);
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		
		// downsampling
		shader_set(__ppf_shBlurBox13);
		var i = 0;
		repeat(_iterations) {
			_ww /= 2;
			_hh /= 2;
			_ww -= frac(_ww);
			_hh -= frac(_hh);
			if (_ww < 2 || _hh < 2) break;
			if (!surface_exists(blurSurfaces[i])) {
				blurSurfaces[i] = surface_create(_ww, _hh);
			}
			_currentDestination = blurSurfaces[i];
			
			// blit
			surface_set_target(_currentDestination);
				draw_clear_alpha(c_black, 0);
				shader_set_uniform_f(u_dsBox13TexelSize, 1/_ww, 1/_hh);
				draw_surface_stretched(_currentSource, 0, 0, surface_get_width(_currentDestination), surface_get_height(_currentDestination));
			surface_reset_target();
					
			_currentSource = _currentDestination;
			++i;
		}
		shader_reset();
		
		// upsampling
		shader_set(__ppf_shBlurTent9);
		for(i -= 2; i >= 0; i--) {
			_currentDestination = blurSurfaces[i];
					
			// blit
			_ww = surface_get_width(_currentDestination);
			_hh = surface_get_height(_currentDestination);
			surface_set_target(_currentDestination);
				draw_clear_alpha(c_black, 0);
				shader_set_uniform_f(u_usTentTexelSize, 1/_ww, 1/_hh);
				draw_surface_stretched(_currentSource, 0, 0, _ww, _hh);
			surface_reset_target();
					
			_currentSource = _currentDestination;
		}
		shader_reset();
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			shader_set(__ppf_shGenericMask);
			shader_set_uniform_f(u_maskPower, maskPower);
			shader_set_uniform_f(u_maskScale, maskScale);
			shader_set_uniform_f(u_maskSmoothness, maskSmoothness);
			texture_set_stage(u_maskTexture, surface_get_texture(_currentDestination));
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
		surface_reset_target();
		
		gpu_pop_state();
	}
	
	static Clean = function() {
		__ppf_surface_delete_array(blurSurfaces);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, maskPower, maskScale, maskSmoothness, resolution, iterations],
		};
	}
}

#endregion

#region Palette Swap

/// @desc Replace all colors in the image with colors from a palette, based on luminosity. The palette must be horizontal. The pixels start to be read from left to right (use the Flip parameter to invert the luminance).
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} row Vertical position on palette sprite, to use pixels in sequence. Default is 0 or 1.
/// @param {Bool} flip Sets whether to invert luminosity. Default is false;
/// @param {Pointer.Texture} texture The palette LUT texture. Use sprite_get_texture() or surface_get_texture().
/// @param {Real} paletteHeight Palette sprite height (in pixels). A 3x1 palette sprite has 1 pixel height, for example.
/// @param {Real} threshold Set the level of brightness to filter out pixels under this level. 0 to 1. 0 means all light pixels (default).
/// @param {Real} smoothness How much smoothness to apply to the threshold (0 to 1).
/// @param {Bool} limitColors Defines whether you want to limit the number of colors in the image to the number of colors in the palette.
function FX_PaletteSwap(_enabled, _row=1, _flip=false, _texture=undefined, _paletteHeight=1, _threshold=0, _smoothness=0, _limitColors=true) : __PPF_FXSuperClass() constructor {
	effectName = "palette_swap";
	stackOrder = PPFX_STACK.PALETTE_SWAP;
	
	enabled = _enabled;
	row = _row;
	flip = _flip;
	texture = _texture ?? __ppfxGlobal.texturePalette;
	paletteHeight = _paletteHeight;
	threshold = _threshold;
	smoothness = _smoothness;
	limitColors = _limitColors;
	
	static u_row = shader_get_uniform(__ppf_shRenderPaletteSwap, "u_row");
	static u_threshold = shader_get_uniform(__ppf_shRenderPaletteSwap, "u_threshold");
	static u_flip = shader_get_uniform(__ppf_shRenderPaletteSwap, "u_flip");
	static u_smoothness = shader_get_uniform(__ppf_shRenderPaletteSwap, "u_smoothness");
	static u_paletteUVs = shader_get_uniform(__ppf_shRenderPaletteSwap, "u_paletteUVs");
	static u_paletteTexture = shader_get_sampler_index(__ppf_shRenderPaletteSwap, "u_paletteTexture");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || texture == undefined) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderPaletteSwap);
			shader_set_uniform_f(u_row, max(0, (row-1)/(paletteHeight-1)));
			shader_set_uniform_f(u_threshold, threshold);
			shader_set_uniform_f(u_flip, flip);
			shader_set_uniform_f(u_smoothness, smoothness);
			if (texture != undefined) {
				var _paletteUVs = texture_get_uvs(texture);
				shader_set_uniform_f(u_paletteUVs, _paletteUVs[0], _paletteUVs[1], _paletteUVs[2], _paletteUVs[3]);
				texture_set_stage(u_paletteTexture, texture);
			}
			gpu_set_tex_filter_ext(u_paletteTexture, !limitColors);
			if (gpu_get_tex_mip_enable()) gpu_set_tex_mip_enable_ext(u_paletteTexture, mip_off);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, row, flip, ["texture", texture], paletteHeight, threshold, smoothness, limitColors],
		};
	}
}

#endregion

#region HQ4x

/// @desc Pixel-art upscaling 4x filter.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} smoothness Edges smoothness.
/// @param {Real} sharpness Edges sharpness.
/// @param {Real} resolution Compensate for varying pixel sizes. 1 = full, 0.5 = falf.
function FX_HQ4x(_enabled, _smoothness=0.5, _sharpness=1, _resolution=1) : __PPF_FXSuperClass() constructor {
	effectName = "hq4x";
	stackOrder = PPFX_STACK.HQ4X;
	
	enabled = _enabled;
	smoothness = _smoothness;
	sharpness = _sharpness;
	resolution = _resolution;
	
	static u_texelSize = shader_get_uniform(__ppf_shRenderHQ4x, "u_texelSize");
	static u_smoothness = shader_get_uniform(__ppf_shRenderHQ4x, "u_smoothness");
	static u_sharpness = shader_get_uniform(__ppf_shRenderHQ4x, "u_sharpness");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderHQ4x);
			var _res = round(clamp(lerp(8, 1, resolution), 1, 8));
			shader_set_uniform_f(u_texelSize, 1/(_surfaceWidth/_res), 1/(_surfaceHeight/_res));
			shader_set_uniform_f(u_smoothness, smoothness);
			shader_set_uniform_f(u_sharpness, sharpness);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, smoothness, sharpness, resolution],
		};
	}
}

#endregion

#region FXAA

/// @desc Fast Approximate Anti-Aliasing is a screen-space anti-aliasing algorithm to remove sharp edges.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} strength Anti-aliasing strength.
function FX_FXAA(_enabled, _strength=2) : __PPF_FXSuperClass() constructor {
	effectName = "fxaa";
	stackOrder = PPFX_STACK.FXAA;
	
	enabled = _enabled;
	strength = _strength;
	
	static u_texelSize = shader_get_uniform(__ppf_shRenderFXAA, "u_texelSize");
	static u_strength = shader_get_uniform(__ppf_shRenderFXAA, "u_strength");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || strength <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderFXAA);
			shader_set_uniform_f(u_texelSize, 1/_surfaceWidth, 1/_surfaceHeight);
			shader_set_uniform_f(u_strength, strength);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, strength],
		};
	}
}

#endregion

#region Long Exposure

/// @desc Slow Motion effect, also known as "Long Exposure" in photography (or just Drunk vision).
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Sets the intensity level of the effect. 0.85 recommended.
/// @param {Real} iterations Sets the strength of the slow motion. This also sets the exposure of the lights. 0 - 10 recommended. Above 0, a new surface will be created for each iteration, so be careful with memory.
/// @param {Real} threshold Set the level of brightness to filter out pixels under this level. 0 means full brightness. Values above 1 are HDR.
/// @param {Real} lightsIntensity Sets the intensity of the lights (when threshold is greater than zero).
/// @param {Real} resolution Sets the resolution of the trails, this affects the performance. 1 is full resolution = more resources needed, but look better. 1 = full, 0.5 = falf.
/// @param {Bool} debug Lets you see where the threshold reaches.
/// @param {Real} sourceOffset Source stack offset. Indicates which stack the slow motion effect will use as a source to emit lightning. The default is 0, which is the Slow Motion stack. Note: the shift happens to the previous stack always, no matter if the value is negative or positive.
function FX_LongExposure(_enabled, _intensity=1, _iterations=0, _threshold=0, _lightsIntensity=1, _resolution=1, _debug=false, _sourceOffset=0) : __PPF_FXSuperClass() constructor {
	effectName = "long_exposure";
	stackOrder = PPFX_STACK.LONG_EXPOSURE;
	
	enabled = _enabled;
	threshold = _threshold;
	intensity = _intensity;
	iterations = _iterations;
	lightsIntensity = _lightsIntensity;
	resolution = _resolution;
	debug = _debug;
	sourceOffset = _sourceOffset;
	
	static u_lightsPreFilterThreshold = shader_get_uniform(__ppf_shRenderSlowMoThreshold, "u_threshold");
	static u_lightsIntensity = shader_get_uniform(__ppf_shRenderSlowMoLights, "u_lightsIntensity");
	static u_lightsTexture = shader_get_sampler_index(__ppf_shRenderSlowMoLights, "u_lightsTexture");
	
	lightsOnlySurf = -1;
	ghostSurf = -1;
	slowMotionSurfaces = [];
	oldIterations = 0;
	oldResolution = 0;
	canRender = true;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) {
			if (canRender) {
				canRender = false;
				Clean();
			}
			exit;
		}
		canRender = true;
		
		// Get source (from first/previous stack or threshold)
		var _source = _renderer.__stackSurfaces[_renderer.__stackIndex],
			_surfaceFormat = _renderer.__surfaceFormat,
			_res = clamp(resolution, 0.1, 1),
			_ww = _surfaceWidth * _res,
			_hh = _surfaceHeight * _res;
			_ww -= frac(_ww);
			_hh -= frac(_hh);
		
		if (iterations != oldIterations || resolution != oldResolution) {
			oldIterations = iterations;
			oldResolution = resolution;
			Clean(); // clean first
			slowMotionSurfaces = array_create(iterations, -1);
		}
		
		// Lights only (if threshold is above zero)
		if (threshold > 0) {
			if (!surface_exists(lightsOnlySurf)) {
				lightsOnlySurf = surface_create(_ww, _hh, _surfaceFormat);
			}
			var _previousSurf = _renderer.__stackGetSurfaceFromOffset(sourceOffset);
			surface_set_target(lightsOnlySurf); // destination
				shader_set(__ppf_shRenderSlowMoThreshold);
				shader_set_uniform_f(u_lightsPreFilterThreshold, threshold);
				draw_surface_stretched(_previousSurf, 0, 0, _ww, _hh);
				shader_reset();
			surface_reset_target();
			_source = lightsOnlySurf;
		}
		
		// Ghost surface
		if (!surface_exists(ghostSurf)) {
			ghostSurf = surface_create(_ww, _hh, _surfaceFormat);
			surface_set_target(ghostSurf);
			draw_surface_stretched(_source, 0, 0, _ww, _hh); // prevent first frame full-black
			surface_reset_target();
		}
		surface_set_target(ghostSurf);
			draw_surface_stretched_ext(_source, 0, 0, _ww, _hh, c_white, 1-clamp(intensity, 0, 0.9));
		surface_reset_target();
		
		// Burst ghosting based on iterations
		var _currentDestination = ghostSurf;
		if (iterations > 0) {
			var _currentSource = _currentDestination;
			var i = 0;
			repeat(iterations) {
				if (!surface_exists(slowMotionSurfaces[i])) {
					slowMotionSurfaces[i] = surface_create(_ww, _hh, _surfaceFormat);
					surface_set_target(slowMotionSurfaces[i]);
						draw_surface_stretched(_source, 0, 0, _ww, _hh); // prevent first frame full-black
					surface_reset_target();
				}
				_currentDestination = slowMotionSurfaces[i];
					surface_set_target(_currentDestination);
						draw_surface_stretched(_currentSource, 0, 0, _ww, _hh);
					surface_reset_target();
				_currentSource = _currentDestination;
				++i;
			}
		}
		var _slowMotionSurf = _currentDestination;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			if (threshold <= 0) {
				// draw full blurred slow motion
				draw_surface_stretched(_slowMotionSurf, 0, 0, _surfaceWidth, _surfaceHeight);
			} else {
				// draw blurred lights only
				shader_set(__ppf_shRenderSlowMoLights);
				texture_set_stage(u_lightsTexture, surface_get_texture(_slowMotionSurf));
				shader_set_uniform_f(u_lightsIntensity, lightsIntensity);
				var _surface = _renderer.__stackSurfaces[_renderer.__stackIndex-1];
				if (debug) _surface = _slowMotionSurf;
				draw_surface_stretched(_surface, 0, 0, _surfaceWidth, _surfaceHeight);
				shader_reset();
			}
			gpu_pop_state();
		surface_reset_target();
	}
	
	static Clean = function() {
		if (surface_exists(lightsOnlySurf)) surface_free(lightsOnlySurf);
		if (surface_exists(ghostSurf)) surface_free(ghostSurf);
		__ppf_surface_delete_array(slowMotionSurfaces);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, iterations, threshold, lightsIntensity, resolution, debug, sourceOffset],
		};
	}
}

#endregion

#region Motion Blur

/// @desc Simulates the blur that occurs in an image when a real-world camera films objects moving faster than the camera’s exposure time.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} radius The amount of blur. 0 to 10 recommended.
/// @param {Real} angle The angle to create fast movement effect.
/// @param {Array<Real>} center Focus position. An array with the normalized values (0 to 1), in this format: [x, y].
/// @param {Real} maskPower Defines the radial center area of the mask, based on position. 0 to 15 recommended.
/// @param {Real} maskScale Defines the radial mask scale. 0 to 3 recommended.
/// @param {Real} maskSmoothness Defines the mask border smoothness. 0 to 1.
function FX_MotionBlur(_enabled, _radius=0, _angle=0, _center=[0.5,0.5], _maskPower=0, _maskScale=1.2, _maskSmoothness=1) : __PPF_FXSuperClass() constructor {
	effectName = "motion_blur";
	stackOrder = PPFX_STACK.MOTION_BLUR;
	
	enabled = _enabled;
	radius = _radius;
	angle = _angle;
	center = _center;
	maskPower = _maskPower;
	maskScale = _maskScale;
	maskSmoothness = _maskSmoothness;
	
	static u_resolution = shader_get_uniform(__ppf_shRenderMotionBlur, "u_resolution");
	static u_vectorDir = shader_get_uniform(__ppf_shRenderMotionBlur, "u_vectorDir");
	static u_radius = shader_get_uniform(__ppf_shRenderMotionBlur, "u_radius");
	static u_center = shader_get_uniform(__ppf_shRenderMotionBlur, "u_center");
	static u_maskPower = shader_get_uniform(__ppf_shRenderMotionBlur, "u_maskPower");
	static u_maskScale = shader_get_uniform(__ppf_shRenderMotionBlur, "u_maskScale");
	static u_maskSmoothness = shader_get_uniform(__ppf_shRenderMotionBlur, "u_maskSmoothness");
	static u_noiseTexture = shader_get_sampler_index(__ppf_shRenderMotionBlur, "u_noiseTexture");
	static u_noiseSize = shader_get_uniform(__ppf_shRenderMotionBlur, "u_noiseSize");
	static u_noiseUVs = shader_get_uniform(__ppf_shRenderMotionBlur, "u_noiseUVs");
	
	noiseSprite = __ppf_sprNoiseBlue;
	noiseTexture = sprite_get_texture(noiseSprite, 0);
	noiseUVs = texture_get_uvs(noiseTexture);
	noiseWidth = sprite_get_width(noiseSprite);
	noiseHeight = sprite_get_height(noiseSprite);
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || radius <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderMotionBlur);
			shader_set_uniform_f(u_resolution, _surfaceWidth, _surfaceHeight);
			shader_set_uniform_f(u_vectorDir, dcos(angle), -dsin(angle));
			shader_set_uniform_f(u_radius, radius * 0.01);
			shader_set_uniform_f_array(u_center, center);
			shader_set_uniform_f(u_maskPower, maskPower);
			shader_set_uniform_f(u_maskScale, maskScale);
			shader_set_uniform_f(u_maskSmoothness, maskSmoothness);
			gpu_set_tex_repeat_ext(u_noiseTexture, true);
			shader_set_uniform_f(u_noiseUVs, noiseUVs[0], noiseUVs[1], noiseUVs[2], noiseUVs[3]);
			texture_set_stage(u_noiseTexture, noiseTexture);
			shader_set_uniform_f(u_noiseSize, noiseWidth, noiseHeight);
			
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, radius, angle, ["vec2", center], maskPower, maskScale, maskSmoothness],
		};
	}
}

#endregion

#region Radial Blur

/// @desc Blurred zoom effect to give the impression of speed;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} radius The amount of blur. 0 to 1 recommended.
/// @param {Real} inner How far the blur extends from the center.
/// @param {Array<Real>} center Focus position. An array with the normalized values (0 to 1), in this format: [x, y].
function FX_RadialBlur(_enabled, _radius=0.5, _inner=1.5, _center=[0.5,0.5]) : __PPF_FXSuperClass() constructor {
	effectName = "radial_blur";
	stackOrder = PPFX_STACK.BLUR_RADIAL;
	
	enabled = _enabled;
	radius = _radius;
	inner = _inner;
	center = _center;
	
	static u_radius = shader_get_uniform(__ppf_shRenderRadialBlur, "u_radius");
	static u_center = shader_get_uniform(__ppf_shRenderRadialBlur, "u_center");
	static u_inner = shader_get_uniform(__ppf_shRenderRadialBlur, "u_inner");
	static u_noiseTexture = shader_get_sampler_index(__ppf_shRenderRadialBlur, "u_noiseTexture");
	static u_noiseSize = shader_get_uniform(__ppf_shRenderRadialBlur, "u_noiseSize");
	static u_noiseUVs = shader_get_uniform(__ppf_shRenderRadialBlur, "u_noiseUVs");
	
	noiseSprite = __ppf_sprNoiseBlue;
	noiseTexture = sprite_get_texture(noiseSprite, 0);
	noiseWidth = sprite_get_width(noiseSprite);
	noiseHeight = sprite_get_height(noiseSprite);
	noiseUVs = sprite_get_uvs(noiseSprite, 0);
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || radius <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderRadialBlur);
			shader_set_uniform_f(u_radius, radius);
			shader_set_uniform_f_array(u_center, center);
			shader_set_uniform_f(u_inner, inner);
			gpu_set_tex_repeat_ext(u_noiseTexture, true);
			shader_set_uniform_f(u_noiseUVs, noiseUVs[0], noiseUVs[1], noiseUVs[2], noiseUVs[3]);
			texture_set_stage(u_noiseTexture, noiseTexture);
			shader_set_uniform_f(u_noiseSize, noiseWidth, noiseHeight);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, radius, inner, ["vec2", center]],
		};
	}
}

#endregion

#region Texture Overlay

/// @desc Texture to be drawn after one of the lastest rendered effects. It is drawn after the "Invert Colors" effect and before the "Lift, Gamma, Gain" effect
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Texture alpha. 0 to 1.
/// @param {Real} scale Texture scale. 0 to 2 recommended.
/// @param {Pointer.Texture} texture The texture to be used. Use sprite_get_texture() or surface_get_texture().
/// @param {real} blendmode Defines the way the texture will blend with everything below. 0 = normal, 1 = add, 2 = subtract, 3 - light
/// @param {Bool} canDistort If active, the texture will distort according to the lens distortion effect.
/// @param {Bool} tiled If active, the texture will repeat in all directions.
function FX_TextureOverlay(_enabled, _intensity=1, _scale=1, _texture=undefined, _blendmode=0, _canDistort=false, _tiled=false) : __PPF_FXSuperClass() constructor {
	effectName = "texture_overlay";
	stackOrder = PPFX_STACK.TEXTURE_OVERLAY;
	
	enabled = _enabled;
	intensity = _intensity;
	scale = _scale;
	texture = _texture ?? __ppfxGlobal.textureNoisePoint;
	blendmode = _blendmode;
	canDistort = _canDistort;
	tiled = _tiled;
	
	static u_TexOverlayIntensity = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayIntensity");
	static u_TexOverlayTextureUVs = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayTextureUVs");
	static u_TexOverlayTexture = shader_get_sampler_index(__ppf_shRenderTextureOverlay, "u_TexOverlayTexture");
	static u_TexOverlayScale = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayScale");
	static u_TexOverlayBlendMode = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayBlendMode");
	static u_TexOverlayCanDistort = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayCanDistort");
	static u_TexOverlayTiled = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_TexOverlayTiled");
	// dependencies
	static u_d_lensDistortionEnable = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_lensDistortionEnable");
	static u_d_lensDistortionAmount = shader_get_uniform(__ppf_shRenderTextureOverlay, "u_lensDistortionAmount");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderTextureOverlay);
			shader_set_uniform_f(u_TexOverlayIntensity, intensity);
			shader_set_uniform_f(u_TexOverlayScale, scale);
			shader_set_uniform_i(u_TexOverlayBlendMode, blendmode);
			shader_set_uniform_f(u_TexOverlayCanDistort, canDistort);
			shader_set_uniform_f(u_TexOverlayTiled, tiled);
			if (texture != undefined) {
				texture_set_stage(u_TexOverlayTexture, texture);
				gpu_set_texrepeat_ext(u_TexOverlayTexture, tiled);
				var _texUVs = texture_get_uvs(texture);
				shader_set_uniform_f(u_TexOverlayTextureUVs, _texUVs[0], _texUVs[1], _texUVs[2], _texUVs[3]);
			}
			if (canDistort) {
				var _lensEffect = _renderer.__getEffectStruct(FF_LENS_DISTORTION);
				if (_lensEffect != undefined) {
					shader_set_uniform_f(u_d_lensDistortionEnable, _lensEffect.enabled);
					shader_set_uniform_f(u_d_lensDistortionAmount, _lensEffect.amount);
				}
			}
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, scale, ["texture", texture], blendmode, canDistort, tiled],
		};
	}
}

#endregion

#region Sharpen

/// @desc The sharpening effect enhances image clarity and detail by increasing the contrast along edges and fine details.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Defines the sharpen intensity. 0 ~ 10 Recommended.
/// @param {Real} radius Defines the sharpen radius around edges. 0 ~ 10 Recommended.
/// @param {Real} limiar Defines the sharpen limiar blur (mip mapping is required). 0 - 8 Recommended.
function FX_Sharpen(_enabled, _intensity=1, _radius=1, _limiar=0) : __PPF_FXSuperClass() constructor {
	effectName = "sharpen";
	stackOrder = PPFX_STACK.SHARPEN;
	
	enabled = _enabled;
	intensity = _intensity;
	radius = _radius;
	limiar = _limiar;
	
	static u_texelSize = shader_get_uniform(__ppf_shRenderSharpen, "u_texelSize");
	static u_intensity = shader_get_uniform(__ppf_shRenderSharpen, "u_intensity");
	static u_radius = shader_get_uniform(__ppf_shRenderSharpen, "u_radius");
	static u_limiar = shader_get_uniform(__ppf_shRenderSharpen, "u_limiar");
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			shader_set(__ppf_shRenderSharpen);
			shader_set_uniform_f(u_texelSize, 1/_surfaceWidth, 1/_surfaceHeight);
			shader_set_uniform_f(u_intensity, intensity);
			shader_set_uniform_f(u_radius, radius);
			shader_set_uniform_f(u_limiar, limiar);
			draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
			shader_reset();
			
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, radius, limiar],
		};
	}
}

#endregion

#region Compare (DEBUG)

/// @desc With this function, it is possible to compare one stack with another. The default is to compare the last stack with the selected stack (stack index), but it is possible to change the stack order with .SetOrder().
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Bool} sideBySide Lets you show the same images side by side.
/// @param {Real} offset Defines the comparison's x position. Value from 0 to 1.
/// @param {Real} stackIndex The stack index to compare. From 0 to the current stack.
function FX_Compare(_enabled, _sideBySide=false, _offset=0.5, _stackIndex=0) : __PPF_FXSuperClass() constructor {
	effectName = "compare";
	stackOrder = PPFX_STACK.COMPARE;
	
	enabled = _enabled;
	sideBySide = _sideBySide;
	offset = _offset;
	stackIndex = _stackIndex;
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled) exit;
		
		// render
		_renderer.__stackSetSurface(_surfaceWidth, _surfaceHeight, effectName);
			draw_clear_alpha(c_black, 0);
			gpu_push_state();
			gpu_set_blendenable(false);
			// draw surfaces
			if (!sideBySide) {
				// draw current surface
				draw_surface_stretched(_renderer.__stackSurfaces[_renderer.__stackIndex-1], 0, 0, _surfaceWidth, _surfaceHeight);
				
				// first (or selected) surface
				var _stackSurf = _renderer.__stackSurfaces[clamp(stackIndex, 0, _renderer.__stackIndex-1)],
					_ww = surface_get_width(_stackSurf),
					_hh = surface_get_height(_stackSurf),
					_xs = _surfaceWidth / _ww,
					_ys = _surfaceHeight / _hh;
				draw_surface_part_ext(_stackSurf, 0, 0, _ww*offset, _hh, 0, 0, _xs, _ys, c_white, 1);
				
				// line
				var _lineX = _surfaceWidth*offset;
				draw_line_width_color(_lineX, 0, _lineX, _surfaceHeight, 2, c_black, c_black);
			} else {
				// first (or selected) surface
				var _stack1Surf = _renderer.__stackSurfaces[clamp(stackIndex, 0, _renderer.__stackIndex-1)],
					_stack1Width = surface_get_width(_stack1Surf),
					_stack1Height = surface_get_height(_stack1Surf),
					_stack1Xscale = _surfaceWidth / _stack1Width,
					_stack1Yscale = _surfaceHeight / _stack1Height;
				// current surface
				var _stack2Surf = _renderer.__stackSurfaces[_renderer.__stackIndex-1],
					_stack2Width = surface_get_width(_stack2Surf),
					_stack2Height = surface_get_height(_stack2Surf),
					_stack2Xscale = _surfaceWidth / _stack2Width,
					_stack2Yscale = _surfaceHeight / _stack2Height;
				// draw
				if (_surfaceWidth > _surfaceHeight) {
					var _xoffset = lerp(0, _stack1Width/2, offset);
					draw_surface_part_ext(_stack1Surf, _xoffset, 0, _stack1Width+_xoffset, _stack1Height, 0, 0, _stack1Xscale, _stack1Yscale, c_white, 1);
					var _xoffset = lerp(0, _stack2Width/2, offset);
					draw_surface_part_ext(_stack2Surf, _xoffset, 0, _stack2Width+_xoffset, _stack2Height, _stack2Width/2, 0, _stack2Xscale, _stack2Yscale, c_white, 1);
					var _lineX = _surfaceWidth*0.5;
					draw_line_width_color(_lineX, 0, _lineX, _surfaceHeight, 2, c_black, c_black);
				} else {
					var _yoffset = lerp(0, _stack1Height/2, offset);
					draw_surface_part_ext(_stack1Surf, 0, _yoffset, _stack1Width, _stack1Height+_yoffset, 0, 0, _stack1Xscale, _stack1Yscale, c_white, 1);
					var _yoffset = lerp(0, _stack1Height/2, offset);
					draw_surface_part_ext(_stack2Surf, 0, _yoffset, _stack2Width, _stack2Height+_yoffset, 0, _stack2Height/2, _stack2Xscale, _stack2Yscale, c_white, 1);
					var _lineY = _surfaceHeight*0.5;
					draw_line_width_color(0, _lineY, _surfaceWidth, _lineY, 2, c_black, c_black);
				}
			}
			gpu_pop_state();
		surface_reset_target();
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, sideBySide, offset, stackIndex],
		};
	}
}

#endregion

// Base Stack

#region Rotation

/// @desc This effect rotates the screen, maintaining aspect ratio.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} angle Rotation angle in degrees.
function FX_Rotation(_enabled, _angle=0) : __PPF_FXSuperClass() constructor {
	effectName = "rotation";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	angle = _angle;
	
	static u_rotationEnable = shader_get_uniform(__ppf_shRenderBase, "u_rotationEnable");
	static u_rotationAngle = shader_get_uniform(__ppf_shRenderBase, "u_rotationAngle");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_rotationEnable, enabled);
		shader_set_uniform_f(u_rotationAngle, angle);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, angle],
		};
	}
}

#endregion

#region Zoom

/// @desc This effect zooms (enlarges the image), following the normalized center position.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Zoom amount: 1 to 2.
/// @param {Real} range Zoom range. Example: 1 or 10.
/// @param {Array<Real>} center Zoom focus position. An array with the normalized values (0 to 1), in this format: [x, y].
function FX_Zoom(_enabled, _amount=1, _range=1, _center=[0.5, 0.5]) : __PPF_FXSuperClass() constructor {
	effectName = "zoom";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	range = _range;
	center = _center;
	
	static u_zoomEnable = shader_get_uniform(__ppf_shRenderBase, "u_zoomEnable");
	static u_zoomAmount = shader_get_uniform(__ppf_shRenderBase, "u_zoomAmount");
	static u_zoomRange = shader_get_uniform(__ppf_shRenderBase, "u_zoomRange");
	static u_zoomCenter = shader_get_uniform(__ppf_shRenderBase, "u_zoomCenter");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_zoomEnable, enabled);
		shader_set_uniform_f(u_zoomAmount, amount);
		shader_set_uniform_f(u_zoomRange, range);
		shader_set_uniform_f_array(u_zoomCenter, center);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, range, ["vec2", center]],
		};
	}
}

#endregion

#region Shake

/// @desc This effect causes the screen to shake.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} speed Shake speed. A value from 0 to +inf.
/// @param {Real} magnitude Sets how far the screen will flicker, higher values means more shaking. Try values from 0 to 1.
/// @param {Real} hSpeed Horizontal shake speed.
/// @param {Real} vSpeed Vertical shake speed.
function FX_Shake(_enabled, _speed=0.25, _magnitude=0.01, _hSpeed=1, _vSpeed=1) : __PPF_FXSuperClass() constructor {
	effectName = "shake";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	speedd = _speed;
	magnitude = _magnitude;
	hSpeed = _hSpeed;
	vSpeed = _vSpeed;
	
	static u_shakeEnable = shader_get_uniform(__ppf_shRenderBase, "u_shakeEnable");
	static u_shakeSpeed = shader_get_uniform(__ppf_shRenderBase, "u_shakeSpeed");
	static u_shakeMagnitude = shader_get_uniform(__ppf_shRenderBase, "u_shakeMagnitude");
	static u_shakeHspeed = shader_get_uniform(__ppf_shRenderBase, "u_shakeHspeed");
	static u_shakeVspeed = shader_get_uniform(__ppf_shRenderBase, "u_shakeVspeed");
	
	static Draw = function(_renderer) {
		if (!enabled || speedd <= 0) exit;
		shader_set_uniform_f(u_shakeEnable, enabled);
		shader_set_uniform_f(u_shakeSpeed, speedd);
		shader_set_uniform_f(u_shakeMagnitude, magnitude);
		shader_set_uniform_f(u_shakeHspeed, hSpeed);
		shader_set_uniform_f(u_shakeVspeed, vSpeed);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, speedd, magnitude, hSpeed, vSpeed],
		};
	}
}

#endregion

#region Lens Distortion

/// @desc This effect simulates CRT distortion, where the distortion can be positive or negative.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Distortion amount. Positive = Barrel, Negative = Pincushion. 0 = No distortion. Recommended: -1 to 1
function FX_LensDistortion(_enabled, _amount=0) : __PPF_FXSuperClass() constructor {
	effectName = "lens_distortion";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	
	static u_lensDistortionEnable = shader_get_uniform(__ppf_shRenderBase, "u_lensDistortionEnable");
	static u_lensDistortionAmount = shader_get_uniform(__ppf_shRenderBase, "u_lensDistortionAmount"); // not needed anymore - it will be declared in the others effect constructor itself
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_lensDistortionEnable, enabled);
		shader_set_uniform_f(u_lensDistortionAmount, amount);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount],
		};
	}
}

#endregion

#region Pixelization

/// @desc Turn small pixels into artificial big pixels.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Overal pixel resolution multiplier. 0 to 1.
/// @param {Real} pixelMaxSize Maximum individual pixel size.
/// @param {Real} steps Steps to change pixelation intensity. Helps prevent sudden change.
function FX_Pixelize(_enabled, _amount=0.5, _pixelMaxSize=80, _steps=50) : __PPF_FXSuperClass() constructor {
	effectName = "pixelize";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	pixelMaxSize = _pixelMaxSize;
	steps = _steps;
	
	static u_pixelizeEnable = shader_get_uniform(__ppf_shRenderBase, "u_pixelizeEnable");
	static u_pixelizeAmount = shader_get_uniform(__ppf_shRenderBase, "u_pixelizeAmount");
	static u_pixelizePixelMaxSize = shader_get_uniform(__ppf_shRenderBase, "u_pixelizePixelMaxSize");
	static u_pixelizeSteps = shader_get_uniform(__ppf_shRenderBase, "u_pixelizeSteps");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_pixelizeEnable, enabled);
		shader_set_uniform_f(u_pixelizeAmount, amount);
		shader_set_uniform_f(u_pixelizePixelMaxSize, max(pixelMaxSize, 1));
		shader_set_uniform_f(u_pixelizeSteps, steps);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, pixelMaxSize, steps],
		};
	}
}

#endregion

#region Swirl

/// @desc Creates a swirl effect (like a Black Hole) at the defined position.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} angle Swirl angle. In degress, 0 to 360.
/// @param {Real} radius Swirl radius. 0 to 1.
/// @param {Real} rounded If true, the swirl will be rounded (follow the aspect ratio).
/// @param {Array<Real>} center The position. An array with the normalized values (0 to 1), in this format: [x, y].
function FX_Swirl(_enabled, _angle=35, _radius=1, _rounded=false, _center=[0.5,0.5]) : __PPF_FXSuperClass() constructor {
	effectName = "swirl";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	angle = _angle;
	radius = _radius;
	rounded = _rounded;
	center = _center;
	
	static u_swirlEnable = shader_get_uniform(__ppf_shRenderBase, "u_swirlEnable");
	static u_swirlAngle = shader_get_uniform(__ppf_shRenderBase, "u_swirlAngle");
	static u_swirlRadius = shader_get_uniform(__ppf_shRenderBase, "u_swirlRadius");
	static u_swirlRounded = shader_get_uniform(__ppf_shRenderBase, "u_swirlRounded");
	static u_swirlCenter = shader_get_uniform(__ppf_shRenderBase, "u_swirlCenter");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_swirlEnable, enabled);
		shader_set_uniform_f(u_swirlAngle, angle);
		shader_set_uniform_f(u_swirlRadius, radius);
		shader_set_uniform_f(u_swirlRounded, rounded);
		shader_set_uniform_f_array(u_swirlCenter, center);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, angle, radius, rounded, ["vec2", center]],
		};
	}
}

#endregion

#region Panorama

/// @desc Creates a side warp effect to simulate perspective.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} depthX The horizontal distortion depth. 0 to 3.
/// @param {Real} depthy The vertical distortion depth. 0 to 3.
function FX_Panorama(_enabled, _depthX=1, _depthY=0) : __PPF_FXSuperClass() constructor {
	effectName = "panorama";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	depthX = _depthX;
	depthY = _depthY;
	
	static u_panoramaEnable = shader_get_uniform(__ppf_shRenderBase, "u_panoramaEnable");
	static u_panoramaDepthX = shader_get_uniform(__ppf_shRenderBase, "u_panoramaDepthX");
	static u_panoramaDepthY = shader_get_uniform(__ppf_shRenderBase, "u_panoramaDepthY");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_panoramaEnable, enabled);
		shader_set_uniform_f(u_panoramaDepthX, depthX);
		shader_set_uniform_f(u_panoramaDepthY, depthY);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, depthX, depthY],
		};
	}
}

#endregion

#region Sine Wave

/// @desc Create a sine wave effect on the screen, using frequency and amplitude.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} speedd Animation speed.
/// @param {Array<Real>} amplitude Sine wave amplitude.
/// @param {Array<Real>} frequency Sine wave frequency.
/// @param {Array<Real>} offset Position offset. Use the camera position. An array with absolute values, in this format: [cam_x, cam_y].
function FX_SineWave(_enabled, _speed=0.5, _amplitude=[0.02,0.02], _frequency=[10,10], _offset=[0,0]) : __PPF_FXSuperClass() constructor {
	effectName = "sine_wave";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	speedd = _speed;
	amplitude = _amplitude;
	frequency = _frequency;
	offset = _offset;
	
	static u_sinewaveEnable = shader_get_uniform(__ppf_shRenderBase, "u_sinewaveEnable");
	static u_sinewaveFrequency = shader_get_uniform(__ppf_shRenderBase, "u_sinewaveFrequency");
	static u_sinewaveAmplitude = shader_get_uniform(__ppf_shRenderBase, "u_sinewaveAmplitude");
	static u_sinewaveSpeed = shader_get_uniform(__ppf_shRenderBase, "u_sinewaveSpeed");
	static u_sinewaveOffset = shader_get_uniform(__ppf_shRenderBase, "u_sinewaveOffset");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_sinewaveEnable, enabled);
		shader_set_uniform_f_array(u_sinewaveFrequency, frequency);
		shader_set_uniform_f_array(u_sinewaveAmplitude, amplitude);
		shader_set_uniform_f(u_sinewaveSpeed, speedd);
		shader_set_uniform_f_array(u_sinewaveOffset, offset);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, speedd, ["vec2", amplitude], ["vec2", frequency], ["vec2", offset]],
		};
	}
}

#endregion

#region Interference

/// @desc Create interference effects to simulate broadcast glitches like old TV or cyber futuristic.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} speedd Intereference animation speed.
/// @param {Real} block_size Vertical bars size.
/// @param {Real} interval Interval to start failure. Closer to 1 means rarer.
/// @param {Real} intensity Displace amount.
/// @param {Real} peak_amplitude1 Distortion when reaching the interval.
/// @param {Real} peak_amplitude2 Distortion out of interval.
function FX_Interference(_enabled, _speed=1, _blockSize=0.9, _interval=0.995, _intensity=0.2, _peakAmplitude1=2, _peakAmplitude2=1.5) : __PPF_FXSuperClass() constructor {
	effectName = "interference";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	speedd = _speed;
	blockSize = _blockSize;
	interval = _interval;
	intensity = _intensity;
	peakAmplitude1 = _peakAmplitude1;
	peakAmplitude2 = _peakAmplitude2;
	
	static u_interferenceEnable = shader_get_uniform(__ppf_shRenderBase, "u_interferenceEnable");
	static u_interferenceSpeed = shader_get_uniform(__ppf_shRenderBase, "u_interferenceSpeed");
	static u_interferenceBlockSize = shader_get_uniform(__ppf_shRenderBase, "u_interferenceBlockSize");
	static u_interferenceInterval = shader_get_uniform(__ppf_shRenderBase, "u_interferenceInterval");
	static u_interferenceIntensity = shader_get_uniform(__ppf_shRenderBase, "u_interferenceIntensity");
	static u_interferencePeakAmplitude1 = shader_get_uniform(__ppf_shRenderBase, "u_interferencePeakAmplitude1");
	static u_interferencePeakAmplitude2 = shader_get_uniform(__ppf_shRenderBase, "u_interferencePeakAmplitude2");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_interferenceEnable, enabled);
		shader_set_uniform_f(u_interferenceSpeed, speedd);
		shader_set_uniform_f(u_interferenceBlockSize, blockSize);
		shader_set_uniform_f(u_interferenceInterval, interval);
		shader_set_uniform_f(u_interferenceIntensity, intensity);
		shader_set_uniform_f(u_interferencePeakAmplitude1, peakAmplitude1);
		shader_set_uniform_f(u_interferencePeakAmplitude2, peakAmplitude2);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, speedd, blockSize, interval, intensity, peakAmplitude1, peakAmplitude2],
		};
	}
}

#endregion

#region Shockwaves

/// @desc Shockwaves screen distortion effect, perfect for enhancing explosion simulation or related stuff.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Displacement amount. 0 to 1.
/// @param {Real} aberration Chromatic aberration offset amount. 0 to 1.
/// @param {Pointer.Texture} prismaLutTexture Spectral The spectral LUT texture, used to define the spectral colors.
/// Texture should be 8x3, with RGB channels horizontally. Use sprite_get_texture() or surface_get_texture().
/// @param {Pointer.Texture} texture Normalmap surface. Use shockwave_render() to make it easy.
function FX_Shockwaves(_enabled, _amount=0.1, _aberration=0.1, _prismaLutTexture=undefined, _texture=undefined) : __PPF_FXSuperClass() constructor {
	effectName = "shockwaves";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	aberration = _aberration;
	prismaLutTexture = _prismaLutTexture ?? __ppfxGlobal.textureShockwavesPrismaLut;
	texture = _texture ?? __ppfxGlobal.textureNormal;
	
	static u_shockwavesEnable = shader_get_uniform(__ppf_shRenderBase, "u_shockwavesEnable");
	static u_shockwavesAmount = shader_get_uniform(__ppf_shRenderBase, "u_shockwavesAmount");
	static u_shockwavesAberration = shader_get_uniform(__ppf_shRenderBase, "u_shockwavesAberration");
	static u_shockwavesTexture = shader_get_sampler_index(__ppf_shRenderBase, "u_shockwavesTexture");
	static u_shockwavesPrismaLutTexture = shader_get_sampler_index(__ppf_shRenderBase, "u_shockwavesPrismaLutTexture");
	static u_shockwavesUVs = shader_get_uniform(__ppf_shRenderBase, "u_shockwavesUVs");
	static u_shockwavesPrismaLutUVs = shader_get_uniform(__ppf_shRenderBase, "u_shockwavesPrismaLutUVs");
	
	static Draw = function(_renderer) {
		if (!enabled || texture == undefined || texture < 0) exit;
		shader_set_uniform_f(u_shockwavesEnable, enabled);
		shader_set_uniform_f(u_shockwavesAmount, amount);
		shader_set_uniform_f(u_shockwavesAberration, aberration);
		if (texture != undefined) {
			var _UVs = texture_get_uvs(texture);
			shader_set_uniform_f(u_shockwavesUVs, _UVs[0], _UVs[1], _UVs[2], _UVs[3]);
			texture_set_stage(u_shockwavesTexture, texture);
		}
		if (prismaLutTexture != undefined) {
			var _prismaUVs = texture_get_uvs(prismaLutTexture);
			shader_set_uniform_f(u_shockwavesPrismaLutUVs, _prismaUVs[0], _prismaUVs[1], _prismaUVs[2], _prismaUVs[3]);
			texture_set_stage(u_shockwavesPrismaLutTexture, prismaLutTexture);
		}
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, aberration, ["texture", prismaLutTexture], texture],
		};
	}
}

#endregion

#region Displacemaps

/// @desc Displacement screen distortion effect, perfect for simulating rain, water drops/drops on the screen and related things
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Displacement amount. 0 to 1.
/// @param {Real} scale The scale amount. Default is 1 (no scale). 0.25 to 20 recommended.
/// @param {Real} speed Movement speed.
/// @param {Real} angle Movemente direction.
/// @param {Pointer.Texture} texture Normal map texture with distortion information.
/// @param {Array<Real>} offset Position offset. Use the camera position. An array with absolute values, in this format: [cam_x, cam_y].
function FX_DisplaceMap(_enabled, _amount=0.1, _scale=1, _speed=0.1, _angle=0, _texture=undefined, _offset=[0,0]) : __PPF_FXSuperClass() constructor {
	effectName = "displacemap";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.BASE;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	scale = _scale;
	angle = _angle;
	speedd = _speed;
	texture = _texture ?? __ppfxGlobal.textureNormal;
	offset = _offset;
	
	static u_displacemapEnable = shader_get_uniform(__ppf_shRenderBase, "u_displacemapEnable");
	static u_displacemapAmount = shader_get_uniform(__ppf_shRenderBase, "u_displacemapAmount");
	static u_displacemapScale = shader_get_uniform(__ppf_shRenderBase, "u_displacemapScale");
	static u_displacemapAngle = shader_get_uniform(__ppf_shRenderBase, "u_displacemapAngle");
	static u_displacemapSpeed = shader_get_uniform(__ppf_shRenderBase, "u_displacemapSpeed");
	static u_displacemapUVs = shader_get_uniform(__ppf_shRenderBase, "u_displacemapUVs");
	static u_displacemapTexture = shader_get_sampler_index(__ppf_shRenderBase, "u_displacemapTexture");
	static u_displacemapOffset = shader_get_uniform(__ppf_shRenderBase, "u_displacemapOffset");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_displacemapEnable, enabled);
		shader_set_uniform_f(u_displacemapAmount, amount);
		shader_set_uniform_f(u_displacemapScale, scale);
		shader_set_uniform_f(u_displacemapAngle, -degtorad(angle));
		shader_set_uniform_f(u_displacemapSpeed, speedd);
		if (texture != undefined) {
			var _UVs = texture_get_uvs(texture);
			shader_set_uniform_f(u_displacemapUVs, _UVs[0], _UVs[1], _UVs[2], _UVs[3]);
			texture_set_stage(u_displacemapTexture, texture);
		}
		shader_set_uniform_f_array(u_displacemapOffset, offset);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, scale, speedd, angle, texture, ["vec2", offset]],
		};
	}
}

#endregion

// Color Grading

#region White Balance

/// @desc White balance is used to adjust colors to match the color of the light source so that white objects appear white.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} temperature Higher values result in a warmer color temperature and lower values result in a colder color temperature. -1.67 to 1.67.
/// @param {Real} tint Compensate for a green or magenta tint.
function FX_WhiteBalance(_enabled, _temperature=0, _tint=0) : __PPF_FXSuperClass() constructor {
	effectName = "white_balance";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	temperature = _temperature;
	tint = _tint;
	
	static u_whiteBalanceEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_whiteBalanceEnable");
	static u_whiteBalanceChromaticity = shader_get_uniform(__ppf_shRenderColorGrading, "u_whiteBalanceChromaticity");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_whiteBalanceEnable, enabled);
		// Get the CIE xy chromaticity of the reference white point
		// 0.31271 = x value on the D65 white point
		var _temperature = clamp(__ppf_relerp(-1, 1, temperature, -1.67, 1.67), -1.67, 1.67),
		_x = 0.31271 - _temperature * (_temperature < 0 ? 0.1 : 0.05),
		_standardLumY = 2.87 * _x - 3.0 * _x * _x - 0.27509507,
		_y = _standardLumY + tint * 0.05;
		shader_set_uniform_f(u_whiteBalanceChromaticity, _x, _y);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, temperature, tint],
		};
	}
}

#endregion

#region Exposure

/// @desc Adjusts the overall exposure of the screen.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {real} value Exposure amount. 0 to 2 recommended.
function FX_Exposure(_enabled, _value=1) : __PPF_FXSuperClass() constructor {
	effectName = "exposure";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	value = _value;
	
	static u_exposureEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_exposureEnable");
	static u_exposureValue = shader_get_uniform(__ppf_shRenderColorGrading, "u_exposureValue");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_exposureEnable, enabled);
		shader_set_uniform_f(u_exposureValue, value);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, value],
		};
	}
}

#endregion

#region Tone Mapping

/// @desc Compress the dynamic range of an image to make it more suitable for display on devices with limited dynamic range (HDR to LDR). It is also used for aesthetic purposes.
/// NOTE: This effect works correctly if using HDR. If not, it will not be useful, because there is little color range (8 bits only).
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} mode Tone Mapping mode. 0 = Linear | 1 = Reinhard | 2 = ACES | 3 = ACES Film
/// @param {Real} white The white amount. 0 = No additional white. 1 = Same as Linear tone mapping. More than 1 = more white.
function FX_ToneMapping(_enabled, _mode=1, _white=0) : __PPF_FXSuperClass() constructor {
	effectName = "tone_mapping";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	mode = _mode;
	white = _white;
	
	static u_toneMappingEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_toneMappingEnable");
	static u_toneMappingMode = shader_get_uniform(__ppf_shRenderColorGrading, "u_toneMappingMode");
	static u_toneMappingWhite = shader_get_uniform(__ppf_shRenderColorGrading, "u_toneMappingWhite");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_toneMappingEnable, enabled);
		shader_set_uniform_i(u_toneMappingMode, mode);
		shader_set_uniform_f(u_toneMappingWhite, 1/white);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, mode, white],
		};
	}
}

#endregion

#region Contrast

/// @desc The overall range of tonal values.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} value The contrast amount. 0 to 2 recommended.
function FX_Contrast(_enabled, _value=1) : __PPF_FXSuperClass() constructor {
	effectName = "contrast";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	value = _value;
	
	static u_contrastEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_contrastEnable");
	static u_contrastValue = shader_get_uniform(__ppf_shRenderColorGrading, "u_contrastValue");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_contrastEnable, enabled);
		shader_set_uniform_f(u_contrastValue, value);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, value],
		};
	}
}

#endregion

#region Brightness

/// @desc The amount of white color mixed with the image.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} value The amount of brightness. 0 to 2 recommended.
function FX_Brightness(_enabled, _value=1) : __PPF_FXSuperClass() constructor {
	effectName = "brightness";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	value = _value;
	
	static u_brightnessEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_brightnessEnable");
	static u_brightnessValue = shader_get_uniform(__ppf_shRenderColorGrading, "u_brightnessValue");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_brightnessEnable, enabled);
		shader_set_uniform_f(u_brightnessValue, value);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, value],
		};
	}
}

#endregion

#region Channel Mixer

/// @desc Channel Mixer allows you to take the red, green, and blue channels and boost or pull back the levels of each one.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} redRed The red color of the red channel. 0 - 2 recommended. Default is 1;
/// @param {Real} redGreen The green color of the red channel. 0 - 2 recommended. Default is 0;
/// @param {Real} redBlue The blue color of the red channel. 0 - 2 recommended. Default is 0;
/// @param {Real} greenRed The red color of the green channel. 0 - 2 recommended. Default is 0;
/// @param {Real} greenGreen The green color of the green channel. 0 - 2 recommended. Default is 1;
/// @param {Real} greenBlue The blue color of the green channel. 0 - 2 recommended. Default is 0;
/// @param {Real} blueRed The red color of the blue channel. 0 - 2 recommended. Default is 0;
/// @param {Real} blueGreen The green color of the blue channel. 0 - 2 recommended. Default is 0;
/// @param {Real} blueBlue The blue color of the blue channel. 0 - 2 recommended. Default is 1;
function FX_ChannelMixer(_enabled, _redRed=1, _redGreen=0, _redBlue=0, _greenRed=0, _greenGreen=1, _greenBlue=0, _blueRed=0, _blueGreen=0, _blueBlue=1) : __PPF_FXSuperClass() constructor {
	effectName = "channel_mixer";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	redRed = _redRed;
	redGreen = _redGreen;
	redBlue = _redBlue;
	greenRed = _greenRed;
	greenGreen = _greenGreen;
	greenBlue = _greenBlue;
	blueRed = _blueRed;
	blueGreen = _blueGreen;
	blueBlue = _blueBlue;
	
	static u_channelMixerEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_channelMixerEnable");
	static u_channelMixerRed = shader_get_uniform(__ppf_shRenderColorGrading, "u_channelMixerRed");
	static u_channelMixerGreen = shader_get_uniform(__ppf_shRenderColorGrading, "u_channelMixerGreen");
	static u_channelMixerBlue = shader_get_uniform(__ppf_shRenderColorGrading, "u_channelMixerBlue");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_channelMixerEnable, enabled);
		shader_set_uniform_f(u_channelMixerRed, redRed, redGreen, redBlue);
		shader_set_uniform_f(u_channelMixerGreen, greenRed, greenGreen, greenBlue);
		shader_set_uniform_f(u_channelMixerBlue, blueRed, blueGreen, blueBlue);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, redRed, redGreen, redBlue, greenRed, greenGreen, greenBlue, blueRed, blueGreen, blueBlue],
		};
	}
}

#endregion

#region Color Balance (Shadow, Midtone, Highlight)

/// @desc This effect separately controls the shadows, midtones, and highlights of the image.
/// Unlike Lift, Gamma, Gain, you can use this effect to precisely define the tonal range for shadows, midtones, and highlights.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} shadowRed The red color of shadows. 0 - 2 recommended. Default is 1;
/// @param {Real} shadowGreen The green color of shadows. 0 - 2 recommended. Default is 0;
/// @param {Real} shadowBlue The blue color of shadows. 0 - 2 recommended. Default is 0;
/// @param {Real} midtoneGreen The red color of midtones. 0 - 2 recommended. Default is 0;
/// @param {Real} midtoneGreen The green color of midtones. 0 - 2 recommended. Default is 1;
/// @param {Real} midtoneBlue The blue color of the midtones. 0 - 2 recommended. Default is 0;
/// @param {Real} highlightRed The red color of highlights. 0 - 2 recommended. Default is 0;
/// @param {Real} highlightGreen The green color of highlights. 0 - 2 recommended. Default is 0;
/// @param {Real} highlightBlue The blue color of highlights. 0 - 2 recommended. Default is 1;
/// @param {Real} shadowRangeMin The shadow range minimum value. 0 - 1.
/// @param {Real} shadowRangeMax The shadow range maximum value. 0 - 1.
/// @param {Real} highlightRangeMin The highlight range minimum value. 0 - 1.
/// @param {Real} highlightRangeMax The highlight range maximum value. 0 - 1.
function FX_ShadowMidtoneHighlight(_enabled, _shadowRed=1, _shadowGreen=1, _shadowBlue=1, _midtoneRed=1, _midtoneGreen=1, _midtoneBlue=1, _highlightRed=1, _highlightGreen=1, _highlightBlue=1, _shadowRangeMin=0, _shadowRangeMax=0.33, _highlightRangeMin=0.55, _highlightRangeMax=1) : __PPF_FXSuperClass() constructor {
	effectName = "shadow_midtone_highlight";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	shadowRed = _shadowRed;
	shadowGreen = _shadowGreen;
	shadowBlue = _shadowBlue;
	midtoneRed = _midtoneRed;
	midtoneGreen = _midtoneGreen;
	midtoneBlue = _midtoneBlue;
	highlightRed = _highlightRed;
	highlightGreen = _highlightGreen;
	highlightBlue = _highlightBlue;
	shadowRangeMin = _shadowRangeMin;
	shadowRangeMax = _shadowRangeMax;
	highlightRangeMin = _highlightRangeMin;
	highlightRangeMax = _highlightRangeMax;
	
	static u_colorBalanceEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_colorBalanceEnable");
	static u_shadowColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_shadowColor");
	static u_midtoneColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_midtoneColor");
	static u_highlightColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_highlightColor");
	static u_colorBalanceRanges = shader_get_uniform(__ppf_shRenderColorGrading, "u_colorBalanceRanges");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_colorBalanceEnable, enabled);
		shader_set_uniform_f(u_shadowColor, shadowRed, shadowGreen, shadowBlue);
		shader_set_uniform_f(u_midtoneColor, midtoneRed, midtoneGreen, midtoneBlue);
		shader_set_uniform_f(u_highlightColor, highlightRed, highlightGreen, highlightBlue);
		shader_set_uniform_f(u_colorBalanceRanges, shadowRangeMin, shadowRangeMax, highlightRangeMin, highlightRangeMax);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, shadowRed, shadowGreen, shadowBlue, midtoneRed, midtoneGreen, midtoneBlue, highlightRed, highlightGreen, highlightBlue, shadowRangeMin, shadowRangeMax, highlightRangeMin, highlightRangeMax],
		};
	}
}

#endregion

#region Lift Gamma Gain

/// @desc This effect allows you to perform three-way color grading.
/// Lift controls the dark tones;
/// Gamma controls the mid-range tones with a power function;
/// Gain is used to increase the signal and make highlights brighter;
function FX_LiftGammaGain(_enabled, _liftIntensity=1, _gammaIntensity=1, _gainIntensity=1, _liftRed=1, _liftGreen=1, _liftBlue=1, _gammaRed=1, _gammaGreen=1, _gammaBlue=1, _gainRed=1, _gainGreen=1, _gainBlue=1) : __PPF_FXSuperClass() constructor {
	effectName = "lift_gamma_gain";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	liftIntensity = _liftIntensity;
	gammaIntensity = _gammaIntensity;
	gainIntensity = _gainIntensity;
	liftRed = _liftRed;
	liftGreen = _liftGreen;
	liftBlue = _liftBlue;
	gammaRed = _gammaRed;
	gammaGreen = _gammaGreen;
	gammaBlue = _gammaBlue;
	gainRed = _gainRed;
	gainGreen = _gainGreen;
	gainBlue = _gainBlue;
	
	static u_liftGammaGainEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_liftGammaGainEnable");
	static u_liftColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_liftColor");
	static u_invGammaColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_invGammaColor");
	static u_gainColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_gainColor");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_liftGammaGainEnable, enabled);
		shader_set_uniform_f(u_liftColor, liftRed*liftIntensity, liftGreen*liftIntensity, liftBlue*liftIntensity);
		shader_set_uniform_f(u_invGammaColor, 1/(gammaRed*gammaIntensity), 1/(gammaGreen*gammaIntensity), 1/(gammaBlue*gammaIntensity));
		shader_set_uniform_f(u_gainColor, gainRed*gainIntensity, gainGreen*gainIntensity, gainBlue*gainIntensity);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, liftIntensity, gammaIntensity, gainIntensity, liftRed, liftGreen, liftBlue, gammaRed, gammaGreen, gammaBlue, gainRed, gainGreen, gainBlue],
		};
	}
}

#endregion

#region Saturation

/// @desc Relative bandwidth of the visible output from a light source;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} value How much the grayscale is blended with the original image. 0 to 5 recommended.
function FX_Saturation(_enabled, _value=1) : __PPF_FXSuperClass() constructor {
	effectName = "saturation";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	value = _value;
	
	static u_saturationEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_saturationEnable");
	static u_saturationValue = shader_get_uniform(__ppf_shRenderColorGrading, "u_saturationValue");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_saturationEnable, enabled);
		shader_set_uniform_f(u_saturationValue, value);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, value],
		};
	}
}

#endregion

#region Hue Shift

/// @desc Change the overall color tone of an image.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} hue The hue, in degrees. 0 to 255. Tip: you can use color_get_hue(color) here.
/// @param {Real} saturation The saturation. 0 to 1.
/// @param {Real} preserveLuminance Sets whether curves should preserve luminance.
function FX_HueShift(_enabled, _hue=0, _saturation=255, _preserveLuminance=false) : __PPF_FXSuperClass() constructor {
	effectName = "hue_shift";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	hue = _hue;
	saturation = _saturation;
	preserveLuminance = _preserveLuminance;
	
	static u_hueshiftEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_hueshiftEnable");
	static u_hueshiftHSV = shader_get_uniform(__ppf_shRenderColorGrading, "u_hueshiftHSV");
	static u_hueshiftPreserveLum = shader_get_uniform(__ppf_shRenderColorGrading, "u_hueshiftPreserveLum");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_hueshiftEnable, enabled);
		shader_set_uniform_f(u_hueshiftHSV, hue/255, saturation/255, 1);
		shader_set_uniform_f(u_hueshiftPreserveLum, preserveLuminance);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, hue, saturation, preserveLuminance],
		};
	}
}

#endregion

#region Color Tint

/// @desc Multiply the image by a color.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} color The color. Example: c_white | make_color_rgb() | make_color_hsv().
function FX_ColorTint(_enabled, _color=c_white) : __PPF_FXSuperClass() constructor {
	effectName = "color_tint";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	color = make_color_ppfx(_color);
	
	static u_colortintEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_colortintEnable");
	static u_colortintColor = shader_get_uniform(__ppf_shRenderColorGrading, "u_colortintColor");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_colortintEnable, enabled);
		shader_set_uniform_f_array(u_colortintColor, color);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, ["color", color]],
		};
	}
}

#endregion

#region Colorize

/// @desc Colorize image preserving white colors.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} hue The hue shift offset. 0 to 255.
/// @param {Real} saturation The color saturation. 0 to 255.
/// @param {Real} value The color luminosity. 0 to 255.
/// @param {Real} intensity How much to blend the colored image with the original image. 0 to 1.
function FX_Colorize(_enabled, _hue=0, _saturation=140, _value=255, _intensity=1) : __PPF_FXSuperClass() constructor {
	effectName = "colorize";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	hue = _hue;
	saturation = _saturation;
	value = _value;
	intensity = _intensity;
	
	static u_colorizeEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_colorizeEnable");
	static u_colorizeHSV = shader_get_uniform(__ppf_shRenderColorGrading, "u_colorizeHSV");
	static u_colorizeIntensity = shader_get_uniform(__ppf_shRenderColorGrading, "u_colorizeIntensity");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_colorizeEnable, enabled);
		shader_set_uniform_f(u_colorizeHSV, hue/255, saturation/255, value/255);
		shader_set_uniform_f(u_colorizeIntensity, intensity);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, hue, saturation, value, intensity],
		};
	}
}

#endregion

#region Posterization

/// @desc Defines the amount of color displayed on the screen.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} colorFactor The amount of colors. 2 to 256 recommended.
function FX_Posterization(_enabled, _colorFactor=8) : __PPF_FXSuperClass() constructor {
	effectName = "posterization";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	colorFactor = _colorFactor;
	
	static u_posterizationEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_posterizationEnable");
	static u_posterizationColFactor = shader_get_uniform(__ppf_shRenderColorGrading, "u_posterizationColFactor");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_posterizationEnable, enabled);
		shader_set_uniform_f(u_posterizationColFactor, colorFactor);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, colorFactor],
		};
	}
}

#endregion

#region Invert Colors

/// @desc Invert all colors, such that white becomes black and vice versa.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity How much the inverted image merges with the original image. 0 to 1.
function FX_InvertColors(_enabled, _intensity=1) : __PPF_FXSuperClass() constructor {
	effectName = "invert_colors";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	
	static u_invertColorsEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_invertColorsEnable");
	static u_invertColorsIntensity = shader_get_uniform(__ppf_shRenderColorGrading, "u_invertColorsIntensity");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_invertColorsEnable, enabled);
		shader_set_uniform_f(u_invertColorsIntensity, intensity);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity],
		};
	}
}

#endregion

#region Color Curves

/// @desc Color grading curves provide an advanced method for fine-tuning specific ranges of hue, saturation or luminosity in an image. You can manipulate the curves using graphs to accomplish effects like saturation in certain colors.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} preserveLuminance Sets whether curves should preserve luminance.
/// @param {Struct} yrgbCurve A curve generated with PPFX_Curve().
/// @param {Struct} hhslCurve A curve generated with PPFX_Curve().
function FX_ColorCurves(_enabled, _preserveLuminance=false, _YRGBcurve=undefined, _HHSLCurve=undefined) : __PPF_FXSuperClass() constructor {
	effectName = "color_curves";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	preserveLuminance = _preserveLuminance;
	yrgbCurve = _YRGBcurve;
	hhslCurve = _HHSLCurve;
	
	static u_curvesEnable = shader_get_uniform(__ppf_shRenderColorGrading, "u_curvesEnable");
	static u_curvesPreserveLuminance = shader_get_uniform(__ppf_shRenderColorGrading, "u_curvesPreserveLuminance");
	static u_curvesUseYRGB = shader_get_uniform(__ppf_shRenderColorGrading, "u_curvesUseYRGB");
	static u_curvesUseHHSL = shader_get_uniform(__ppf_shRenderColorGrading, "u_curvesUseHHSL");
	static u_curvesYRGBTexture = shader_get_sampler_index(__ppf_shRenderColorGrading, "u_curvesYRGBTexture");
	static u_curvesHHSLTexture = shader_get_sampler_index(__ppf_shRenderColorGrading, "u_curvesHHSLTexture");
	
	static Draw = function(_renderer) {
		var _yrgbCurve = yrgbCurve, _hhslCurve = hhslCurve;
		
		if (!enabled || (_yrgbCurve == undefined && _hhslCurve == undefined)) exit;
		
		shader_set_uniform_f(u_curvesEnable, enabled);
		shader_set_uniform_f(u_curvesPreserveLuminance, preserveLuminance);
		shader_set_uniform_f(u_curvesUseYRGB, false);
		shader_set_uniform_f(u_curvesUseHHSL, false);
		if (_yrgbCurve != undefined) {
			if (!surface_exists(_yrgbCurve.__curve_surf)) _yrgbCurve.__restore_surface();
			texture_set_stage(u_curvesYRGBTexture, surface_get_texture(_yrgbCurve.__curve_surf));
			shader_set_uniform_f(u_curvesUseYRGB, true);
		}
		if (_hhslCurve != undefined) {
			if (!surface_exists(_hhslCurve.__curve_surf)) _hhslCurve.__restore_surface();
			texture_set_stage(u_curvesHHSLTexture, surface_get_texture(_hhslCurve.__curve_surf));
			shader_set_uniform_f(u_curvesUseHHSL, true);
		}
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, preserveLuminance, undefined, undefined],
		};
	}
}

#endregion

#region LUT

/// @desc Uses a LUT texture to apply color correction (useful for Mobile as it's lightweight).
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity How much the LUT-modified image merges with the original image.
/// @param {Real} type The LUT type to be used.  0: Strip | 1: Grid | 2: Hald Grid (Cube).
/// @param {Real} horizontalSquares Horizontal LUT squares. Example: 16 (Strip), 8 (Grid), 8 (Hald Grid).
/// @param {Pointer.Texture} texture The LUT texture. Use sprite_get_texture() or surface_get_texture().
function FX_LUT(_enabled, _intensity=1, _type=1, _horizontalSquares=8, _texture=undefined) : __PPF_FXSuperClass() constructor {
	effectName = "lut";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.COLOR_GRADING;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	type = _type;
	squares = _horizontalSquares;
	texture = _texture;
	
	static u_LUTenable = shader_get_uniform(__ppf_shRenderColorGrading, "u_LUTenable");
	static u_LUTsize = shader_get_uniform(__ppf_shRenderColorGrading, "u_LUTsize");
	static u_LUTUVs = shader_get_uniform(__ppf_shRenderColorGrading, "u_LUTUVs");
	static u_LUTTiles = shader_get_uniform(__ppf_shRenderColorGrading, "u_LUTTiles");
	static u_LUTintensity = shader_get_uniform(__ppf_shRenderColorGrading, "u_LUTintensity");
	static u_LUTtexture = shader_get_sampler_index(__ppf_shRenderColorGrading, "u_LUTtexture");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_LUTenable, enabled);
		var _tex = texture;
		if (_tex != undefined) {
			var _type = type, _squares = squares, _width = 0, _height = 0, _squaresW = 1, _squaresH = 1;
			if (_type == 0) {
				// Strip
				_squaresW = _squares;
				_squaresH = 1;
				_width = _squares * _squares;
				_height = _squares;
			} else
			if (_type == 1) {
				// Grid
				_squaresW = _squares;
				_squaresH = _squares;
				_width = power(_squares, 3);
				_height = _width;
			} else
			if (_type == 2) {
				// Hald Grid
				_squaresW = _squares;
				_squaresH = _squares * _squares;
				_width = power(_squares, 3);
				_height = _width;
			}
			shader_set_uniform_f(u_LUTsize, _width, _height);
			shader_set_uniform_f(u_LUTTiles, _squaresW, _squaresH);
			shader_set_uniform_f(u_LUTintensity, intensity);
			gpu_set_tex_repeat_ext(u_LUTtexture, false);
			gpu_set_tex_filter_ext(u_LUTtexture, true);
			if (gpu_get_tex_mip_enable()) gpu_set_tex_mip_enable_ext(u_LUTtexture, mip_off);
			texture_set_stage(u_LUTtexture, _tex);
			var _texUVs = texture_get_uvs(_tex);
			shader_set_uniform_f(u_LUTUVs, _texUVs[0], _texUVs[1], _texUVs[2], _texUVs[3]);
		}
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, type, squares, ["texture", texture]],
		};
	}
}

#endregion

// Final

#region Mist

/// @desc A fog/mist effect to give a gloomy look, which can be used in forests, imitate fire, and among others.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity The mist intensity. 0 to 1 recommended.
/// @param {Real} scale Noise scale. 0 to 1.
/// @param {Real} tiling Repetition of noise rays. 0.25 to 10 recommended.
/// @param {Real} speedd Noise movement speed.
/// @param {Real} angle Noise angle.
/// @param {Real} contrast Noise contrast.
/// @param {Real} power Helps make noise sharper. 0 to 1 recommended.
/// @param {Real} remap Central softness. 0 to 0.99 recommended.
/// @param {Real} color Mist color tint.
/// @param {Real} mix Blending intensity with image lights.
/// @param {Real} mixThreshold The level of brightness to filter out pixels under this level. 0 to 1; 0 means all light pixels.
/// @param {Pointer.Texture} noiseTex The noise texture to be used as mist/fog.
/// @param {Array<Real>} offset Position offset. Use the camera position. An array with absolute values, in this format: [cam_x, cam_y].
/// @param {Real} fadeAmount Partial fade amount.
/// @param {Real} fadeAngle Partial fade angle.
 function FX_Mist(_enabled, _intensity=0.5, _scale=0.5, _tiling=1, _speedd=0.2, _angle=0, _contrast=0.8, _power=1, _remap=0.8, _color=c_white, _mix=0, _mixThreshold=0, _noiseTex=undefined, _offset=[0.0,0.0], _fadeAmount=0, _fadeAngle=270) : __PPF_FXSuperClass() constructor {
	effectName = "mist";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	scale = _scale;
	tiling = _tiling;
	speedd = _speedd;
	angle = _angle;
	contrast = _contrast;
	powerr = _power;
	remapp = _remap;
	color = make_color_ppfx(_color);
	mix = _mix;
	mixThreshold = _mixThreshold;
	noiseTex = _noiseTex ?? __ppfxGlobal.textureNoisePerlin;
	offset = _offset;
	fadeAmount = _fadeAmount;
	fadeAngle = _fadeAngle;
	
	static u_mistEnable = shader_get_uniform(__ppf_shRenderFinal, "u_mistEnable");
	static u_mistIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_mistIntensity");
	static u_mistScale = shader_get_uniform(__ppf_shRenderFinal, "u_mistScale");
	static u_mistTiling = shader_get_uniform(__ppf_shRenderFinal, "u_mistTiling");
	static u_mistSpeed = shader_get_uniform(__ppf_shRenderFinal, "u_mistSpeed");
	static u_mistAngle = shader_get_uniform(__ppf_shRenderFinal, "u_mistAngle");
	static u_mistContrast = shader_get_uniform(__ppf_shRenderFinal, "u_mistContrast");
	static u_mistPower = shader_get_uniform(__ppf_shRenderFinal, "u_mistPower");
	static u_mistRemap = shader_get_uniform(__ppf_shRenderFinal, "u_mistRemap");
	static u_mistColor = shader_get_uniform(__ppf_shRenderFinal, "u_mistColor");
	static u_mistMix = shader_get_uniform(__ppf_shRenderFinal, "u_mistMix");
	static u_mistMixThreshold = shader_get_uniform(__ppf_shRenderFinal, "u_mistMixThreshold");
	static u_mistOffset = shader_get_uniform(__ppf_shRenderFinal, "u_mistOffset");
	static u_mistFadeAmount = shader_get_uniform(__ppf_shRenderFinal, "u_mistFadeAmount");
	static u_mistFadeAngle = shader_get_uniform(__ppf_shRenderFinal, "u_mistFadeAngle");
	static u_mistNoiseTexture = shader_get_sampler_index(__ppf_shRenderFinal, "u_mistNoiseTexture");
	static u_mistNoiseTextureUVs = shader_get_uniform(__ppf_shRenderFinal, "u_mistNoiseTextureUVs");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_mistEnable, enabled);
		shader_set_uniform_f(u_mistIntensity, intensity);
		shader_set_uniform_f(u_mistScale, scale);
		shader_set_uniform_f(u_mistTiling, tiling);
		shader_set_uniform_f(u_mistSpeed, speedd * 0.1);
		shader_set_uniform_f(u_mistAngle, -degtorad(angle));
		shader_set_uniform_f(u_mistContrast, contrast);
		shader_set_uniform_f(u_mistPower, powerr);
		shader_set_uniform_f(u_mistRemap, remapp);
		shader_set_uniform_f_array(u_mistColor, color);
		shader_set_uniform_f(u_mistMix, mix);
		shader_set_uniform_f(u_mistMixThreshold, mixThreshold);
		if (noiseTex != undefined) {
			texture_set_stage(u_mistNoiseTexture, noiseTex);
			var _texUVs = texture_get_uvs(noiseTex);
			shader_set_uniform_f(u_mistNoiseTextureUVs, _texUVs[0], _texUVs[1], _texUVs[2], _texUVs[3]);
		}
		//gpu_set_tex_repeat_ext(u_mistNoiseTexture, true);
		shader_set_uniform_f_array(u_mistOffset, offset);
		shader_set_uniform_f(u_mistFadeAmount, fadeAmount);
		shader_set_uniform_f(u_mistFadeAngle, -degtorad(fadeAngle));
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, scale, tiling, speedd, angle, contrast, powerr, remapp, ["color", color], mix, mixThreshold, ["texture", noiseTex], ["vec2", offset], fadeAmount, fadeAngle],
		};
	}
}

#endregion

#region Speedlines

/// @desc Anime-like speedlines effect. Useful for demonstrating amazement in visual novels or speed in racing games, among others.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} scale Noise scale. Values close to 0 make lines more stretched. 0 to 20 recommended.
/// @param {Real} tiling Repetition of noise rays. 1 to 16 recommended.
/// @param {Real} speedd Lines movement speed.
/// @param {Real} rotSpeed Rotation speed.
/// @param {Real} contrast Lines contrast.
/// @param {Real} power Helps make lines sharper. 0 to 1 recommended.
/// @param {Real} remap Central softness. 0 to 0.99 recommended.
/// @param {Real} color The speedlines color tint.
/// @param {Real} maskPower Defines the radial center area of the mask, based on position. 0 to 15 recommended.
/// @param {Real} maskScale Defines the radial mask scale. 0 to 3 recommended.
/// @param {Real} maskSmoothness Defines the mask border smoothness. 0 to 1.
/// @param {Pointer.Texture} noiseTexture The noise texture to be used by the effect.
function FX_SpeedLines(_enabled, _scale=0.1, _tiling=5, _speed=2, _rotSpeed=1, _contrast=0.5, _power=1, _remap=0.8, _color=c_white, _maskPower=5, _maskScale=1.2, _maskSmoothness=1, _noiseTexture=undefined) : __PPF_FXSuperClass() constructor {
	effectName = "speedlines";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	scale = _scale;
	tiling = _tiling;
	speedd = _speed;
	rotSpeed = _rotSpeed;
	contrast = _contrast;
	powerr = _power;
	remapp = _remap;
	color = make_color_ppfx(_color);
	maskPower = _maskPower;
	maskScale = _maskScale;
	maskSmoothness = _maskSmoothness;
	noiseTexture = _noiseTexture ?? __ppfxGlobal.textureNoiseSimplex;
	
	static u_speedlinesEnable = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesEnable");
	static u_speedlinesScale = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesScale");
	static u_speedlinesTiling = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesTiling");
	static u_speedlinesSpeed = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesSpeed");
	static u_speedlinesRotSpeed = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesRotSpeed");
	static u_speedlinesContrast = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesContrast");
	static u_speedlinesPower = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesPower");
	static u_speedlinesRemap = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesRemap");
	static u_speedlinesColor = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesColor");
	static u_speedlinesMaskPower = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesMaskPower");
	static u_speedlinesMaskScale = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesMaskScale");
	static u_speedlinesMaskSmoothness = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesMaskSmoothness");
	static u_speedlinesNoiseUVs = shader_get_uniform(__ppf_shRenderFinal, "u_speedlinesNoiseUVs");
	static u_speedlinesNoiseTex = shader_get_sampler_index(__ppf_shRenderFinal, "u_speedlinesNoiseTex");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_speedlinesEnable, enabled);
		shader_set_uniform_f(u_speedlinesScale, scale);
		shader_set_uniform_f(u_speedlinesTiling, tiling);
		shader_set_uniform_f(u_speedlinesSpeed, speedd);
		shader_set_uniform_f(u_speedlinesRotSpeed, rotSpeed);
		shader_set_uniform_f(u_speedlinesContrast, contrast);
		shader_set_uniform_f(u_speedlinesPower, powerr);
		shader_set_uniform_f(u_speedlinesRemap, remapp);
		shader_set_uniform_f(u_speedlinesMaskPower, maskPower);
		shader_set_uniform_f(u_speedlinesMaskScale, maskScale);
		shader_set_uniform_f(u_speedlinesMaskSmoothness, maskSmoothness);
		shader_set_uniform_f_array(u_speedlinesColor, color);
		if (noiseTexture != undefined) {
			var _noiseUVs = texture_get_uvs(noiseTexture);
			shader_set_uniform_f(u_speedlinesNoiseUVs, _noiseUVs[0], _noiseUVs[1], _noiseUVs[2], _noiseUVs[3]);
			texture_set_stage(u_speedlinesNoiseTex, noiseTexture);
		}
		gpu_set_tex_repeat_ext(u_speedlinesNoiseTex, true);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, scale, tiling, speedd, rotSpeed, contrast, powerr, remapp, ["color", color], maskPower, maskScale, maskSmoothness, ["texture", noiseTexture]],
		};
	}
}

#endregion

#region Dithering

/// @desc Dithering removes color banding artifacts in gradients, usually seen in sky boxes due to color quantization. It is also used for aesthetic purposes.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} mode Dithering technique to be used. 0 = Traditional | 1 = Custom | 2 = Custom | 3 = Luminance based
/// @param {Real} intensity How intense the dithering effect is applied.
/// @param {Real} bit_levels The color bit levels.
/// @param {Real} contrast The dithering contrast (not available in mode 0). Default is 1.
/// @param {Real} threshold Set the level of brightness to filter out pixels under this level. 0 to 1; 0 means all light pixels.
/// @param {Real} scale Pixel scale to compensate viewport size.
/// @param {Pointer.Texture} [bayerTexture] Bayer texture to be used by dithering. This is a small square texture.
/// @param {Real} bayerSize Dithering square texture sprite side size.
function FX_Dithering(_enabled, _mode=0, _intensity=1, _bitLevels=8, _contrast=1, _threshold=0, _scale=1, _bayerTexture=undefined, _bayerSize=8) : __PPF_FXSuperClass() constructor {
	effectName = "dithering";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	mode = _mode;
	intensity = _intensity;
	bitLevels = _bitLevels;
	contrast = _contrast;
	threshold = _threshold;
	scale = _scale;
	bayerTexture = _bayerTexture ?? __ppfxGlobal.texturebayer8x8;
	bayerSize = _bayerSize;
	
	static u_ditheringEnable = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringEnable");
	static u_ditheringMode = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringMode");
	static u_ditheringIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringIntensity");
	static u_ditheringBitLevels = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringBitLevels");
	static u_ditheringContrast = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringContrast");
	static u_ditheringThreshold = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringThreshold");
	static u_ditheringScale = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringScale");
	static u_ditheringBayerTexture = shader_get_sampler_index(__ppf_shRenderFinal, "u_ditheringBayerTexture");
	static u_ditheringBayerSize = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringBayerSize");
	static u_ditheringBayerUVs = shader_get_uniform(__ppf_shRenderFinal, "u_ditheringBayerUVs");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_ditheringEnable, enabled);
		shader_set_uniform_f(u_ditheringMode, mode);
		shader_set_uniform_f(u_ditheringIntensity, intensity);
		shader_set_uniform_f(u_ditheringBitLevels, bitLevels);
		shader_set_uniform_f(u_ditheringContrast, contrast);
		shader_set_uniform_f(u_ditheringThreshold, threshold);
		shader_set_uniform_f(u_ditheringScale, scale);
		shader_set_uniform_f(u_ditheringBayerSize, bayerSize);
		if (bayerTexture != undefined) {
			texture_set_stage(u_ditheringBayerTexture, bayerTexture);
			var _texUVs = texture_get_uvs(bayerTexture);
			shader_set_uniform_f(u_ditheringBayerUVs, _texUVs[0], _texUVs[1], _texUVs[2], _texUVs[3]);
		}
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, mode, intensity, bitLevels, contrast, threshold, scale, ["texture", bayerTexture], bayerSize],
		};
	}
}

#endregion

#region Noise Grain

/// @desc Simulates the random optical texture of photographic film, usually caused by small particles being present on the physical film;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Noise grain texture alpha. 0 to 1.
/// @param {Real} luminosity The brightness level of the noise. 0 to 1.
/// @param {Real} scale Noise scale. 0 to 1 recommended.
/// @param {Bool} speed Define if the Noise Grain speed.
/// @param {Bool} mix Defines the noise mixing. 1 = full mix.
/// @param {Pointer.Texture} noiseTexture Noise texture. Use sprite_get_texture() or surface_get_texture().
/// @param {Real} noiseSize Noise texture size. The size is used for both width and height. Example: 256 (pixels).
function FX_NoiseGrain(_enabled, _intensity=0.3, _luminosity=0.0, _scale=0.5, _speed=true, _mix=1, _noiseTexture=undefined, _noiseSize=256) : __PPF_FXSuperClass() constructor {
	effectName = "noise_grain";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	luminosity = _luminosity;
	scale = _scale;
	speedd = _speed;
	mix = _mix;
	noiseTexture = _noiseTexture ?? __ppfxGlobal.textureNoisePoint;
	noiseSize = _noiseSize;
	
	static u_noiseGrainEnable = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainEnable");
	static u_noiseGrainSize = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainSize");
	static u_noiseGrainIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainIntensity");
	static u_noiseGrainLuminosity = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainLuminosity");
	static u_noiseGrainScale = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainScale");
	static u_noiseGrainSpeed = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainSpeed");
	static u_noiseGrainMix = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainMix");
	static u_noiseGrainUVs = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainUVs");
	static u_noiseGrainTexture = shader_get_sampler_index(__ppf_shRenderFinal, "u_noiseGrainTexture");
	static u_noiseGrainTextureOffsets = shader_get_uniform(__ppf_shRenderFinal, "u_noiseGrainTextureOffsets");
	
	/// @ignore
	static __prng = function(_offseX, _offsetY, _t) {
		return frac(sin(dot_product(cos(_offseX + _t), sin(_offsetY + _t), 12.9898, 78.233)) * 43758.5453);
	}
	
	static Draw = function(_renderer, _surfaceWidth, _surfaceHeight, _time) {
		if (!enabled || intensity <= 0) exit;
		shader_set_uniform_f(u_noiseGrainEnable, enabled);
		shader_set_uniform_f(u_noiseGrainIntensity, intensity);
		shader_set_uniform_f(u_noiseGrainLuminosity, luminosity);
		shader_set_uniform_f(u_noiseGrainScale, scale);
		shader_set_uniform_f(u_noiseGrainSpeed, speedd);
		shader_set_uniform_f(u_noiseGrainMix, mix);
		if (noiseTexture != undefined) {
			shader_set_uniform_f(u_noiseGrainSize, noiseSize, noiseSize);
			var _noiseGrainUVs = texture_get_uvs(noiseTexture);
			shader_set_uniform_f(u_noiseGrainUVs, _noiseGrainUVs[0], _noiseGrainUVs[1], _noiseGrainUVs[2], _noiseGrainUVs[3]);
			texture_set_stage(u_noiseGrainTexture, noiseTexture);
			gpu_set_tex_repeat_ext(u_noiseGrainTexture, true);
		}
		var _spd = speedd;
		if (_spd > 0) {
			var _t = _time * 25;
			_t = floor(_t * _spd) / _spd;
			var _r1 = __prng(1, 2, _t);
			var _r2 = __prng(3, 4, _t);
			var _r3 = __prng(5, 6, _t);
			var _r4 = __prng(7, 8, _t);
			shader_set_uniform_f(u_noiseGrainTextureOffsets, _r1, _r2, _r3, _r4);
		} else {
			shader_set_uniform_f(u_noiseGrainTextureOffsets, 0, 0, 0, 0);
		}
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, luminosity, scale, speedd, mix, ["texture", noiseTexture], noiseSize],
		};
	}
}

#endregion

#region Nes Fade

/// @desc Simulation of the NES transition.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Fade amount. 1 is full dark.
/// @param {Real} levels Number of colors to be used (posterization).
function FX_NESFade(_enabled, _amount=0, _levels=8) : __PPF_FXSuperClass() constructor {
	effectName = "nes_fade";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	levels = _levels;
	
	static u_NESFadeEnable = shader_get_uniform(__ppf_shRenderFinal, "u_NESFadeEnable");
	static u_NESFadeAmount = shader_get_uniform(__ppf_shRenderFinal, "u_NESFadeAmount");
	static u_NESFadeLevels = shader_get_uniform(__ppf_shRenderFinal, "u_NESFadeLevels");
	
	static Draw = function(_renderer) {
		if (!enabled || amount <= 0) exit;
		shader_set_uniform_f(u_NESFadeEnable, enabled);
		shader_set_uniform_f(u_NESFadeAmount, amount);
		shader_set_uniform_f(u_NESFadeLevels, levels);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, levels],
		};
	}
}

#endregion

#region Cinema Bars

/// @desc Creates vertical and horizontal bars for artistic cinematic effects.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Bars level. 0 to 1.
/// @param {Real} intensity Bars alpha. 0 to 1.
/// @param {Real} intensity edge smoothness. 0 to 1. 0.002 is good for anti-aliasing.
/// @param {Real} color Bars color. Example: c_black.
/// @param {Bool} verticalEnable Enable vertical bars.
/// @param {Bool} horizontalEnable Enable horizontal bars.
/// @param {Bool} canDistort If active, the bars will distort according to the lens distortion effect.
function FX_CinemaBars(_enabled, _amount=0.2, _intensity=1, _smoothness=0, _color=c_black, _verticalEnable=true, _horizontalEnable=false, _canDistort=false) : __PPF_FXSuperClass() constructor {
	effectName = "cinema_bars";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	intensity = _intensity;
	smoothness = _smoothness;
	color = make_color_ppfx(_color);
	verticalEnable = _verticalEnable;
	horizontalEnable = _horizontalEnable;
	canDistort = _canDistort;
	
	static u_cinamaBarsEnable = shader_get_uniform(__ppf_shRenderFinal, "u_cinamaBarsEnable");
	static u_cinemaBarsAmount = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsAmount");
	static u_cinemaBarsIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsIntensity");
	static u_cinemaBarsSmoothness = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsSmoothness");
	static u_cinemaBarsColor = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsColor");
	static u_cinemaBarsVerticalEnable = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsVerticalEnable");
	static u_cinemaBarsHorizontalEnable = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsHorizontalEnable");
	static u_cinemaBarsCanDistort = shader_get_uniform(__ppf_shRenderFinal, "u_cinemaBarsCanDistort");
	
	static Draw = function(_renderer) {
		if (!enabled || amount <= 0) exit;
		shader_set_uniform_f(u_cinamaBarsEnable, enabled);
		shader_set_uniform_f(u_cinemaBarsAmount, amount);
		shader_set_uniform_f(u_cinemaBarsIntensity, intensity);
		shader_set_uniform_f(u_cinemaBarsSmoothness, smoothness);
		shader_set_uniform_f_array(u_cinemaBarsColor, color);
		shader_set_uniform_f(u_cinemaBarsVerticalEnable, verticalEnable);
		shader_set_uniform_f(u_cinemaBarsHorizontalEnable, horizontalEnable);
		shader_set_uniform_f(u_cinemaBarsCanDistort, canDistort);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, intensity, smoothness, ["color", color], verticalEnable, horizontalEnable, canDistort],
		};
	}
}

#endregion

#region Fade

/// @desc Simple fade to color effect (color overlay).
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} amount Fade amount. 1 is full blended.
/// @param {Real} color The fade color.
function FX_Fade(_enabled, _amount=0, _color=c_black) : __PPF_FXSuperClass() constructor {
	effectName = "fade";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	amount = _amount;
	color = make_color_ppfx(_color);
	
	static u_fadeEnable = shader_get_uniform(__ppf_shRenderFinal, "u_fadeEnable");
	static u_fadeAmount = shader_get_uniform(__ppf_shRenderFinal, "u_fadeAmount");
	static u_fadeColor = shader_get_uniform(__ppf_shRenderFinal, "u_fadeColor");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_fadeEnable, enabled);
		shader_set_uniform_f(u_fadeAmount, amount);
		shader_set_uniform_f_array(u_fadeColor, color);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, amount, ["color", color]],
		};
	}
}

#endregion

#region Scanlines

/// @desc Draw horizontal lines over the screen. It helps to simulate the effects of old CRT TVs.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Lines alpha. 0 to 1.
/// @param {Real} sharpness Lines sharpness. 0 to 1.
/// @param {Real} speedd Lines vertical movement speed. 0 to 5 recommended.
/// @param {Real} amount Lines amount. 0 to 1.
/// @param {Real} color Lines color tint. Example: c_black.
/// @param {Real} maskPower Defines the radial center area of the mask, based on position. 0 to 15 recommended.
/// @param {Real} maskScale Defines the radial mask scale. 0 to 3 recommended.
/// @param {Real} maskSmoothness Defines the mask border smoothness. 0 to 1.
function FX_ScanLines(_enabled, _intensity=0.1, _sharpness=0, _speed=0.3, _amount=0.7, _color=c_black, _maskPower=0, _maskScale=1.2, _maskSmoothness=1) : __PPF_FXSuperClass() constructor {
	effectName = "scanlines";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	sharpness = _sharpness;
	speedd = _speed;
	amount = _amount;
	color = make_color_ppfx(_color);
	maskPower = _maskPower;
	maskScale = _maskScale;
	maskSmoothness = _maskSmoothness;
	
	static u_scanlinesEnable = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesEnable");
	static u_scanlinesIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesIntensity");
	static u_scanlinesSharpness = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesSharpness");
	static u_scanlinesSpeed = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesSpeed");
	static u_scanlinesAmount = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesAmount");
	static u_scanlinesColor = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesColor");
	static u_scanlinesMaskPower = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesMaskPower");
	static u_scanlinesMaskScale = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesMaskScale");
	static u_scanlinesMaskSmoothness = shader_get_uniform(__ppf_shRenderFinal, "u_scanlinesMaskSmoothness");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_scanlinesEnable, enabled);
		shader_set_uniform_f(u_scanlinesIntensity, intensity);
		shader_set_uniform_f(u_scanlinesSharpness, sharpness);
		shader_set_uniform_f(u_scanlinesSpeed, speedd * 10);
		shader_set_uniform_f(u_scanlinesAmount, amount);
		shader_set_uniform_f_array(u_scanlinesColor, color);
		shader_set_uniform_f(u_scanlinesMaskPower, maskPower);
		shader_set_uniform_f(u_scanlinesMaskScale, maskScale);
		shader_set_uniform_f(u_scanlinesMaskSmoothness, maskSmoothness);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, sharpness, speedd, amount, ["color", color], maskPower, maskScale, maskSmoothness],
		};
	}
}

#endregion

#region Vignette

/// @desc Vignetting is the term for the darkening and/or desaturating towards the edges of an image compared to the center. You can use vignetting to draw focus to the center of an image;
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} intensity Vignette alpha/transparency.
/// @param {Real} curvature Vignette roundness.
/// @param {Real} inner The inside area of Vignette. From 0 to 2.
/// @param {Real} outer The outside area of Vignette. From 0 to 2.
/// @param {Real} color Vigentte color.
/// @param {Array<Real>} center The position. An array with the normalized values (0 to 1), in this format: [x, y].
/// @param {Bool} rounded Defines that the Vignette will be a perfect circle.
/// @param {Bool} linear Use a linear curve or not.
function FX_Vignette(_enabled, _intensity=0.7, _curvature=0.3, _inner=0.3, _outer=1, _color=c_black, _center=[0.5,0.5], _rounded=false, _linear=false) : __PPF_FXSuperClass() constructor {
	effectName = "vignette";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	intensity = _intensity;
	curvature = _curvature;
	inner = _inner;
	outer = _outer;
	color = make_color_ppfx(_color);
	center = _center;
	rounded = _rounded;
	linear = _linear;
	
	static u_vignetteEnable = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteEnable");
	static u_vignetteIntensity = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteIntensity");
	static u_vignetteCurvature = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteCurvature");
	static u_vignetteInner = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteInner");
	static u_vignetteOuter = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteOuter");
	static u_vignetteColor = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteColor");
	static u_vignetteCenter = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteCenter");
	static u_vignetteRounded = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteRounded");
	static u_vignetteLinear = shader_get_uniform(__ppf_shRenderFinal, "u_vignetteLinear");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_vignetteEnable, enabled);
		shader_set_uniform_f(u_vignetteIntensity, intensity);
		shader_set_uniform_f(u_vignetteCurvature, clamp(curvature, 0.02, 1));
		shader_set_uniform_f(u_vignetteInner, inner);
		shader_set_uniform_f(u_vignetteOuter, outer);
		shader_set_uniform_f_array(u_vignetteColor, color);
		shader_set_uniform_f_array(u_vignetteCenter, center);
		shader_set_uniform_f(u_vignetteRounded, rounded);
		shader_set_uniform_f(u_vignetteLinear, linear);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, intensity, curvature, inner, outer, ["color", color], ["vec2", center], rounded, linear],
		};
	}
}

#endregion

#region Color Blindness

/// @desc Try to fix color blindness of Protanopia, Deutanopia and Tritanopia.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} mode Fix mode: 0 > Protanopia | 1 > Deutanopia | 2 > Tritanopia.
function FX_ColorBlindness(_enabled, _mode=0) : __PPF_FXSuperClass() constructor {
	effectName = "color_blindness";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	mode = _mode;
	
	static u_colorBlindnessEnable = shader_get_uniform(__ppf_shRenderFinal, "u_colorBlindnessEnable");
	static u_colorBlindnessMode = shader_get_uniform(__ppf_shRenderFinal, "u_colorBlindnessMode");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_colorBlindnessEnable, enabled);
		shader_set_uniform_f(u_colorBlindnessMode, mode);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, mode],
		};
	}
}

#endregion

#region Channels

/// @desc Sets color levels per channel.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {real} red The red amount. 0 to 1.
/// @param {real} green The green amount. 0 to 1.
/// @param {real} blue The blue amount. 0 to 1.
function FX_Channels(_enabled, _red=1, _green=1, _blue=1) : __PPF_FXSuperClass() constructor {
	effectName = "channels";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	red = _red;
	green = _green;
	blue = _blue;
	
	static u_channelsEnable = shader_get_uniform(__ppf_shRenderFinal, "u_channelsEnable");
	static u_channelRGB = shader_get_uniform(__ppf_shRenderFinal, "u_channelRGB");
	
	static Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_channelsEnable, enabled);
		shader_set_uniform_f(u_channelRGB, red, green, blue);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, red, green, blue],
		};
	}
}

#endregion

#region Border

/// @desc Creates an edge gradient effect at the corners of the screen. Intended to be used when using Lens Distortion effect, to hide non-UV artifacts.
/// @param {Bool} enabled Defines whether the effect starts active or not.
/// @param {Real} curvature The border curvature. 0 to 1 recommended.
/// @param {Real} smooth Border smoothness. 0 to 1 recommended.
/// @param {Real} color The border color. Example: c_black.
function FX_Border(_enabled, _curvature=0, _smooth=0, _color=c_black) : __PPF_FXSuperClass() constructor {
	effectName = "border";
	canChangeOrder = false;
	stackOrder = PPFX_STACK.FINAL;
	isStackShared = true;
	
	enabled = _enabled;
	curvature = _curvature;
	smooth = _smooth;
	color = make_color_ppfx(_color);
	
	static u_borderEnable = shader_get_uniform(__ppf_shRenderFinal, "u_borderEnable");
	static u_borderCurvature = shader_get_uniform(__ppf_shRenderFinal, "u_borderCurvature");
	static u_borderSmooth = shader_get_uniform(__ppf_shRenderFinal, "u_borderSmooth");
	static u_borderColor = shader_get_uniform(__ppf_shRenderFinal, "u_borderColor");
	
	Draw = function(_renderer) {
		if (!enabled) exit;
		shader_set_uniform_f(u_borderEnable, enabled);
		shader_set_uniform_f(u_borderCurvature, clamp(curvature, 0.001, 1));
		shader_set_uniform_f(u_borderSmooth, smooth);
		shader_set_uniform_f_array(u_borderColor, color);
	}
	
	/// @ignore
	static ExportData = function() {
		return {
			name : instanceof(self),
			params : [enabled, curvature, smooth, ["color", color]],
		};
	}
}

#endregion

#endregion

