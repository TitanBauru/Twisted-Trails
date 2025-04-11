// Create Event
// create system responsible for rendering lights, shadows, materials, etc.
renderer = new Crystal_Renderer();
renderer.SetRenderEnable(true);
renderer.SetDrawEnable(false); // disable it if using post processing
renderer.SetLightsBlendmode(1);
renderer.SetCullingEnable(-1)

global.escuridao_valor = 0.5

// Enable depth buffer and alpha test
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

//gpu_set_alphatestref(1);  
application_surface_draw_enable(false); 
timeCycle = new Crystal_TimeCycle([sprLUTearlyMorning, sprLUTafternoon, sprLUTSunset, sprLUTNight], true, 20, true);
timeCycle.SetTime(12);
timeCycle.Apply();
