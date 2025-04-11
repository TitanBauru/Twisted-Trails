
/*=============================================================================================
	Here you can modify some Crystal behaviors.
	You don't need to call this script, it runs automatically.
	
	This is the only place you need to backup (if necessary) before upgrading Crystal.
	
	Open the "__cle_shDeferredRender" shader (CTRL + T) to enable/disable the following:
	(You can do this to get the best performance possible, based on what you want)
	- Dithering
	- LUT Ambient Light
	
	Documentation: https://kazangames.com/assets/crystal/docs/
=============================================================================================*/

// Debug messages from Crystal Lighting Engine
// 0 > Disabled.
// 1 > Error debug messages.
// 2 > Error debug messages + Warnings. (default)
// 3 > Error debug messages + Warnings + Create/Destroy systems, etc.
#macro CLE_CFG_TRACE_LEVEL 2

// Enable error checking of Crystal Lighting Engine functions (disabling this will increase CPU-side performance)
#macro CLE_CFG_ERROR_CHECKING_ENABLE true

// HDR textures format, generally not recommended to change.
// Should be surface_rgba16float (16 bits) or surface_rgba32float (32 bits - more VRAM usage!)
#macro CLE_CFG_HDR_TEXTURE_FORMAT surface_rgba16float

// Enable this if the lighting system needs to take camera rotation into consideration to draw correctly. Disabling it improves performance.
// Set to false if you are sure your rendering camera will NEVER rotate.
#macro CLE_CFG_CAMERA_ROTATION true

// Epsilon is used to avoid division by 0 and other precision things. It is generally not recommended to modify it.
// Never set it to 0, as some things like shadows, point lights and spot lights will not work properly.
#macro CLE_CFG_EPSILON 0.001

// Suffixes used in Crystal_Material, when using .From*() functions.
// Example, you have a "sprPlayer" sprite. With the suffix, it will be "sprPlayerNormal", for example.
#macro CLE_CFG_MAT_SUFFIX_NORMAL "Normal"
#macro CLE_CFG_MAT_SUFFIX_EMISSIVE "Emissive"
#macro CLE_CFG_MAT_SUFFIX_METALLIC "Metallic"
#macro CLE_CFG_MAT_SUFFIX_ROUGHNESS "Roughness"
#macro CLE_CFG_MAT_SUFFIX_AO "Ao"
#macro CLE_CFG_MAT_SUFFIX_MASK "Mask"
#macro CLE_CFG_MAT_SUFFIX_REFLECTION "Reflection"
