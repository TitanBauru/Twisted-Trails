
precision highp float;

// from ShadowCaster
attribute vec4 in_Colour; // positionXY, depth, farZ
attribute vec4 in_Colour2; // texCoordXY, shadowLength, penumbraOffset

// from light
uniform vec2 u_params; // shadowScattering, shadowDepthOffset
uniform vec2 u_params2; // xDir, yDir

void main() {
	// (C) 2025, Mozart Junior (@foxyofjungle) (https://foxyofjungle.itch.io/)
	// Inspired by Slembcke (https://slembcke.github.io/SuperFastSoftShadows)
	float shadowLen = u_params.x + in_Colour2.z;
	vec2 shadowPos = in_Colour.xy + (in_Colour.w*u_params2.xy*shadowLen);
	
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(shadowPos, in_Colour.z+u_params.y, 1.0);
}
