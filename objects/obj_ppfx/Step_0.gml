/// @description Insert description here
// You can write your code in this editor

//Aberração Cromática
global.aberracao_cromatica = lerp(global.aberracao_cromatica,0,.01)
renderer.SetEffectParameter(FF_CHROMATIC_ABERRATION, PP_CHROMABER_INTENSITY, global.aberracao_cromatica);

