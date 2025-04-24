
/*==================================================================================================
	Here you can modify some library behaviors.
	You don't need to call this script, it runs automatically.
	
	If you want to change the quality of Blurs (radial, motion...), Sunshafts and others, modify the
	"ITERATIONS" variable of each one in the pixel shader. Most effects don't need this.
	
	Some effects let you set the resolution. They have a parameter called "downscale", like
	Bloom and Depth of Field.
==================================================================================================*/

// Debug messages from Post-Processing FX
// 0 > Disabled.
// 1 > Error debug messages.
// 2 > Error debug messages + Warnings. (default)
// 3 > Error debug messages + Warnings + Create/Destroy systems + Load Profiles, etc.
#macro PPFX_CFG_TRACE_LEVEL 2

// Enable error checking of Post-Processing FX functions (disabling this will increase CPU-side performance)
#macro PPFX_CFG_ERROR_CHECKING_ENABLE true

// Default time (in seconds) to reset the PPFX_Renderer timer (-1 for unlimited). Useful for Mobile devices, for low precision reasons
// note: you can change this per PPFX_Renderer(), by using .SetTimer().
#macro PPFX_CFG_TIMER -1 // 3600 seconds = 60 minutes (1 hour)

// HDR textures format, generally not recommended to change.
// Should be surface_rgba16float (16 bits) or surface_rgba32float (32 bits - more VRAM usage!)
#macro PPFX_CFG_HDR_TEX_FORMAT surface_rgba16float

// Color Curves, curve file format
#macro PPFX_CFG_COLOR_CURVES_FORMAT ".crv"

// Epsilon is used to avoid division by 0 and other precision things. It is generally not recommended to modify it.
// Never set it to 0, as some things will not work properly.
#macro PPFX_CFG_EPSILON 0.001

// Default stack rendering order. Can be any order. Imagine them as layers, the top ones are drawn first.
// Note that it is also possible to change the order of effects with .SetOrder() too...
// https://kazangames.com/assets/ppfx/docs/v4/#/./pages/technical/effects_draw_order
// NOTE: this order has been carefully defined, changes may cause some effects to look ugly (it's not a bug).
enum PPFX_STACK {
		BASE,
	BLOOM,
	SUNSHAFTS,
	LONG_EXPOSURE,
		COLOR_GRADING,
	PALETTE_SWAP,
	DEPTH_OF_FIELD,
	MOTION_BLUR,
	BLUR_RADIAL,
	TEXTURE_OVERLAY,
	LENS_FLARES,
	BLUR_KAWASE,
	BLUR_GAUSSIAN,
	GLITCH,
	VHS,
	ASCII,
	CHROMATIC_ABERRATION,
	HQ4X,
		FINAL,
	SHARPEN,
	FXAA,
	COMPARE,
	__SIZE,
}
