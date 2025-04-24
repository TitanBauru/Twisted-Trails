// Disable default game rendering. Call it only once.
application_surface_draw_enable(false);

global.aberracao_cromatica = 0


// Create a post-processing renderer.
renderer = new PPFX_Renderer();



// Create profile with all effects.
var effects = [
    new FX_ChromaticAberration(true,global.aberracao_cromatica,,0,0,1),
	new FX_Border(true,.15,.25),
	new FX_VHS(false,4,2,0.7),//Opcional
	new FX_ScanLines(true, 0.2, 0, 1.5, 0.5),//Não Opcional
	new FX_NoiseGrain(true, 0.25, 0.5, true),//Não Opcional
	new FX_Bloom(true,,0.4,.5,.25),
	new FX_Shockwaves(true,.05,0)
];
mainProfile = new PPFX_Profile("Main", effects);

// Load profile, so all effects will be used.
renderer.ProfileLoad(mainProfile);


// init shockwaves distortion surface
shockwavesRenderer = new PPFX_ShockwaveRenderer();

