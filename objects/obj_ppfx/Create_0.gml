// Disable default game rendering. Call it only once.
application_surface_draw_enable(false);

global.aberracao_cromatica = 0

// Create ppfx system.
ppfx_id = new PPFX_System();

// Create profile with all effects.
var effects = [
    new FX_ChromaticAberration(true,global.aberracao_cromatica,,0,0,1),
	new FX_Border(true,.15,.25),
	new FX_VHS(false,4,2,0.7),//Opcional
	new FX_ScanLines(true, 0.2, 0, 1.5, 0.5),//Não Opcional
	new FX_NoiseGrain(true, 0.25, 0.5, true),//Não Opcional
	new FX_Bloom(true,,0.4,.75),
	new FX_Shockwaves(true,.25,1)
];
main_profile = new PPFX_Profile("Main", effects);

// Load profile, so all effects will be used.
ppfx_id.ProfileLoad(main_profile);

//Shockwave
shockwaves_renderer_id = new PPFX_ShockwaveRenderer();
shockwaves_renderer_id.AddObject(__obj_ppf_shockwave);



