
// Feather ignore all

#macro PPFX_VERSION "v5.0"
#macro PPFX_RELEASE_DATE "March, 27, 2025"

show_debug_message($"Post-Processing FX {PPFX_VERSION} | Copyright (C) 2025 FoxyOfJungle");

// ========================================================================================

/// @ignore
function __ppfxGlobal() {
	// Default textures
	static textureWhitePixel = sprite_get_texture(__ppf_sprPixel, 0);
	static textureNoisePoint = sprite_get_texture(__ppf_sprNoisePoint, 0);
	static textureNoisePerlin = sprite_get_texture(__ppf_sprNoisePerlin, 0);
	static textureNoiseSimplex = sprite_get_texture(__ppf_sprNoiseSimplex, 0);
	static textureNormal = sprite_get_texture(__ppf_sprNormal, 0);
	static texturePalette = sprite_get_texture(__ppf_sprPalDefault, 0);
	static textureNeutralLUT = sprite_get_texture(__ppf_sprNeutralLUTGrid, 0);
	static textureDirtLens = sprite_get_texture(__ppf_sprDirtLens, 0);
	static textureChromaberPrismaLut = sprite_get_texture(__ppf_sprPrismLutRB, 0);
	static textureShockwavesPrismaLut = sprite_get_texture(__ppf_sprPrismLutCP, 0);
	static texturebayer16x16 = sprite_get_texture(__ppf_sprBayer16x16, 0);
	static texturebayer8x8 = sprite_get_texture(__ppf_sprBayer8x8, 0);
	static texturebayer4x4 = sprite_get_texture(__ppf_sprBayer4x4, 0);
	static texturebayer2x2 = sprite_get_texture(__ppf_sprBayer2x2, 0);
	static textureASCII = sprite_get_texture(__ppf_sprASCII, 0);
}

// Crystal init
// at the time this is called, everything in scripts are available
__ppfxGlobal();
