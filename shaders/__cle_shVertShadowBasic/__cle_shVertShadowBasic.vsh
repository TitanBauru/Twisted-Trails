
precision highp float;

// from ShadowCaster
attribute vec4 in_Colour; // positionXY, depth, farZ
attribute vec4 in_Colour2; // texCoordXY, shadowLength, penumbraOffset

// from light
uniform vec2 u_params; // shadowScattering, shadowDepthOffset
uniform vec2 u_params2; // 2d light position

void main() {
	// (C) 2025, Mozart Junior (@foxyofjungle) (https://foxyofjungle.itch.io/)
	// Inspired by Slembcke (https://slembcke.github.io/SuperFastSoftShadows)
	float shadowLen = u_params.x + in_Colour2.z;
	vec2 lightDir = in_Colour.xy - u_params2.xy;
	vec2 shadowPos = in_Colour.xy + (in_Colour.w*lightDir*shadowLen);
	
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(shadowPos, in_Colour.z+u_params.y, 1.0);
}
