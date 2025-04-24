
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

precision highp float;

varying vec2 v_vTexcoord;

// >> uniforms
uniform float u_row;
uniform float u_threshold;
uniform float u_smoothness;
uniform float u_flip;
uniform vec4 u_paletteUVs;
uniform sampler2D u_paletteTexture;

const vec3 lumWeights = vec3(0.2126729, 0.7151522, 0.0721750);
float GetLuminance(vec3 color) {
	return dot(color, lumWeights);
}

void main() {
	vec4 mainTex = texture2D(gm_BaseTexture, v_vTexcoord);
	mainTex.rgb = max(mainTex.rgb, 0.0);
	
	float lum = GetLuminance(mainTex.rgb);
	lum = mix(lum, 1.0-lum, step(0.5, u_flip));
	
	vec2 uv2 = clamp(vec2(lum, u_row), 0.0, 1.0);
	vec3 texPalette = texture2D(u_paletteTexture, mix(u_paletteUVs.xy, u_paletteUVs.zw, uv2)).rgb;
	
	float rate = smoothstep(u_threshold-u_smoothness, u_threshold, length(mainTex.rgb - texPalette.rgb));
	mainTex.rgb = mix(mainTex.rgb, texPalette, rate);
	
	gl_FragColor = mainTex;
}
