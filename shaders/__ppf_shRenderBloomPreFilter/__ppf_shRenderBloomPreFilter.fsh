
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

/* Original implementation by Keijiro Takahashi, 2015-2016 (MIT license).
 * GameMaker Integration and Improvements by Mozart Junior, 2023-2024.*/

varying vec2 v_vTexcoord;

uniform vec2 u_texelSize;
uniform float u_bloomThreshold;
uniform float u_bloomIntensity;
uniform float u_bloomKnee;

float Brightness(vec3 col) {
	return max(max(col.r, col.g), col.b);
}

// standard box filtering
vec4 SampleBox4Antiflicker(sampler2D tex, vec2 uv, float delta) {
	vec4 d = u_texelSize.xyxy * vec2(-delta, delta).xxyy;
	
	vec4 s1 = texture2D(tex, uv + d.xy);
	vec4 s2 = texture2D(tex, uv + d.zy);
	vec4 s3 = texture2D(tex, uv + d.xw);
	vec4 s4 = texture2D(tex, uv + d.zw);
	
	// Karis's luma weighted average (using brightness instead of luma)
	float s1w = 1.0 / (Brightness(s1.rgb) + 1.0);
	float s2w = 1.0 / (Brightness(s2.rgb) + 1.0);
	float s3w = 1.0 / (Brightness(s3.rgb) + 1.0);
	float s4w = 1.0 / (Brightness(s4.rgb) + 1.0);
	float one_div_wsum = 1.0 / (s1w + s2w + s3w + s4w);
	
	return (s1 * s1w + s2 * s2w + s3 * s3w + s4 * s4w) * one_div_wsum;
}

vec3 Threshold(vec3 color) {
	return max((color - u_bloomThreshold) * mix(1.0, u_bloomIntensity, u_bloomKnee), 0.0);
}
		
void main() {
	gl_FragColor = vec4(Threshold(SampleBox4Antiflicker(gm_BaseTexture, v_vTexcoord, 0.5).rgb), 1.0);
}
