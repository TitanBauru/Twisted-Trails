
/*-------------------------------------------------------------------------------------------------
	These functions are independent, so if you delete them from the asset, nothing will happen.
-------------------------------------------------------------------------------------------------*/

// Feather ignore all
/// @desc Draw part of the post-processing renderer surface in a rectangular area.
/// @param {Real} x The x coordinate of where to draw the sprite.
/// @param {Real} y The y coordinate of where to draw the sprite.
/// @param {Real} w The width of the area.
/// @param {Real} h The height of the area.
/// @param {Real} xOffset Defined by position X, minus this offset variable. Use 0 in the GUI dimension.
/// @param {Real} yOffset Defined by position Y, minus this offset variable. Use 0 in the GUI dimension.
/// @param {Struct} renderer The returned variable by PPFX_Renderer().
/// @returns {Undefined}
function area_draw_rect(_x, _y, _w, _h, _xOffset, _yOffset, _renderer) {
	if (!__ppf_renderer_exists(_renderer)) exit;
	var _surf = _renderer.__stackSurfaces[_renderer.__stackIndex];
	if (surface_exists(_surf)) draw_surface_part(_surf, _x-_xOffset, _y-_yOffset, _w, _h, _x, _y);
}

/// @desc Draw a normal sprite, but its texture is the post-processing texture.
/// @param {Asset.GMSprite} sprite The sprite index to be used as a mask. It can be any color. It will only be used to "cut" the surface.
/// @param {Real} subimg The subimg (frame) of the sprite to draw (image_index or -1 correlate to the current frame of animation in the object).
/// @param {Real} x The x coordinate of where to draw the sprite.
/// @param {Real} y The y coordinate of where to draw the sprite.
/// @param {Struct} _renderer The returned variable by PPFX_Renderer().
/// @returns {Undefined}
function area_draw_sprite_mask(_sprite, _subimg, _x, _y, _renderer) {
	if (!__ppf_renderer_exists(_renderer)) exit;
	var _surf = _renderer.__stackSurfaces[_renderer.__stackIndex];
	if (surface_exists(_surf)) {
		shader_set(__ppf_shSpriteMask);
		texture_set_stage(shader_get_sampler_index(__ppf_shSpriteMask, "u_renderTexture"), surface_get_texture(_surf));
		draw_sprite(_sprite, _subimg, _x, _y);
		shader_reset();
	}
}

/// @desc Draw a normal sprite extended, but its texture is the post-processing texture.
/// @param {Asset.GMSprite} sprite The sprite index to be used as a mask. It can be any color. It will only be used to "cut" the surface.
/// @param {Real} subimg The subimg (frame) of the sprite to draw (image_index or -1 correlate to the current frame of animation in the object).
/// @param {Real} x The x coordinate of where to draw the sprite.
/// @param {Real} y The y coordinate of where to draw the sprite.
/// @param {Real} xScale The horizontal scaling of the sprite, as a multiplier: 1 = normal scaling, 0.5 is half etc...
/// @param {Real} yScale The vertical scaling of the sprite as a multiplier: 1 = normal scaling, 0.5 is half etc...
/// @param {Real} rot The rotation of the sprite. 0=right way up, 90=rotated 90 degrees counter-clockwise etc...
/// @param {Real} color The color of the sprite.
/// @param {Real} alpha The alpha of the sprite.
/// @param {Struct} renderer The returned variable by PPFX_Renderer().
/// @returns {Undefined}
function area_draw_sprite_ext_mask(_sprite, _subimg, _x, _y, _xScale, _yScale, _rot, _color, _alpha, _renderer) {
	if (!__ppf_renderer_exists(_renderer)) exit;
	var _surf = _renderer.__stackSurfaces[_renderer.__stackIndex];
	if (surface_exists(_surf)) {
		shader_set(__ppf_shSpriteMask);
		texture_set_stage(shader_get_sampler_index(__ppf_shSpriteMask, "u_renderTexture"), surface_get_texture(_surf));
		draw_sprite_ext(_sprite, _subimg, _x, _y, _xScale, _yScale, _rot, _color, _alpha);
		shader_reset();
	}
}

/// @desc Draw a normal sprite stretched, but its texture is the post-processing texture.
/// @param {Asset.GMSprite} sprite The sprite index to be used as a mask. It can be any color. It will only be used to "cut" the surface.
/// @param {Real} subimg The subimg (frame) of the sprite to draw (image_index or -1 correlate to the current frame of animation in the object).
/// @param {Real} x The x coordinate of where to draw the sprite.
/// @param {Real} y The y coordinate of where to draw the sprite.
/// @param {Real} w The width of the sprite.
/// @param {Real} h The height of the sprite.
/// @param {Struct} renderer The returned variable by PPFX_Renderer().
/// @returns {Undefined}
function area_draw_sprite_stretched_mask(_sprite, _subimg, _x, _y, _w, _h, _renderer) {
	if (!__ppf_renderer_exists(_renderer)) exit;
	var _surf = _renderer.__stackSurfaces[_renderer.__stackIndex];
	if (surface_exists(_surf)) {
		shader_set(__ppf_shSpriteMask);
		texture_set_stage(shader_get_sampler_index(__ppf_shSpriteMask, "u_renderTexture"), surface_get_texture(_surf));
		draw_sprite_stretched(_sprite, _subimg, _x, _y, _w, _h);
		shader_reset();
	}
}

/// @desc Draw a normal sprite stretched extended, but its texture is the post-processing texture.
/// @param {Asset.GMSprite} sprite The sprite index to be used as a mask. It can be any color. It will only be used to "cut" the surface.
/// @param {Real} subimg The subimg (frame) of the sprite to draw (image_index or -1 correlate to the current frame of animation in the object).
/// @param {Real} x The x coordinate of where to draw the sprite.
/// @param {Real} y The y coordinate of where to draw the sprite.
/// @param {Real} w The width of the sprite.
/// @param {Real} h The height of the sprite.
/// @param {Real} color The color of the sprite.
/// @param {Real} alpha The alpha of the sprite.
/// @param {Struct} renderer The returned variable by PPFX_Renderer().
/// @returns {Undefined}
function area_draw_sprite_stretched_ext_mask(_sprite, _subimg, _x, _y, _w, _h, _color, _alpha, _renderer) {
	if (!__ppf_renderer_exists(_renderer)) exit;
	var _surf = _renderer.__stackSurfaces[_renderer.__stackIndex];
	if (surface_exists(_surf)) {
		shader_set(__ppf_shSpriteMask);
		texture_set_stage(shader_get_sampler_index(__ppf_shSpriteMask, "u_renderTexture"), surface_get_texture(_surf));
		draw_sprite_stretched_ext(_sprite, _subimg, _x, _y, _w, _h, _color, _alpha);
		shader_reset();
	}
}
