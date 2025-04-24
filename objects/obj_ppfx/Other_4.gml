/// @description Insert description here
// You can write your code in this editor
// Create a exclusive post-processing system for the layer
<<<<<<< Updated upstream

if (room == rm_game) {
	layer_effects_id = new PPFX_System();

	// Create a profile with effects, for the system
	var _layer_profile = new PPFX_Profile("Cool Effect", [
	    new FX_Bloom(true,8,.5,1),
	    new FX_SunShafts(true, [.5, .5], 0.2, 2,,, 0.3, true),
	]);

	// Load profile
	layer_effects_id.ProfileLoad(_layer_profile);
	layer_renderer = new PPFX_LayerRenderer();
	layer_renderer.Apply(layer_effects_id, layer_get_id("Trail"), layer_get_id("Trail")); 

	layer_effects_id_bloom = new PPFX_System();

	// Create a profile with effects, for the system
	var _layer_profile = new PPFX_Profile("Cool Effect", [
	    new FX_Bloom(true,8,.4,1.25),
		//new FX_Pixelize(true,0.4,10,30)
	]);

	// Load profile
	layer_effects_id_bloom.ProfileLoad(_layer_profile);
	layer_renderer_bloom = new PPFX_LayerRenderer();
	layer_renderer_bloom.Apply(layer_effects_id_bloom, layer_get_id("Bloom"), layer_get_id("Bloom")); 
}
=======
layer_effects_id = new PPFX_Renderer();

// Create a profile with effects, for the system
var _layer_profile = new PPFX_Profile("Cool Effect", [
    new FX_Bloom(true,8,.5,1,1),
    new FX_SunShafts(true, [.5, .5], 0.2, 2,,, 0.3, true),
]);

// Load profile
layer_effects_id.ProfileLoad(_layer_profile);
layer_effects_id.LayerApply(layer_get_id("Trail"), layer_get_id("Trail")); 

layer_effects_id_bloom = new PPFX_Renderer();

// Create a profile with effects, for the system
var _layer_profile = new PPFX_Profile("Cool Effect", [
    new FX_Bloom(true,8,.4,1.25,1.25),
	//new FX_Pixelize(true,0.4,10,30)
]);

// Load profile
layer_effects_id_bloom.ProfileLoad(_layer_profile);
layer_effects_id_bloom.LayerApply(layer_get_id("Bloom"), layer_get_id("Bloom")); 
>>>>>>> Stashed changes
